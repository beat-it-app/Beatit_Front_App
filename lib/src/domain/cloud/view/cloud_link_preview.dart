import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_appbar.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_preview_background.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:url_launcher/url_launcher.dart';

enum _LinkPreviewLoadState { loading, ready, error }

class CloudLinkPreview extends StatefulWidget {
  const CloudLinkPreview({
    super.key,
    required this.folderName,
    required this.files,
    required this.onDeletePressed,
    required this.onMovePressed,
    this.initialIndex = 0,
    this.onFileSelected,
  }) : assert(files.length > 0, 'files에는 하나 이상의 파일이 필요합니다.'),
       assert(
         initialIndex >= 0 && initialIndex < files.length,
         'initialIndex가 files 범위를 벗어났습니다.',
       );

  final String folderName;
  final List<CloudFilePreviewItem> files;
  final int initialIndex;

  final ValueChanged<CloudFilePreviewItem> onDeletePressed;
  final ValueChanged<CloudFilePreviewItem> onMovePressed;

  /// 링크 외 파일을 선택했을 때 해당 형식의 Preview 화면으로 이동시키는 진입점이다.
  final ValueChanged<CloudFilePreviewItem>? onFileSelected;

  @override
  State<CloudLinkPreview> createState() => _CloudLinkPreviewState();
}

class _CloudLinkPreviewState extends State<CloudLinkPreview> {
  late int _currentIndex;

  _LinkPreviewLoadState _loadState = _LinkPreviewLoadState.loading;
  Metadata? _metadata;
  int _requestId = 0;

  CloudFilePreviewItem get _currentFile => widget.files[_currentIndex];

  Uri? get _currentLinkUri {
    final uri = _currentFile.previewUri;
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return null;
    }

