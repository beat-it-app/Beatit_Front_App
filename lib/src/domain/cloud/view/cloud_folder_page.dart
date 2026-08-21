import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_folder_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudFolderPage extends StatefulWidget {
  const CloudFolderPage({
    super.key,
    required this.title,
    required this.fileCount,
  });

  final String title;
  final int fileCount;

  @override
  State<CloudFolderPage> createState() => _CloudFolderPageState();
}

class _CloudFolderPageState extends State<CloudFolderPage> {
  String? _selectedEntryId;

  bool _isSelectionMode = false;
  final Set<String> _selectedEntryIds = <String>{};

  /// 화면 확인용 임시 데이터
  static const List<_CloudEntry> _entries = [
    _CloudFileEntry(
      id: 'audio-basket-case',
      itemType: CloudItemType.audio,
      fileName: 'Basket Case.mp3',
      fileSize: '10MB',
      uploadedAt: '2026. 08. 05',
      uploaderName: '이현영',
    ),
    _CloudFileEntry(
      id: 'video-practice',
      itemType: CloudItemType.video,
      fileName: '합주 연습 영상.mp4',
      fileSize: '32MB',
      uploadedAt: '2026. 08. 04',
      uploaderName: '송하은',
    ),
    _CloudFileEntry(
      id: 'file-setlist',
      itemType: CloudItemType.file,
      fileName: '2차 베이스 악보 공유.pdf',
      fileSize: '8.2MB',
      uploadedAt: '2026. 07. 22',
      uploaderName: '송하은',
    ),
    _CloudFileEntry(
      id: 'link-surfin-boy',
      itemType: CloudItemType.link,
      fileName: 'Surfin’ Boy',
      uploadedAt: '2026. 07. 20',
      uploaderName: '김지원',
    ),
  ];

