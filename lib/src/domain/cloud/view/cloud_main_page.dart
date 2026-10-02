import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/cloud/model/cloud_models.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_list_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_mutation_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_permission_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_storage_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_folder_page.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_move_page.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_preview_host_page.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/cloud_file_upload_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/cloud_folder_name_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/cloud_storage_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/link_create_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_folder_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class CloudMainPage extends ConsumerStatefulWidget {
  const CloudMainPage({super.key});

  @override
  ConsumerState<CloudMainPage> createState() => _CloudMainPageState();
}

class _CloudMainPageState extends ConsumerState<CloudMainPage> {
  int? _selectedItemId;
  bool _isSelectionMode = false;
  final Set<int> _selectedItemIds = <int>{};
  final Set<int> _selectedFolderIds = <int>{};

  int get _selectedCount => _selectedItemIds.length + _selectedFolderIds.length;
  bool get _hasSelection => _selectedCount > 0;
  bool get _hasSelectedFolders => _selectedFolderIds.isNotEmpty;

  void _navigateBack() => Navigator.of(context).pop();

  void _setSelectionMode(bool value) {
    if (_isSelectionMode == value) return;
    setState(() {
      _isSelectionMode = value;
      _selectedItemIds.clear();
      _selectedFolderIds.clear();
      _selectedItemId = null;
    });
  }

  void _toggleItemSelection(int itemId) {
    setState(() {
      if (!_selectedItemIds.add(itemId)) {
        _selectedItemIds.remove(itemId);
      }
    });
  }

  void _toggleFolderSelection(int folderId) {
    setState(() {
      if (!_selectedFolderIds.add(folderId)) {
        _selectedFolderIds.remove(folderId);
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
    if (!_hasSelection || data == null || currentUserName == null) return false;

    final selectedItems = data.items.where(
      (item) => _selectedItemIds.contains(item.itemId),
    );
    final selectedFolders = data.folders.where(
      (folder) => _selectedFolderIds.contains(folder.folderId),
    );

    return selectedItems.every(
          (item) => _isMine(item.uploaderName, currentUserName),
        ) &&
        selectedFolders.every(
          (folder) => _isMine(folder.creatorName, currentUserName),
        );
  }

  Future<void> _createFolder() async {
    final name = await showCloudFolderNameBottomSheet(context: context);
    if (!mounted || name == null) return;

    final success = await ref
        .read(cloudMutationProvider.notifier)
        .createFolder(folderName: name);
    if (!mounted) return;
    _showMutationResult(success, successMessage: '폴더를 만들었습니다.');
  }

  Future<void> _uploadFile() async {
    final selection = await showCloudFileUploadBottomSheet(context: context);
    if (!mounted || selection == null) return;

    final success = await ref.read(cloudMutationProvider.notifier).uploadFile(
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
      itemName: result.title,
      linkUrl: result.url,
    );
    if (!mounted) return;
    _showMutationResult(success, successMessage: '링크를 등록했습니다.');
  }

  Future<void> _deleteSelection() async {
    if (!_hasSelection) return;

    final confirmed = await AppPopup.show(
      context,
      title: '삭제하시겠습니까?',
      content: _selectedFolderIds.isNotEmpty
          ? '선택한 폴더와 파일을 삭제합니다.\n폴더 내부의 파일과 링크도 함께 삭제되며 복구할 수 없습니다.'
          : '선택한 $_selectedCount개 항목은 삭제 후 복구할 수 없습니다.',
      buttonNum: ButtonNum.two,
      warningType: _selectedFolderIds.isNotEmpty
          ? WarningType.folder
          : WarningType.triangle,
      confirmText: '삭제',
      cancelText: '취소',
    );
    if (!mounted || confirmed != true) return;

    final success = await ref
        .read(cloudMutationProvider.notifier)
        .deleteSelection(
          itemIds: _selectedItemIds.toList(),
          folderIds: _selectedFolderIds.toList(),
        );
    if (!mounted) return;

    if (success) {
      _setSelectionMode(false);
    }
    _showMutationResult(success, successMessage: '삭제했습니다.');
  }

  Future<void> _deleteSingleItem(int itemId) async {
    final confirmed = await AppPopup.show(
      context,
      title: '삭제하시겠습니까?',
      content: '삭제한 파일 또는 링크는 복구할 수 없습니다.',
      buttonNum: ButtonNum.two,
      warningType: WarningType.triangle,
      confirmText: '삭제',
      cancelText: '취소',
    );
    if (!mounted || confirmed != true) return;

    final success = await ref
        .read(cloudMutationProvider.notifier)
        .deleteItems(itemIds: [itemId]);
    if (!mounted) return;
    _showMutationResult(success, successMessage: '삭제했습니다.');
  }

  Future<void> _moveItems(
    List<int> itemIds, {
    String? displayName,
  }) async {
    if (itemIds.isEmpty || _hasSelectedFolders) return;
    final moved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CloudMovePage(
          itemIds: itemIds,
          currentFolderName: '팀 클라우드',
          displayName: displayName,
        ),
      ),
    );
    if (!mounted || moved != true) return;
    _setSelectionMode(false);
    _showMutationResult(true, successMessage: '파일을 이동했습니다.');
  }

  Future<void> _downloadItems(List<int> itemIds, CloudListData data) async {
    if (itemIds.isEmpty || _hasSelectedFolders) return;

    for (final itemId in itemIds) {
      CloudItem? item;
      for (final candidate in data.items) {
        if (candidate.itemId == itemId) {
          item = candidate;
          break;
        }
      }
      if (item == null) continue;

      Uri? uri;
      if (item.linkUrl?.trim().isNotEmpty == true) {
        uri = Uri.tryParse(item.linkUrl!);
      } else {
        try {
          final detail = await ref.read(cloudFileDetailProvider(itemId).future);
          uri = Uri.tryParse(detail.fileUrl);
        } catch (_) {
          uri = null;
        }
      }

      if (uri == null) continue;
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        // 개별 파일 실패가 나머지 선택 항목 다운로드를 막지 않게 한다.
      }
    }
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
      content: '현재 백엔드에는 파일·링크 이름 수정 API가 없습니다.\n폴더 이름 수정만 연동되어 있습니다.',
      buttonNum: ButtonNum.one,
    ).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final cloudList = ref.watch(cloudListProvider(null));
    final mutation = ref.watch(cloudMutationProvider);
    final currentUserName = ref.watch(cloudCurrentUserNameProvider).asData?.value;
    final data = cloudList.asData?.value;
    final allOwned = _allSelectedAreMine(data, currentUserName);
    final canDelete = _hasSelection && allOwned;
    final canMove = _selectedItemIds.isNotEmpty && !_hasSelectedFolders && allOwned;
    final canDownload = _selectedItemIds.isNotEmpty && !_hasSelectedFolders;