    return uri;
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _loadMetadata(resetState: false);
  }

  Future<void> _showFileList() async {
    final selectedIndex = await showCloudPreviewFileListBottomSheet(
      context: context,
      folderName: widget.folderName,
      itemCount: widget.files.length,
      itemBuilder: (sheetContext, index) {
        final file = widget.files[index];

        return CloudItemWidget(
          itemType: file.type.cloudItemType,
          fileName: file.name,
          fileSize: file.sizeLabel,
          uploadedAt: file.uploadedAt,
          uploaderName: file.uploaderName,
          isSelected: index == _currentIndex,
          showMoreMenu: false,
          onTap: () {
            Navigator.of(sheetContext).pop(index);
          },
        );
      },
    );

    if (!mounted || selectedIndex == null || selectedIndex == _currentIndex) {
      return;
    }

    final selectedFile = widget.files[selectedIndex];

    if (selectedFile.type != CloudPreviewFileType.link) {
      widget.onFileSelected?.call(selectedFile);
      return;
    }

    setState(() {
      _currentIndex = selectedIndex;
      _loadState = _LinkPreviewLoadState.loading;
      _metadata = null;
    });

    await _loadMetadata(resetState: false);
  }

  Future<void> _loadMetadata({bool resetState = true}) async {
    final requestId = ++_requestId;
    final uri = _currentLinkUri;

    if (resetState && mounted) {
      setState(() {
        _loadState = _LinkPreviewLoadState.loading;
        _metadata = null;
      });
    }

    if (uri == null) {
      if (!mounted || requestId != _requestId) {
        return;
      }

      if (resetState) {
        setState(() {
          _loadState = _LinkPreviewLoadState.error;
          _metadata = null;
        });
      } else {
        _loadState = _LinkPreviewLoadState.error;
        _metadata = null;
      }
      return;
    }

    try {
      final metadata = await MetadataFetch.extract(uri.toString());

      if (!mounted || requestId != _requestId) {
        return;
      }

      setState(() {
        _metadata = metadata;
        _loadState = metadata == null
            ? _LinkPreviewLoadState.error
            : _LinkPreviewLoadState.ready;
      });
    } catch (error, stackTrace) {
      debugPrint('CloudLinkPreview metadata load failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted || requestId != _requestId) {
        return;
      }

      setState(() {
        _metadata = null;
        _loadState = _LinkPreviewLoadState.error;
      });
    }
  }

  Future<void> _openCurrentLink() async {
    final uri = _currentLinkUri;
    if (uri == null) {
      _showOpenLinkError();
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        _showOpenLinkError();
      }
    } catch (error, stackTrace) {
      debugPrint('CloudLinkPreview launch failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        _showOpenLinkError();
      }
    }
  }

  void _showOpenLinkError() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('링크를 열 수 없습니다. 다시 시도해주세요.')),
      );
  }

  Uri? _metadataDisplayUri() {
    final currentUri = _currentLinkUri;
    final metadataUrl = _metadata?.url?.trim();

    if (metadataUrl == null || metadataUrl.isEmpty) {
      return currentUri;
    }

    final parsed = Uri.tryParse(metadataUrl);
    if (parsed == null) {
      return currentUri;
    }

    if (parsed.hasScheme) {
      return parsed;
    }

    return currentUri?.resolve(metadataUrl);
  }

  Uri? _metadataImageUri() {
    final currentUri = _currentLinkUri;
    final imageUrl = _metadata?.image?.trim();

    if (imageUrl == null || imageUrl.isEmpty) {
      return null;
    }

    final parsed = Uri.tryParse(imageUrl);
    if (parsed == null) {
      return null;
    }

    if (parsed.hasScheme) {
      return parsed;
    }

    return currentUri?.resolve(imageUrl);
  }

  String _domainLabel(Uri? uri) {
    if (uri == null) {
      return _currentFile.previewUri?.toString() ?? _currentFile.name;
    }

    var host = uri.host.trim();
    if (host.startsWith('www.')) {
      host = host.substring(4);
    }

    return host.isNotEmpty ? host : uri.toString();
  }

  String _titleLabel(Uri? displayUri) {
    final title = _metadata?.title?.trim();
    if (title != null && title.isNotEmpty) {
      return title;
    }

    final domain = _domainLabel(displayUri);
    if (domain.isNotEmpty) {
      return domain;
    }

    return _currentFile.name;
  }

  Widget _buildPreviewContent() {
    switch (_loadState) {
      case _LinkPreviewLoadState.loading:
        return const Center(child: CircularProgressIndicator());

      case _LinkPreviewLoadState.error:
        return _LinkPreviewErrorView(
          onRetry: () {
            _loadMetadata();
          },
        );

      case _LinkPreviewLoadState.ready:
        final displayUri = _metadataDisplayUri();

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x20,
              vertical: AppSpacing.x24,
            ),
            child: _LinkPreviewCard(
              title: _titleLabel(displayUri),
              domain: _domainLabel(displayUri),
              imageUri: _metadataImageUri(),
              onPressed: _openCurrentLink,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: CloudFileAppbar(
        titleText: _currentFile.name,
        onLeadingPressed: _showFileList,
        onTitlePressed: _showFileList,
      ),
      body: CloudPreviewBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildPreviewContent(),
            Positioned(
              left: AppSpacing.x16,
              bottom: AppSpacing.x16 + bottomSafeArea,
              child: CloudSelectionFloatingBar(
                isEnabled: true,
                showDownload: false,
                onDeletePressed: () {
                  widget.onDeletePressed(_currentFile);
                },
                onMovePressed: () {
                  widget.onMovePressed(_currentFile);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkPreviewCard extends StatelessWidget {
  const _LinkPreviewCard({
    required this.title,
    required this.domain,
    required this.imageUri,
    required this.onPressed,
  });

  final String title;
  final String domain;
  final Uri? imageUri;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title 링크 열기',
      child: Material(
        color: context.grays.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: context.grays.gray7),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _LinkPreviewThumbnail(imageUri: imageUri),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.x16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyles.semi18.copyWith(
                          color: context.grays.black,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/cloud/link.svg',
                            width: 20.0,
                            height: 20.0,
                            colorFilter: ColorFilter.mode(
                              context.grays.gray4,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x8),
                          Expanded(
                            child: Text(
                              domain,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FontStyles.med14.copyWith(
                                color: context.grays.gray4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkPreviewThumbnail extends StatelessWidget {
  const _LinkPreviewThumbnail({required this.imageUri});

  final Uri? imageUri;

  @override
  Widget build(BuildContext context) {
    final uri = imageUri;

    if (uri == null) {
      return const _LinkPreviewThumbnailFallback();
    }

    return Image.network(
      uri.toString(),
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const _LinkPreviewThumbnailFallback(showLoading: true);
      },
      errorBuilder: (context, error, stackTrace) {
        return const _LinkPreviewThumbnailFallback();
      },
    );
  }
}

class _LinkPreviewThumbnailFallback extends StatelessWidget {
  const _LinkPreviewThumbnailFallback({this.showLoading = false});

  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.grays.gray8,
      child: Center(
        child: showLoading
            ? const CircularProgressIndicator()
            : SvgPicture.asset(
                'assets/icons/cloud/link.svg',
                width: 24.0,
                height: 24.0,
                colorFilter: ColorFilter.mode(
                  context.grays.gray4,
                  BlendMode.srcIn,
                ),
              ),
      ),
    );
  }
}

class _LinkPreviewErrorView extends StatelessWidget {
  const _LinkPreviewErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '불러오지 못했습니다. 다시 시도해주세요',
              textAlign: TextAlign.center,
              style: FontStyles.med16.copyWith(color: context.grays.gray2),
            ),
            const SizedBox(height: AppSpacing.x8),
            Semantics(
              button: true,
              label: '링크 미리보기 다시 시도',
              child: TextButton(
                onPressed: onRetry,
                child: Text(
                  '다시 시도',
                  style: FontStyles.med14.copyWith(
                    color: context.brands.beatOrange1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