  int get _selectedCount => _selectedEntryIds.length;
  bool get _hasSelectedEntries => _selectedEntryIds.isNotEmpty;

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  void _setSelectionMode(bool value) {
    if (_isSelectionMode == value) {
      return;
    }

    setState(() {
      _isSelectionMode = value;
      _selectedEntryIds.clear();
      _selectedEntryId = null;
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedEntryIds.contains(id)) {
        _selectedEntryIds.remove(id);
      } else {
        _selectedEntryIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTwoAppBar(
        trailing: AppTwoAppBarTrailing.add,
        showBackButton: true,
        onBackPressed: _navigateBack,
        addMenuAlignment: AppDropdownAlignment.right,
        addMenuOffset: const Offset(-4, 68),
        addMenuItems: [
          AppDropdownItem(
            label: '파일 등록하기',
            onPressed: () {
              debugPrint('파일 등록하기 팝업 띄우기');
            },
          ),
          AppDropdownItem(
            label: '링크 등록하기',
            onPressed: () {
              debugPrint('링크 등록하기 팝업 띄우기');
            },
          ),
        ],
      ),
      floatingActionButton: SelectFloatButton(
        isVisible: _isSelectionMode,
        isEnabled: _hasSelectedEntries,
        onDeletePressed: () {
          debugPrint('선택한 클라우드 항목 삭제: $_selectedEntryIds');

          // TODO: 삭제 기능 연결
        },
        onMovePressed: () {
          debugPrint('선택한 클라우드 항목 이동: $_selectedEntryIds');

          // TODO: 이동 기능 연결
        },
        onDownloadPressed: () {
          debugPrint('선택한 클라우드 항목 다운로드: $_selectedEntryIds');

          // TODO: 다운로드 기능 연결
        },
        onConfirmPressed: () {
          debugPrint('선택한 클라우드 항목 작업 완료: $_selectedEntryIds');
          _setSelectionMode(false);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SafeArea(
        child: Column(
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
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyles.bold34.copyWith(
                          color: context.grays.black,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x8),
                      _buildHeaderMenu(),
                    ],
                  ),
                  Text(
                    '${widget.fileCount}개의 파일',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontStyles.med14.copyWith(
                      color: context.grays.gray4,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _entries.isEmpty
                  ? const _CloudEmptyView()
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        return _buildEntry(_entries[index]);
                      },
                      separatorBuilder: (context, index) {
                        final colorScheme = Theme.of(context).colorScheme;

                        return Divider(
                          height: 1.0,
                          thickness: 1.0,
                          indent: AppSpacing.x30,
                          endIndent: AppSpacing.x16,
                          color: Color.alphaBlend(
                            colorScheme.onSurface.withAlpha(18),
                            colorScheme.surface,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderMenu() {
    return AppDropdownList(
      items: [
        AppDropdownItem(
          label: _isSelectionMode ? '선택 취소' : '선택하기',
          onPressed: () {
            debugPrint(_isSelectionMode ? '팀 클라우드 선택 취소' : '팀 클라우드 선택하기');
            _setSelectionMode(!_isSelectionMode);
          },
        ),
        AppDropdownItem(
          label: '저장 용량',
          onPressed: () {
            debugPrint('팀 클라우드 저장 용량');
            // TODO: 저장 용량 팝업 또는 페이지 이동을 여기에 연결한다.
          },
        ),
      ],
      width: 170.0,
      anchorWidth: 48.0,
      itemHeight: 44.0,
      alignment: AppDropdownAlignment.right,
      alignmentOffset: const Offset(-4, 48),
      triggerBuilder: (context, controller) {
        return _CloudHeaderMoreButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
              return;
            }

            controller.open();
          },
        );
      },
    );
  }

  Widget _buildEntry(_CloudEntry entry) {
    final isSelected = _isSelectionMode
        ? _selectedEntryIds.contains(entry.id)
        : _selectedEntryId == entry.id;

    if (entry is _CloudFolderEntry) {
      return CloudFolderWidget(
        key: ValueKey(entry.id),
        folderName: entry.folderName,
        fileCount: entry.fileCount,
        isSelectionMode: _isSelectionMode,
        isSelected: isSelected,
        onTap: () {
          if (_isSelectionMode) {
            _toggleSelection(entry.id);
            return;
          }

          _selectEntry(entry.id);
          debugPrint('${entry.folderName} 선택');
          // TODO: 폴더 상세 페이지 이동을 여기에 연결한다.
        },
      );
    }

    final file = entry as _CloudFileEntry;

    return CloudItemWidget(
      key: ValueKey(file.id),
      itemType: file.itemType,
      fileName: file.fileName,
      fileSize: file.fileSize,
      uploadedAt: file.uploadedAt,
      uploaderName: file.uploaderName,
      isSelectionMode: _isSelectionMode,
      isSelected: isSelected,
      menuItems: _menuItemsFor(file),
      onMenuTap: () {
        if (_isSelectionMode) {
          return;
        }

        _selectEntry(file.id);
      },
      onTap: () {
        if (_isSelectionMode) {
          _toggleSelection(file.id);
          return;
        }

        _selectEntry(file.id);
        debugPrint('${file.fileName} 선택');
        // TODO: 파일 형식에 맞는 상세 동작을 여기에 연결한다.
      },
    );
  }

  void _selectEntry(String id) {
    if (_selectedEntryId == id) {
      return;
    }

    setState(() {
      _selectedEntryId = id;
    });
  }

  /// 타입별 드롭다운 목록을 수정하려면 이 함수의 각 case만 바꾸면 된다.
  List<AppDropdownItem> _menuItemsFor(_CloudFileEntry file) {
    switch (file.itemType) {
      case CloudItemType.audio:
        return _downloadableMenuItems(file, downloadLabel: '음원 다운로드하기');
      case CloudItemType.video:
        return _downloadableMenuItems(file, downloadLabel: '영상 다운로드하기');
      case CloudItemType.file:
        return _downloadableMenuItems(file, downloadLabel: '파일 다운로드하기');
      case CloudItemType.link:
        return [
          AppDropdownItem(
            label: '이름 수정하기',
            onPressed: () => _handleMenuAction(file, '이름 수정하기'),
          ),
          AppDropdownItem(
            label: '링크 수정하기',
            onPressed: () => _handleMenuAction(file, '링크 수정하기'),
          ),
          AppDropdownItem(
            label: '삭제하기',
            onPressed: () => _handleMenuAction(file, '삭제하기'),
          ),
        ];
    }
  }

  List<AppDropdownItem> _downloadableMenuItems(
    _CloudFileEntry file, {
    required String downloadLabel,
  }) {
    return [
      AppDropdownItem(
        label: '이름 수정하기',
        onPressed: () => _handleMenuAction(file, '이름 수정하기'),
      ),
      AppDropdownItem(
        label: downloadLabel,
        onPressed: () => _handleMenuAction(file, downloadLabel),
      ),
      AppDropdownItem(
        label: '삭제하기',
        onPressed: () => _handleMenuAction(file, '삭제하기'),
      ),
    ];
  }

  void _handleMenuAction(_CloudFileEntry file, String action) {
    debugPrint('${file.fileName}: $action');
    // TODO: 형식별 팝업, 다운로드, 삭제 기능을 여기에 연결한다.
  }
}

class _CloudHeaderMoreButton extends StatelessWidget {
  const _CloudHeaderMoreButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pressedColor = Color.alphaBlend(
      context.grays.gray6.withValues(alpha: 0.9),
      context.grays.white,
    );

    return Semantics(
      button: true,
      label: '팀 클라우드 더보기 메뉴',
      child: SizedBox(
        width: 48.0,
        height: 48.0,
        child: Center(
          child: Material(
            color: colorScheme.surface.withAlpha(0),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              splashFactory: NoSplash.splashFactory,
              highlightColor: pressedColor,
              child: SizedBox(
                width: 40.0,
                height: 40.0,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/appbar/menu.svg',
                    width: 24.0,
                    height: 24.0,
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
            style: FontStyles.med16.copyWith(color: context.grays.black),
          ),
          const SizedBox(height: AppSpacing.x8),
          Text(
            '+ 버튼을 눌러 파일을 등록해보세요.',
            style: FontStyles.med14.copyWith(color: context.grays.gray5),
          ),
        ],
      ),
    );
  }
}

abstract class _CloudEntry {
  const _CloudEntry({required this.id});

  final String id;
}

class _CloudFolderEntry extends _CloudEntry {
  const _CloudFolderEntry({
    required super.id,
    required this.folderName,
    required this.fileCount,
  });

  final String folderName;
  final int fileCount;
}

class _CloudFileEntry extends _CloudEntry {
  const _CloudFileEntry({
    required super.id,
    required this.itemType,
    required this.fileName,
    required this.uploadedAt,
    required this.uploaderName,
    this.fileSize,
  });

  final CloudItemType itemType;
  final String fileName;
  final String? fileSize;
  final String uploadedAt;
  final String uploaderName;
}
