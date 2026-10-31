import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/utils/app_date_time_formatter.dart';
import 'package:beatit_front_app/src/domain/cloud/model/cloud_models.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_list_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_mutation_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudMovePage extends ConsumerStatefulWidget {
  const CloudMovePage({
    super.key,
    required this.itemIds,
    required this.currentFolderName,
    this.currentFolderId,
    this.displayName,
  });

  final List<int> itemIds;
  final int? currentFolderId;
  final String currentFolderName;
  final String? displayName;

  @override
  ConsumerState<CloudMovePage> createState() => _CloudMovePageState();
}

class _CloudMovePageState extends ConsumerState<CloudMovePage> {
  // 1. 이동 시작 화면 -> 2. 팀 클라우드(루트) -> 3. 하위 폴더
  // 폴더를 선택하는 즉시 그 폴더 안으로 진입하며, 현재 열린 위치가 이동 목적지입니다.
  bool _hasEnteredCloud = false;
  int? _openedFolderId;
  String _openedFolderName = '팀 클라우드';

  int? get _targetFolderId => _openedFolderId;

  bool get _canConfirm =>
      _hasEnteredCloud && _openedFolderId != widget.currentFolderId;

  void _openRoot() {
    setState(() {
      _hasEnteredCloud = true;
      _openedFolderId = null;
      _openedFolderName = '팀 클라우드';
    });
  }

  void _openFolder(CloudFolder folder) {
    setState(() {
      _openedFolderId = folder.folderId;
      _openedFolderName = folder.folderName;
    });
  }

  void _navigateBack() {
    if (!_hasEnteredCloud) {
      Navigator.of(context).pop(false);
    } else if (_openedFolderId != null) {
      _openRoot();
    } else {
      setState(() => _hasEnteredCloud = false);
    }
  }

  Future<void> _confirmMove() async {
    if (!_canConfirm) return;

    final success = await ref
        .read(cloudMutationProvider.notifier)
        .moveItems(
          itemIds: widget.itemIds,
          currentFolderId: widget.currentFolderId,
          targetFolderId: _targetFolderId,
        );
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      return;
    }

