import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/cloud/model/cloud_models.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_download_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_list_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_mutation_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_permission_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_storage_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_move_page.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_preview_host_page.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/cloud_file_upload_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/cloud_folder_name_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/cloud_storage_api_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/link_create_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudFolderPage extends ConsumerStatefulWidget {
  const CloudFolderPage({
    super.key,
    required this.folderId,
    this.creatorName,
  });

  final int folderId;
  final String? creatorName;

  @override
  ConsumerState<CloudFolderPage> createState() => _CloudFolderPageState();
}

class _CloudFolderPageState extends ConsumerState<CloudFolderPage> {
  int? _selectedItemId;
  bool _isSelectionMode = false;
  final Set<int> _selectedItemIds = <int>{};

  int get _selectedCount => _selectedItemIds.length;
  bool get _hasSelectedItems => _selectedItemIds.isNotEmpty;

  void _navigateBack() => Navigator.of(context).pop();

  void _setSelectionMode(bool value) {
    if (_isSelectionMode == value) return;
    setState(() {
      _isSelectionMode = value;
      _selectedItemIds.clear();
      _selectedItemId = null;
    });
  }

  void _toggleSelection(int itemId) {
    setState(() {
      if (!_selectedItemIds.add(itemId)) {
        _selectedItemIds.remove(itemId);
      }
    });
  }

  void _selectItem(int itemId) {
    if (_selectedItemId == itemId) return;
    setState(() => _selectedItemId = itemId);
  }

  bool _isMine(String writerName, String? currentUserName) {
    if (currentUserName == null || currentUserName.trim().isEmpty) return false;
    return writerName.trim() == currentUserName.trim();
  }

  bool _allSelectedAreMine(CloudListData? data, String? currentUserName) {
    if (!_hasSelectedItems || data == null || currentUserName == null) {
      return false;
    }
    return data.items
        .where((item) => _selectedItemIds.contains(item.itemId))
        .every((item) => _isMine(item.uploaderName, currentUserName));
  }

  Future<void> _uploadFile() async {
    final selection = await showCloudFileUploadBottomSheet(context: context);
    if (!mounted || selection == null) return;

    final success = await ref.read(cloudMutationProvider.notifier).uploadFile(
      folderId: widget.folderId,
      filePath: selection.path,
      fileName: selection.name,
      fileSize: selection.size,
    );
    if (!mounted) return;
    _showMutationResult(success, successMessage: '파일을 등록했습니다.');
  }

  Future<void> _createLink() async {
    final result = await showLinkCreateBottomsheet(context: context);
    if (!mounted || result == null) return;

    final success = await ref.read(cloudMutationProvider.notifier).createLink(
      folderId: widget.folderId,
      itemName: result.title,
      linkUrl: result.url,
    );
    if (!mounted) return;
    _showMutationResult(success, successMessage: '링크를 등록했습니다.');
  }

  Future<void> _renameFolder(String currentName) async {
    final name = await showCloudFolderNameBottomSheet(
      context: context,
      initialName: currentName,
    );
    if (!mounted || name == null || name == currentName) return;

    final success = await ref
        .read(cloudMutationProvider.notifier)
        .renameFolder(folderId: widget.folderId, folderName: name);
    if (!mounted) return;
    _showMutationResult(success, successMessage: '폴더 이름을 수정했습니다.');
  }