    return Scaffold(
      appBar: AppTwoAppBar(
        showBackButton: true,
        onBackPressed: _navigateBack,
        trailing: AppTwoAppBarTrailing.add,
        addMenuAlignment: AppDropdownAlignment.right,
        addMenuOffset: const Offset(-4, 68),
        addMenuItems: [
          AppDropdownItem(label: '새 폴더 만들기', onPressed: _createFolder),
          AppDropdownItem(label: '파일 등록하기', onPressed: _uploadFile),
          AppDropdownItem(label: '링크 등록하기', onPressed: _createLink),
        ],
      ),
      floatingActionButton: SelectFloatButton(
        isVisible: _isSelectionMode,
        isEnabled: _hasSelection,
        isDeleteEnabled: canDelete,
        isMoveEnabled: canMove,
        isDownloadEnabled: canDownload,
        onDeletePressed: _deleteSelection,
        onMovePressed: () => _moveItems(_selectedItemIds.toList()),
        onDownloadPressed: () {
          if (data != null) {
            _downloadItems(_selectedItemIds.toList(), data);
          }
        },
        onConfirmPressed: () => _setSelectionMode(false),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mutation.isLoading) const LinearProgressIndicator(minHeight: 2),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x16,
                AppSpacing.x24,
                AppSpacing.x16,
                AppSpacing.x24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _isSelectionMode && _selectedCount > 0
                          ? '$_selectedCount개 항목 선택됨'
                          : '팀 클라우드',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.bold34.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  _buildHeaderMenu(),
                ],
              ),
            ),
            Expanded(
              child: cloudList.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _CloudErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(cloudListProvider(null)),
                ),
                data: (cloudData) => _buildCloudList(
                  cloudData,
                  currentUserName: currentUserName,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloudList(
    CloudListData data, {
    required String? currentUserName,
  }) {
    final totalCount = data.folders.length + data.items.length;
    if (totalCount == 0) {
      return const _CloudEmptyView();
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: totalCount,
      itemBuilder: (context, index) {
        if (index < data.folders.length) {
          return _buildFolder(data.folders[index]);
        }
        return _buildItem(
          data.items[index - data.folders.length],
          allItems: data.items,
          currentUserName: currentUserName,
        );
      },
      separatorBuilder: (_, __) => _buildDivider(),
    );
  }

  Widget _buildFolder(CloudFolder folder) {
    final selected = _selectedFolderIds.contains(folder.folderId);
    return CloudFolderWidget(
      key: ValueKey('folder-${folder.folderId}'),
      folderName: folder.folderName,
      fileCount: folder.itemCount,
      isSelectionMode: _isSelectionMode,
      isSelected: selected,
      onTap: () {
        if (_isSelectionMode) {
          _toggleFolderSelection(folder.folderId);
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CloudFolderPage(
              folderId: folder.folderId,
              creatorName: folder.creatorName,
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(
    CloudItem item, {
    required List<CloudItem> allItems,
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
      menuItems: _menuItemsFor(item, currentUserName: currentUserName),
      onMenuTap: () => _selectItem(item.itemId),
      onTap: () {
        if (_isSelectionMode) {
          _toggleItemSelection(item.itemId);
          return;
        }
        _selectItem(item.itemId);
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CloudPreviewHostPage(
              folderName: '팀 클라우드',
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
            final data = ref.read(cloudListProvider(null)).asData?.value;
            if (data != null) _downloadItems([item.itemId], data);
          },
        ),
      );
    }

    items.add(
      AppDropdownItem(
        label: '삭제하기',
        enabled: isMine,
        onPressed: () => _deleteSingleItem(item.itemId),
      ),
    );
    return items;
  }

  Widget _buildHeaderMenu() {
    return AppDropdownList(
      items: [
        AppDropdownItem(
          label: _isSelectionMode ? '선택 취소' : '선택하기',
          onPressed: () => _setSelectionMode(!_isSelectionMode),
        ),
        AppDropdownItem(
          label: '저장 용량',
          onPressed: () {
            ref.invalidate(cloudStorageProvider);
            showCloudStorageBottomSheet(context: context);
          },
        ),
      ],
      width: 170.0,
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
      label: '팀 클라우드 더보기 메뉴',
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

class _CloudEmptyView extends StatelessWidget {
  const _CloudEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '팀 클라우드가 비었습니다.',
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

class _CloudErrorView extends StatelessWidget {
  const _CloudErrorView({required this.message, required this.onRetry});

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
