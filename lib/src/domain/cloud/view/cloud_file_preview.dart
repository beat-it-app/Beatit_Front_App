import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_appbar.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_preview_background.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

enum CloudPreviewFileType { audio, document, link, video }

extension CloudPreviewFileTypeExtension on CloudPreviewFileType {
  CloudItemType get cloudItemType {
    return switch (this) {
      CloudPreviewFileType.audio => CloudItemType.audio,
      CloudPreviewFileType.document => CloudItemType.file,
      CloudPreviewFileType.link => CloudItemType.link,
      CloudPreviewFileType.video => CloudItemType.video,
    };
  }
}

class CloudFilePreviewItem {
  const CloudFilePreviewItem({
    required this.name,
    required this.uploadedAt,
    required this.uploaderName,
    required this.type,
    required this.iconPath,
    this.previewUri,
    this.sizeLabel,
  });

  final String name;
  final String uploadedAt;
  final String uploaderName;
  final CloudPreviewFileType type;

  /// 현재 Preview Item API와의 호환성을 위해 유지한다.
  ///
  /// BottomSheet에서는 CloudItemWidget이 자체 itemType에 맞는
  /// iconPath를 사용하므로 직접 사용하지 않는다.
  final String iconPath;

  final Uri? previewUri;
  final String? sizeLabel;
}

class CloudFilePreview extends StatefulWidget {
  const CloudFilePreview({
    super.key,
    required this.folderName,
    required this.files,
    required this.onDeletePressed,
    required this.onMovePressed,
    required this.onDownloadPressed,
    this.initialIndex = 0,
    this.requestHeaders,
    this.onFileSelected,
  }) : assert(files.length > 0, 'files에는 하나 이상의 파일이 필요합니다.'),
       assert(
         initialIndex >= 0 && initialIndex < files.length,
         'initialIndex가 files 범위를 벗어났습니다.',
       );

  final String folderName;
  final List<CloudFilePreviewItem> files;
  final int initialIndex;
  final Map<String, String>? requestHeaders;

  final ValueChanged<CloudFilePreviewItem> onDeletePressed;
  final ValueChanged<CloudFilePreviewItem> onMovePressed;
  final ValueChanged<CloudFilePreviewItem> onDownloadPressed;

  /// 문서 외 파일을 선택했을 때
  /// 해당 형식의 Preview 화면으로 이동시키는 진입점이다.
  final ValueChanged<CloudFilePreviewItem>? onFileSelected;

  @override
  State<CloudFilePreview> createState() => _CloudFilePreviewState();
}

class _CloudFilePreviewState extends State<CloudFilePreview> {
  late int _currentIndex;

  int _reloadId = 0;

  CloudFilePreviewItem get _currentFile {
    return widget.files[_currentIndex];
  }

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;
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

          // Preview의 파일 목록에서는 파일 메뉴가 필요하지 않다.
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

    if (selectedFile.type != CloudPreviewFileType.document) {
      widget.onFileSelected?.call(selectedFile);
      return;
    }

    setState(() {
      _currentIndex = selectedIndex;
      _reloadId = 0;
    });
  }

  void _retryPreview() {
    setState(() {
      _reloadId += 1;
    });
  }

  Widget _buildPdfViewer() {
    final previewUri = _currentFile.previewUri;

    if (_currentFile.type != CloudPreviewFileType.document ||
        previewUri == null) {
      return _PreviewErrorView(onRetry: _retryPreview);
    }

    return PdfViewer.uri(
      previewUri,
      key: ValueKey('${previewUri.toString()}-$_reloadId'),
      headers: widget.requestHeaders,
      params: PdfViewerParams(
        margin: 8.0,

        backgroundColor: context.grays.white.withValues(alpha: 0.0),

        pageDropShadow: BoxShadow(
          color: context.grays.black.withValues(alpha: 0.2),
        ),
        panEnabled: true,
        scaleEnabled: true,
        loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x70),
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBannerBuilder: (context, error, stackTrace, documentRef) {
          debugPrint('[CloudFilePreview] PDF load failed: $error');

          return _PreviewErrorView(onRetry: _retryPreview);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            _buildPdfViewer(),
            Positioned(
              left: AppSpacing.x16,
              bottom: AppSpacing.x16 + MediaQuery.paddingOf(context).bottom,
              child: CloudSelectionFloatingBar(
                isEnabled: true,
                onDeletePressed: () {
                  widget.onDeletePressed(_currentFile);
                },
                onMovePressed: () {
                  widget.onMovePressed(_currentFile);
                },
                onDownloadPressed: () {
                  widget.onDownloadPressed(_currentFile);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewErrorView extends StatelessWidget {
  const _PreviewErrorView({required this.onRetry});

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
            const SizedBox(height: AppSpacing.x16),
            Semantics(
              button: true,
              label: '파일 미리보기 다시 시도',
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