  Future<void> _deleteFolder() async {
    final confirmed = await AppPopup.show(
      context,
      title: '폴더를 삭제하시겠습니까?',
      content: '폴더 안의 파일과 링크도 함께 삭제되며 복구할 수 없습니다.',
      buttonNum: ButtonNum.two,
      warningType: WarningType.folder,
      confirmText: '삭제',
      cancelText: '취소',
    );
    if (!mounted || confirmed != true) return;

    final success = await ref
        .read(cloudMutationProvider.notifier)
        .deleteFolder(folderId: widget.folderId);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      return;
    }
    _showMutationResult(false, successMessage: '');
  }

  Future<void> _deleteItems(List<int> itemIds) async {
    if (itemIds.isEmpty) return;

    final confirmed = await AppPopup.show(
      context,
      title: '삭제하시겠습니까?',
      content: itemIds.length == 1
          ? '삭제한 파일 또는 링크는 복구할 수 없습니다.'
          : '선택한 ${itemIds.length}개 항목은 삭제 후 복구할 수 없습니다.',
      buttonNum: ButtonNum.two,
      warningType: WarningType.triangle,
      confirmText: '삭제',
      cancelText: '취소',
    );
    if (!mounted || confirmed != true) return;

    final success = await ref.read(cloudMutationProvider.notifier).deleteItems(
      itemIds: itemIds,
      currentFolderId: widget.folderId,
    );
    if (!mounted) return;

    if (success) {
      _setSelectionMode(false);
    }
    _showMutationResult(success, successMessage: '삭제했습니다.');
  }

  Future<void> _moveItems(
    List<int> itemIds,
    String folderName, {
    String? displayName,
  }) async {
    if (itemIds.isEmpty) return;
    final moved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CloudMovePage(
          itemIds: itemIds,
          currentFolderId: widget.folderId,
          currentFolderName: folderName,
          displayName: displayName,
        ),
      ),
    );
    if (!mounted || moved != true) return;
    _setSelectionMode(false);
    _showMutationResult(true, successMessage: '파일을 이동했습니다.');
  }

  Future<void> _downloadItems(List<int> itemIds, CloudListData data) async {
    if (ref.read(cloudDownloadProvider).isDownloading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('다른 파일을 다운로드하고 있습니다.')),
      );
      return;
    }

    if (itemIds.isEmpty) return;

    final requests = <CloudDownloadRequest>[];

    for (final itemId in itemIds) {
      CloudItem? item;
      for (final candidate in data.items) {
        if (candidate.itemId == itemId) {
          item = candidate;
          break;
        }
      }
      if (item == null || item.linkUrl?.trim().isNotEmpty == true) {
        continue;
      }

      try {
        final detail = await ref.read(cloudFileDetailProvider(itemId).future);
        requests.add(
          CloudDownloadRequest(
            itemId: itemId,
            fileName: detail.itemName,
            fileUrl: detail.fileUrl,
            mimeType: detail.mimeType,
          ),
        );
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.itemName}의 다운로드 정보를 불러오지 못했습니다.')),
        );
        return;
      }
    }

    if (requests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('다운로드할 수 있는 파일이 없습니다.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          requests.length == 1
              ? '${requests.first.fileName} 다운로드를 시작합니다.'
              : '${requests.length}개 파일 다운로드를 시작합니다.',
        ),
      ),
    );

    final success = await ref
        .read(cloudDownloadProvider.notifier)
        .downloadFiles(requests);
    if (!mounted) return;

    final downloadState = ref.read(cloudDownloadProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Downloads 폴더에 저장했습니다.'
              : downloadState.errorMessage ?? '파일 다운로드에 실패했습니다.',
        ),
      ),
    );
  }

  void _showMutationResult(bool success, {required String successMessage}) {
    final mutation = ref.read(cloudMutationProvider);
    final message = success
        ? successMessage
        : mutation.errorMessage ?? '요청 처리 중 오류가 발생했습니다.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showUnsupportedRename() {
    return AppPopup.show(
      context,
      title: '이름 수정 준비 중',
      content: '현재 백엔드에는 파일·링크 이름 수정 API가 없습니다. 폴더 이름 수정만 연동되어 있습니다.',
      buttonNum: ButtonNum.one,
    ).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final cloudList = ref.watch(cloudListProvider(widget.folderId));
    final mutation = ref.watch(cloudMutationProvider);
    final download = ref.watch(cloudDownloadProvider);
    final currentUserName = ref.watch(cloudCurrentUserNameProvider).asData?.value;
    final data = cloudList.asData?.value;
    final allOwned = _allSelectedAreMine(data, currentUserName);
    final folderOwned = widget.creatorName != null &&
        _isMine(widget.creatorName!, currentUserName);

    return Scaffold(
      appBar: AppTwoAppBar(
        trailing: AppTwoAppBarTrailing.add,
        showBackButton: true,
        onBackPressed: _navigateBack,
        addMenuAlignment: AppDropdownAlignment.right,
        addMenuOffset: const Offset(-4, 68),
        addMenuItems: [
          AppDropdownItem(label: '파일 등록하기', onPressed: _uploadFile),
          AppDropdownItem(label: '링크 등록하기', onPressed: _createLink),
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? SelectFloatButton(
              isVisible: true,
              isEnabled: _hasSelectedItems,
              isDeleteEnabled: _hasSelectedItems && allOwned,
              isMoveEnabled: _hasSelectedItems && allOwned,
              isDownloadEnabled: _hasSelectedItems &&
                  !download.isDownloading &&
                  (data?.items
                          .where(
                            (item) => _selectedItemIds.contains(item.itemId),
                          )
                          .every(
                            (item) => item.linkUrl?.trim().isEmpty ?? true,
                          ) ??
                      false),
              onDeletePressed: () => _deleteItems(_selectedItemIds.toList()),
              onMovePressed: () {
                final folderName = data?.currentFolderName ?? '팀 클라우드';
                _moveItems(_selectedItemIds.toList(), folderName);
              },
              onDownloadPressed: () {
                if (data != null) {
                  _downloadItems(_selectedItemIds.toList(), data);
                }
              },
              onConfirmPressed: () => _setSelectionMode(false),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mutation.isLoading) const LinearProgressIndicator(minHeight: 2),
            if (download.isDownloading)
              LinearProgressIndicator(
                minHeight: 2,
                value: download.overallProgress,
              ),
            Expanded(
              child: cloudList.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _CloudFolderErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(cloudListProvider(widget.folderId)),
                ),
                data: (cloudData) => _buildFolderContent(
                  cloudData,
                  currentUserName: currentUserName,
                  folderOwned: folderOwned,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderContent(
    CloudListData data, {
    required String? currentUserName,
    required bool folderOwned,
  }) {
    final folderName = data.currentFolderName ?? '팀 클라우드';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _isSelectionMode && _selectedCount > 0
                          ? '$_selectedCount개 항목 선택됨'
                          : folderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.bold34.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  _buildHeaderMenu(folderName, folderOwned: folderOwned),
                ],
              ),
              Text(
                '${data.items.length}개의 파일',
                style: FontStyles.med14.copyWith(color: context.grays.gray4),
              ),
            ],
          ),
        ),
        Expanded(
          child: data.items.isEmpty
              ? const _CloudFolderEmptyView()
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: data.items.length,
                  itemBuilder: (_, index) => _buildItem(
                    data.items[index],
                    allItems: data.items,
                    folderName: folderName,
                    currentUserName: currentUserName,
                  ),
                  separatorBuilder: (_, __) => _buildDivider(),
                ),
        ),
      ],
    );
  }

  Widget _buildItem(
    CloudItem item, {
    required List<CloudItem> allItems,
    required String folderName,
    required String? currentUserName,
  }) {
    final selected = _isSelectionMode
        ? _selectedItemIds.contains(item.itemId)
        : _selectedItemId == item.itemId;

    return CloudItemWidget(
      key: ValueKey('item-${item.itemId}'),
      itemType: _itemType(item),
      fileName: item.itemName,
      fileSize: _formatFileSize(item.fileSize),
      uploadedAt: _formatDate(item.createdAt),
      uploaderName: item.uploaderName,
      isSelectionMode: _isSelectionMode,
      isSelected: selected,
      menuItems: _menuItemsFor(
        item,
        currentUserName: currentUserName,
        folderName: folderName,
      ),
      onMenuTap: () => _selectItem(item.itemId),
      onTap: () {
        if (_isSelectionMode) {
          _toggleSelection(item.itemId);
          return;
        }
        _selectItem(item.itemId);
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CloudPreviewHostPage(
              folderName: folderName,
              folderId: widget.folderId,
              items: allItems,
              initialItemId: item.itemId,
            ),
          ),
        );
      },
    );
  }

  List<AppDropdownItem> _menuItemsFor(
    CloudItem item, {
    required String? currentUserName,
    required String folderName,
  }) {
    final type = _itemType(item);
    final isMine = _isMine(item.uploaderName, currentUserName);
    final items = <AppDropdownItem>[
      AppDropdownItem(label: '이름 수정하기', onPressed: _showUnsupportedRename),
      AppDropdownItem(
        label: '이동하기',
        enabled: isMine,
        onPressed: () => _moveItems(
          [item.itemId],
          folderName,
          displayName: item.itemName,
        ),
      ),
    ];

    if (type == CloudItemType.link) {
      items.add(
        AppDropdownItem(label: '링크 수정하기', onPressed: _showUnsupportedRename),
      );
    } else {
      items.add(
        AppDropdownItem(
          label: '${_downloadLabel(type)} 다운로드하기',
          onPressed: () {
            final data = ref.read(cloudListProvider(widget.folderId)).asData?.value;
            if (data != null) _downloadItems([item.itemId], data);
          },
        ),
      );
    }

    items.add(
      AppDropdownItem(
        label: '삭제하기',
        enabled: isMine,
        onPressed: () => _deleteItems([item.itemId]),
      ),
    );
    return items;
  }

  Widget _buildHeaderMenu(String folderName, {required bool folderOwned}) {
    return AppDropdownList(
      items: [
        AppDropdownItem(
          label: _isSelectionMode ? '선택 취소' : '선택하기',
          onPressed: () => _setSelectionMode(!_isSelectionMode),
        ),
        AppDropdownItem(
          label: '폴더 이름 수정하기',
          enabled: folderOwned,
          onPressed: () => _renameFolder(folderName),
        ),
        AppDropdownItem(
          label: '폴더 삭제하기',
          enabled: folderOwned,
          onPressed: _deleteFolder,
        ),
        AppDropdownItem(
          label: '저장 용량',
          onPressed: () {
            ref.invalidate(cloudStorageProvider);
            showCloudStorageApiBottomSheet(context: context);
          },
        ),
      ],
      width: 180.0,
      anchorWidth: 48.0,
      itemHeight: 44.0,
      alignment: AppDropdownAlignment.right,
      alignmentOffset: const Offset(-4, 48),
      triggerBuilder: (context, controller) => _CloudHeaderMoreButton(
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }

  Widget _buildDivider() {
    final colors = Theme.of(context).colorScheme;
    return Divider(
      height: 1,
      thickness: 1,
      indent: AppSpacing.x30,
      endIndent: AppSpacing.x16,
      color: Color.alphaBlend(colors.onSurface.withAlpha(18), colors.surface),
    );
  }

  CloudItemType _itemType(CloudItem item) {
    if (item.linkUrl?.isNotEmpty == true) return CloudItemType.link;
    final mimeType = item.mimeType ?? '';
    if (mimeType.startsWith('audio/')) return CloudItemType.audio;
    if (mimeType.startsWith('video/')) return CloudItemType.video;
    return CloudItemType.file;
  }

  String _downloadLabel(CloudItemType type) {
    return switch (type) {
      CloudItemType.audio => '음원',
      CloudItemType.video => '영상',
      CloudItemType.file => '파일',
      CloudItemType.link => '파일',
    };
  }

  String? _formatFileSize(int? bytes) {
    if (bytes == null) return null;
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    }
    return '${bytes}B';
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.year}. ${local.month.toString().padLeft(2, '0')}. ${local.day.toString().padLeft(2, '0')}';
  }
}

class _CloudHeaderMoreButton extends StatelessWidget {
  const _CloudHeaderMoreButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: '폴더 더보기 메뉴',
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: Material(
            color: colors.surface.withAlpha(0),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/appbar/menu.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      context.grays.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CloudFolderEmptyView extends StatelessWidget {
  const _CloudFolderEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '폴더가 비었습니다.',
            style: FontStyles.bold22.copyWith(color: context.grays.black),
          ),
          const SizedBox(height: AppSpacing.x8),
          Text(
            '+ 버튼을 눌러 파일을 등록해보세요.',
            style: FontStyles.med16.copyWith(color: context.grays.gray5),
          ),
          const SizedBox(height: 110.0),
        ],
      ),
    );
  }
}

class _CloudFolderErrorView extends StatelessWidget {
  const _CloudFolderErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: FontStyles.med14.copyWith(color: context.grays.gray4),
            ),
            const SizedBox(height: AppSpacing.x16),
            TextButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