    final message =
        ref.read(cloudMutationProvider).errorMessage ?? '파일 이동에 실패했습니다.';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(
      cloudListProvider(_hasEnteredCloud ? _openedFolderId : null),
    );
    final mutation = ref.watch(cloudMutationProvider);

    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.grays.white,
        leadingWidth: 60,
        leading: IconButton(
          onPressed: mutation.isMoving ? null : _navigateBack,
          icon: SvgPicture.asset(
            'assets/icons/appbar/back.svg',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(context.grays.black, BlendMode.srcIn),
          ),
        ),
        title: Text(
          !_hasEnteredCloud
              ? '파일 이동'
              : _openedFolderId == null
              ? '팀 클라우드'
              : location.asData?.value.currentFolderName ?? _openedFolderName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: FontStyles.semi18.copyWith(color: context.grays.black),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (mutation.isMoving)
                  const LinearProgressIndicator(minHeight: 2),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x16,
                    AppSpacing.x24,
                    AppSpacing.x16,
                    AppSpacing.x16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMoveTitle(),
                      const SizedBox(height: AppSpacing.x4),
                      Text(
                        '현재 위치: ${widget.currentFolderName}',
                        style: FontStyles.med14.copyWith(
                          color: context.grays.gray4,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: location.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(
                      child: TextButton(
                        onPressed: () =>
                            ref.invalidate(cloudListProvider(
                              _hasEnteredCloud ? _openedFolderId : null,
                            )),
                        child: const Text('폴더 목록 다시 불러오기'),
                      ),
                    ),
                    data: (data) => _buildTargets(data),
                  ),
                ),
              ],
            ),
            Positioned(
              right: AppSpacing.x16,
              bottom: AppSpacing.x16,
              child: CloudConfirmFloatingButton(
                isEnabled: _canConfirm && location.asData != null && !mutation.isMoving,
                onPressed: _confirmMove,
                semanticLabel: '선택한 위치로 이동',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoveTitle() {
    final titleStyle = FontStyles.bold34.copyWith(color: context.grays.black);
    final fileName = widget.displayName?.trim();

    if (widget.itemIds.length != 1 || fileName == null || fileName.isEmpty) {
      return Text(
        widget.itemIds.length == 1
            ? '파일 이동'
            : '${widget.itemIds.length}개 파일 이동',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: titleStyle,
      );
    }

    // 파일명만 최대 2줄로 생략하고, 마지막 '이동'은 항상 보이게 합니다.
    return LayoutBuilder(
      builder: (context, constraints) {
        bool fits(String name) {
          final painter = TextPainter(
            text: TextSpan(text: '$name 이동', style: titleStyle),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
            maxLines: 2,
          )..layout(maxWidth: constraints.maxWidth);

          final result = !painter.didExceedMaxLines;
          painter.dispose();
          return result;
        }

        var name = fileName;

        if (!fits(name)) {
          var low = 0;
          var high = fileName.length;

          while (low < high) {
            final mid = (low + high + 1) ~/ 2;
            final candidate = '${fileName.substring(0, mid).trimRight()}…';

            if (fits(candidate)) {
              low = mid;
            } else {
              high = mid - 1;
            }
          }

          name = '${fileName.substring(0, low).trimRight()}…';
        }

        return Text('$name 이동', maxLines: 2, style: titleStyle);
      },
    );
  }

  Widget _buildTargets(CloudListData data) {
    if (!_hasEnteredCloud) {
      // 최초에는 오직 팀 클라우드만 표시하고, 확인은 비활성화합니다.
      return _buildLocationList(
        folders: [
          _MoveLocation(
            name: '팀 클라우드',
            itemCount: data.folders.length + data.items.length,
            onOpen: _openRoot,
          ),
        ],
      );
    }

    if (_openedFolderId == null) {
      // 루트에 들어온 뒤 확인하면 루트로 이동하며, 폴더를 누르면 폴더에 진입합니다.
      return _buildLocationList(
        folders: [
          for (final folder in data.folders)
            _MoveLocation(
              name: folder.folderName,
              itemCount: folder.itemCount,
              enabled: folder.folderId != widget.currentFolderId,
              onOpen: () => _openFolder(folder),
            ),
        ],
      );
    }

    // 폴더 내부에서는 그 폴더의 파일을 보여 주되, 목록의 파일은 선택하지 않습니다.
    // 현재 백엔드는 폴더 안에 하위 폴더 목록을 반환하지 않습니다.
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: data.folders.length + data.items.length,
      separatorBuilder: (_, __) => _divider(),
      itemBuilder: (context, index) {
        if (index < data.folders.length) {
          final folder = data.folders[index];
          return _buildLocationRow(
            _MoveLocation(
              name: folder.folderName,
              itemCount: folder.itemCount,
              enabled: folder.folderId != widget.currentFolderId,
              onOpen: () => _openFolder(folder),
            ),
          );
        }
        final item = data.items[index - data.folders.length];
        return CloudItemWidget(
          key: ValueKey('move-file-${item.itemId}'),
          itemType: _itemType(item),
          fileName: item.itemName,
          fileSize: _formatFileSize(item.fileSize),
          uploadedAt: AppDateTimeFormatter.formatDate(item.createdAt),
          uploaderName: item.uploaderName,
          showMoreMenu: false,
        );
      },
    );
  }

  Widget _buildLocationList({required List<_MoveLocation> folders}) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: folders.length,
      separatorBuilder: (_, __) => _divider(),
      itemBuilder: (context, index) => _buildLocationRow(folders[index]),
    );
  }

  Widget _divider() => Divider(
    height: 1,
    thickness: 1,
    indent: AppSpacing.x16,
    endIndent: AppSpacing.x16,
    color: context.grays.gray7,
  );

  Widget _buildLocationRow(_MoveLocation location) {
    return InkWell(
      onTap: location.enabled ? location.onOpen : null,
      child: SizedBox(
        height: 58,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/cloud/folder.svg',
                width: 20,
                height: 20,
                colorFilter: location.enabled
                    ? null
                    : ColorFilter.mode(context.grays.gray6, BlendMode.srcIn),
              ),
              const SizedBox(width: AppSpacing.x16),
              Expanded(
                child: Text(
                  location.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.med16.copyWith(
                    color: location.enabled ? context.grays.black : context.grays.gray5,
                  ),
                ),
              ),
              Text(
                '${location.itemCount}',
                style: FontStyles.med16.copyWith(color: context.grays.gray5),
              ),
              const SizedBox(width: AppSpacing.x4),
              SvgPicture.asset(
                'assets/icons/cloud/back.svg',
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  context.grays.gray6,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CloudItemType _itemType(CloudItem item) {
    if (item.linkUrl?.isNotEmpty == true) return CloudItemType.link;
    final mime = item.mimeType ?? '';
    if (mime.startsWith('audio/')) return CloudItemType.audio;
    if (mime.startsWith('video/')) return CloudItemType.video;
    return CloudItemType.file;
  }

  String? _formatFileSize(int? size) {
    if (size == null) return null;
    if (size >= 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    if (size >= 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${size}B';
  }
}

class _MoveLocation {
  const _MoveLocation({
    required this.name,
    required this.itemCount,
    required this.onOpen,
    this.enabled = true,
  });

  final String name;
  final int itemCount;
  final VoidCallback onOpen;
  final bool enabled;
}
