import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/domain/post/model/post_main_models.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_main_provider.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/domain/post/view/post_create_page.dart';
import 'package:beatit_front_app/src/domain/post/view/poll_create_page.dart';
import 'package:beatit_front_app/src/domain/post/view/post_detail_page.dart';
import 'package:beatit_front_app/src/domain/post/view/poll_detail_page.dart';
import 'package:beatit_front_app/src/domain/meetit/view/meetit_create_page.dart';
import 'package:beatit_front_app/src/domain/meetit/view/meetit_detail_page.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_api_provider.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String _goodIconPath = 'assets/icons/post/good.svg';
const String _chatIconPath = 'assets/icons/post/chat.svg';

typedef PostDetailPageBuilder =
    Widget Function(BuildContext context, int postId);

class PostMainPage extends ConsumerStatefulWidget {
  const PostMainPage({
    super.key,
    this.searchOnly = false,
    this.initialType = PostMainType.notice,
    this.onCreateNotice,
    this.onCreatePoll,
    this.onCreateMeetit,
    this.noticeDetailPageBuilder,
    this.pollDetailPageBuilder,
    this.meetitDetailPageBuilder,
  });

  final bool searchOnly;
  final PostMainType initialType;
  final VoidCallback? onCreateNotice;
  final VoidCallback? onCreatePoll;
  final VoidCallback? onCreateMeetit;

  final PostDetailPageBuilder? noticeDetailPageBuilder;
  final PostDetailPageBuilder? pollDetailPageBuilder;
  final PostDetailPageBuilder? meetitDetailPageBuilder;

  @override
  ConsumerState<PostMainPage> createState() => _PostMainPageState();
}

class _PostMainPageState extends ConsumerState<PostMainPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late PostMainType _selectedType;
  late bool _isSearchOpen;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _isSearchOpen = widget.searchOnly;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _loadSelected(keyword: '');
      if (widget.searchOnly) _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSelected({String? keyword}) async {
    final query = keyword ?? (_isSearchOpen ? _searchController.text.trim() : '');
    final notifier = ref.read(postMainProvider.notifier);

    switch (_selectedType) {
      case PostMainType.notice:
        await notifier.loadNotices(keyword: query);
        return;
      case PostMainType.poll:
        await notifier.loadPolls(keyword: query);
        return;
      case PostMainType.meetit:
        await notifier.loadMeetits(keyword: query);
        return;
    }
  }

  void _changePostType(PostMainType type) {
    if (_selectedType == type) {
      return;
    }

    setState(() {
      _selectedType = type;
    });

    _loadSelected();
  }

  void _handleSearchPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostMainPage(
          searchOnly: true,
          initialType: _selectedType,
          noticeDetailPageBuilder: widget.noticeDetailPageBuilder,
          pollDetailPageBuilder: widget.pollDetailPageBuilder,
          meetitDetailPageBuilder: widget.meetitDetailPageBuilder,
        ),
      ),
    ).then((_) { if (mounted) _loadSelected(keyword: ''); });
  }

  Future<void> _submitSearch() async {
    _searchFocusNode.unfocus();
    await _loadSelected(keyword: _searchController.text.trim());
  }

  Future<void> _handleCreatePressed(PostMainType type) async {
    final callback = switch (type) {
      PostMainType.notice => widget.onCreateNotice,
      PostMainType.poll => widget.onCreatePoll,
      PostMainType.meetit => widget.onCreateMeetit,
    };
    if (callback != null) { callback(); return; }
    final page = switch (type) {
      PostMainType.notice => const PostCreatePage(),
      PostMainType.poll => const PollCreatePage(),
      PostMainType.meetit => const MeetitCreatePage(),
    };
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => page),
    );
    if (mounted && created == true) _loadSelected(keyword: '');
  }

  Future<void> _openDetailPage({
    required int postId,
    required PostMainType type,
    required PostDetailPageBuilder? pageBuilder,
    int? pollCount,
  }) async {
    final page = pageBuilder?.call(context, postId) ?? switch (type) {
      PostMainType.notice => PostDetailPage(noticeId: postId),
      PostMainType.poll => PollDetailPage(pollId: postId, participantCount: pollCount),
      PostMainType.meetit => MeetitDetailPage(meetitId: postId),
    };
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
    if (mounted) _loadSelected(keyword: widget.searchOnly ? _searchController.text : '');
  }

  void _handleMeetitDelete(MeetitListItem item) {
    // 제공된 백엔드 MeetitController에는 DELETE API가 없습니다.
    // 존재하지 않는 endpoint를 추정해서 호출하지 않고 사용자에게 현재 상태를 알립니다.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('밋잇 삭제 API가 아직 제공되지 않아 삭제할 수 없습니다.')),
    );
  }

  Widget _buildSelectedContent(PostMainState state) {
    switch (_selectedType) {
      case PostMainType.notice:
        return _PostLoadState(
          isLoading: state.isNoticeLoading,
          errorMessage: state.noticeError,
          isEmpty: state.notices.isEmpty,
          emptyMessage: state.noticeKeyword.isEmpty
              ? '작성된 공지가 없습니다.'
              : '검색된 공지가 없습니다.',
          onRetry: _loadSelected,
          child: _NoticeContent(
            items: state.notices,
            onItemTap: (postId) => _openDetailPage(
              postId: postId,
              type: PostMainType.notice,
              pageBuilder: widget.noticeDetailPageBuilder,
            ),
          ),
        );
      case PostMainType.poll:
        return _PostLoadState(
          isLoading: state.isPollLoading,
          errorMessage: state.pollError,
          isEmpty:
              state.pollsInProgress.isEmpty && state.pollsClosed.isEmpty,
          emptyMessage: state.pollKeyword.isEmpty
              ? '작성된 투표가 없습니다.'
              : '검색된 투표가 없습니다.',
          onRetry: _loadSelected,
          child: _PollContent(
            activePolls: state.pollsInProgress,
            completedPolls: state.pollsClosed,
            onItemTap: (postId) => _openDetailPage(
              postId: postId,
              type: PostMainType.poll,
              pollCount: [...state.pollsInProgress, ...state.pollsClosed]
                  .where((item) => item.pollId == postId)
                  .firstOrNull?.pollCount,
              pageBuilder: widget.pollDetailPageBuilder,
            ),
          ),
        );
      case PostMainType.meetit:
        return _PostLoadState(
          isLoading: state.isMeetitLoading,
          errorMessage: state.meetitError,
          isEmpty: state.meetits.isEmpty,
          emptyMessage: state.meetitKeyword.isEmpty
              ? '작성된 밋잇이 없습니다.'
              : '검색된 밋잇이 없습니다.',
          onRetry: _loadSelected,
          child: _MeetitContent(
            items: state.meetits,
            onItemTap: (postId) => _openDetailPage(
              postId: postId,
              type: PostMainType.meetit,
              pageBuilder: widget.meetitDetailPageBuilder,
            ),
            onDelete: _handleMeetitDelete,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postMainProvider);

    return Scaffold(
      appBar: widget.searchOnly
          ? AppTopAppBar.backTitle(title: '${_selectedType.title} 검색', onBackPressed: () => Navigator.of(context).pop())
          : AppTwoAppBar(
        trailing: AppTwoAppBarTrailing.all,
        onSearchPressed: _handleSearchPressed,
        addMenuAlignment: AppDropdownAlignment.right,
        addMenuOffset: const Offset(0, 68),
        addMenuItems: [
          AppDropdownItem(
            label: PostMainType.notice.createMenuLabel,
            onPressed: () => _handleCreatePressed(PostMainType.notice),
          ),
          AppDropdownItem(
            label: PostMainType.poll.createMenuLabel,
            onPressed: () => _handleCreatePressed(PostMainType.poll),
          ),
          AppDropdownItem(
            label: PostMainType.meetit.createMenuLabel,
            onPressed: () => _handleCreatePressed(PostMainType.meetit),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x16,
            AppSpacing.x16,
            AppSpacing.x16,
            AppSpacing.x30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.searchOnly) _PostTypeDropdown(
                selectedType: _selectedType,
                onChanged: _changePostType,
              ),
              if (widget.searchOnly) AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _isSearchOpen
                    ? Padding(
                        key: const ValueKey('post-search-field'),
                        padding: const EdgeInsets.only(top: AppSpacing.x16),
                        child: SearchInputWidget(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          hintText: '${_selectedType.title} 검색',
                          onSearchPressed: _submitSearch,
                          onChanged: (value) {
                            if (value.trim().isEmpty) _loadSelected(keyword: '');
                          },
                        ),
                      )
                    : const SizedBox.shrink(
                        key: ValueKey('post-search-field-hidden'),
                      ),
              ),
              const SizedBox(height: AppSpacing.x24),
              AnimatedSize(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchOutCurve: Curves.easeInCubic,
                  switchInCurve: Curves.easeOutCubic,
                  transitionBuilder: (child, animation) {
                    final curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    );

                    return FadeTransition(
                      opacity: curvedAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.025),
                          end: Offset.zero,
                        ).animate(curvedAnimation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<PostMainType>(_selectedType),
                    child: _buildSelectedContent(state),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostTypeDropdown extends StatelessWidget {
  const _PostTypeDropdown({
    required this.selectedType,
    required this.onChanged,
  });

  final PostMainType selectedType;
  final ValueChanged<PostMainType> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppDropdownList(
      width: 150,
      itemHeight: 44,
      alignment: AppDropdownAlignment.left,
      alignmentOffset: const Offset(0, AppSpacing.x60),
      showPressedCheck: false,
      items: PostMainType.values.map((type) {
        final isSelected = type == selectedType;
        return AppDropdownItem(
          label: isSelected ? '✓  ${type.title}' : '    ${type.title}',
          onPressed: () => onChanged(type),
        );
      }).toList(),
      triggerBuilder: (context, controller) {
        return Semantics(
          button: true,
          expanded: controller.isOpen,
          label: '게시글 종류 선택',
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (controller.isOpen) {
                controller.close();
                return;
              }

              controller.open();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: Text(
                    selectedType.title,
                    key: ValueKey<PostMainType>(selectedType),
                    style: FontStyles.bold34.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                AnimatedRotation(
                  turns: controller.isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: SvgPicture.asset(
                    'assets/icons/post/toggle_down.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PostLoadState extends StatelessWidget {
  const _PostLoadState({
    required this.isLoading,
    required this.errorMessage,
    required this.isEmpty,
    required this.emptyMessage,
    required this.onRetry,
    required this.child,
  });

  final bool isLoading;
  final String? errorMessage;
  final bool isEmpty;
  final String emptyMessage;
  final Future<void> Function() onRetry;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (isLoading && isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.x40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null && isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x30),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: FontStyles.med14.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: AppSpacing.x12),
              TextButton(
                onPressed: () => onRetry(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    if (isEmpty) {
      final isSearchEmpty = emptyMessage.startsWith('검색된');
      final itemName = emptyMessage.contains('공지') ? '공지'
          : emptyMessage.contains('투표') ? '투표' : '밋잇';
      return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.64,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emptyMessage, textAlign: TextAlign.center,
                style: FontStyles.bold20.copyWith(color: colors.onSurface)),
              if (!isSearchEmpty) ...[
                const SizedBox(height: AppSpacing.x8),
                Text('+ 버튼을 눌러 ${itemName == '투표' ? '투표를' : '$itemName을'} ${itemName == '공지' ? '작성' : '생성'}해보세요.',
                  textAlign: TextAlign.center,
                  style: FontStyles.reg14.copyWith(color: context.grays.gray5)),
              ],
            ],
          ),
        ),
      );
    }

    return child;
  }
}

// -----------------------------------------------------------------------------
// 공지
// -----------------------------------------------------------------------------

class _NoticeContent extends StatelessWidget {
  const _NoticeContent({
    required this.items,
    required this.onItemTap,
  });

  final List<NoticeListItem> items;
  final ValueChanged<int> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == items.length - 1 ? 0 : AppSpacing.x20,
          ),
          child: _NoticeListItem(
            item: item,
            onTap: () => onItemTap(item.noticeId),
          ),
        );
      }),
    );
  }
}

class _NoticeListItem extends StatelessWidget {
  const _NoticeListItem({required this.item, required this.onTap});

  final NoticeListItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _PostItemTapSurface(
      semanticLabel: '${item.title} 공지 상세 보기',
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.med20.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.med16.copyWith(color: context.grays.gray5),
                ),
                const SizedBox(height: AppSpacing.x8),
                _PostMetaChip(
                  firstIconPath: _goodIconPath,
                  firstText: '${item.likeCount}',
                  secondIconPath: _chatIconPath,
                  secondText: '${item.commentCount}',
                ),
                const SizedBox(height: AppSpacing.x8),
                Text(
                  '${_formatDateTime(item.createdAt)} · 작성자 ${item.writer}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.reg12.copyWith(color: context.grays.gray4),
                ),
              ],
            ),
          ),
          if (item.thumbnailUrl != null) ...[
            const SizedBox(width: AppSpacing.x12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.network(
                item.thumbnailUrl!,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 64,
                    height: 64,
                    color: context.grays.gray8,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 투표
// -----------------------------------------------------------------------------

class _PollContent extends StatelessWidget {
  const _PollContent({
    required this.activePolls,
    required this.completedPolls,
    required this.onItemTap,
  });

  final List<PollListItem> activePolls;
  final List<PollListItem> completedPolls;
  final ValueChanged<int> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PollSection(
          title: '진행 중인 투표',
          items: activePolls,
          isActive: true,
          onItemTap: onItemTap,
        ),
        if (activePolls.isNotEmpty && completedPolls.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x20),
          Divider(height: 1, thickness: 1, color: context.grays.gray7),
          const SizedBox(height: AppSpacing.x20),
        ],
        _PollSection(
          title: '종료한 투표',
          items: completedPolls,
          isActive: false,
          onItemTap: onItemTap,
        ),
      ],
    );
  }
}

class _PollSection extends StatelessWidget {
  const _PollSection({
    required this.title,
    required this.items,
    required this.isActive,
    required this.onItemTap,
  });

  final String title;
  final List<PollListItem> items;
  final bool isActive;
  final ValueChanged<int> onItemTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final sectionColor = isActive ? colorScheme.primary : context.grays.gray1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                color: sectionColor,
              ),
              child: SvgPicture.asset(
                'assets/icons/check/check.svg',
                width: 14,
                height: 14,
                colorFilter: ColorFilter.mode(
                  context.grays.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Text(title, style: FontStyles.bold14.copyWith(color: sectionColor)),
          ],
        ),
        const SizedBox(height: AppSpacing.x8),
        ...List.generate(items.length, (index) {
          final item = items[index];
          final listItem = _PollListItem(
            item: item,
            isActive: isActive,
            onTap: () => onItemTap(item.pollId),
          );

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 ? 0 : AppSpacing.x20,
            ),
            child: isActive
                ? listItem
                : Opacity(opacity: 0.42, child: listItem),
          );
        }),
      ],
    );
  }
}

class _PollListItem extends StatelessWidget {
  const _PollListItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final PollListItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUrgent = isActive && _isClosingWithinOneDay(item.closeAt);

    return _PostItemTapSurface(
      semanticLabel: '${item.title} 투표 상세 보기',
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FontStyles.med20.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            _formatPollCloseText(
              closeAt: item.closeAt,
              isActive: isActive,
              isUrgent: isUrgent,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FontStyles.reg12.copyWith(
              color: isUrgent ? colorScheme.primary : context.grays.gray4,
            ),
          ),
          const SizedBox(height: AppSpacing.x8),
          _PostMetaChip(
            firstIconPath: 'assets/icons/post/vote.svg',
            firstText: '${item.pollCount}명',
            secondText: item.isVoted ? '투표 완료' : '투표 안함',
            secondTextColor: item.isVoted ? colorScheme.primary : null,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 밋잇
// -----------------------------------------------------------------------------

class _MeetitContent extends StatelessWidget {
  const _MeetitContent({
    required this.items,
    required this.onItemTap,
    required this.onDelete,
  });

  final List<MeetitListItem> items;
  final ValueChanged<int> onItemTap;
  final ValueChanged<MeetitListItem> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == items.length - 1 ? 0 : AppSpacing.x20,
          ),
          child: _MeetitListItem(
            item: item,
            onTap: () => onItemTap(item.meetitId),
            onDelete: () => onDelete(item),
          ),
        );
      }),
    );
  }
}

class _MeetitListItem extends StatelessWidget {
  const _MeetitListItem({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final MeetitListItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasResponse = item.respondedCount > 0;

    return _PostItemTapSurface(
      semanticLabel: '${item.title} 밋잇 상세 보기',
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.med20.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.x10),
                _PostMetaChip(
                  firstIconPath: 'assets/icons/post/people.svg',
                  firstText: '${item.totalInvitedCount}명',
                  secondText: hasResponse
                      ? '${item.respondedCount}명 완료'
                      : '미완료',
                  secondTextColor: hasResponse
                      ? colorScheme.primary
                      : context.grays.gray5,
                ),
              ],
            ),
          ),
          AppDropdownList(
            width: 170,
            anchorWidth: 44,
            itemHeight: 44,
            alignment: AppDropdownAlignment.right,
            alignmentOffset: const Offset(0, AppSpacing.x30),
            items: [AppDropdownItem(label: '삭제하기', onPressed: onDelete)],
            triggerBuilder: (context, controller) {
              return Semantics(
                button: true,
                expanded: controller.isOpen,
                label: '${item.title} 밋잇 메뉴',
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.more_vert,
                      size: 20,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PostItemTapSurface extends StatelessWidget {
  const _PostItemTapSurface({
    required this.semanticLabel,
    required this.onTap,
    required this.child,
  });

  final String semanticLabel;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return context.grays.gray8.withValues(alpha: 0.65);
            }
            return Colors.transparent;
          }),
          onTap: onTap,
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 공통 메타 정보 칩
// -----------------------------------------------------------------------------

class _PostMetaChip extends StatelessWidget {
  const _PostMetaChip({
    required this.firstIconPath,
    required this.firstText,
    this.secondIconPath,
    required this.secondText,
    this.firstTextColor,
    this.secondTextColor,
  });

  final String firstIconPath;
  final String firstText;
  final String? secondIconPath;
  final String secondText;
  final Color? firstTextColor;
  final Color? secondTextColor;

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = context.grays.gray2;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x8,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: context.grays.gray8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            firstIconPath,
            width: 14,
            height: 14,
            colorFilter: ColorFilter.mode(defaultTextColor, BlendMode.srcIn),
          ),
          const SizedBox(width: AppSpacing.x4),
          Text(
            firstText,
            style: FontStyles.med12.copyWith(
              color: firstTextColor ?? defaultTextColor,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          if (secondIconPath != null) ...[
            const SizedBox(width: AppSpacing.x4),
            SvgPicture.asset(
              secondIconPath!,
              width: 14,
              height: 14,
              colorFilter: ColorFilter.mode(defaultTextColor, BlendMode.srcIn),
            ),
          ] else ...[
            Text(
              '•',
              style: FontStyles.med12.copyWith(color: defaultTextColor),
            ),
          ],
          const SizedBox(width: AppSpacing.x4),
          Text(
            secondText,
            style: FontStyles.med12.copyWith(
              color: secondTextColor ?? defaultTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDateTime(DateTime dateTime) {
  final local = dateTime.toLocal();
  String twoDigits(int value) => value.toString().padLeft(2, '0');

  return '${local.year}.${twoDigits(local.month)}.${twoDigits(local.day)} '
      '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
}

bool _isClosingWithinOneDay(DateTime? closeAt) {
  if (closeAt == null) {
    return false;
  }

  final difference = closeAt.toLocal().difference(DateTime.now());
  return difference > Duration.zero && difference <= const Duration(days: 1);
}

String _formatPollCloseText({
  required DateTime? closeAt,
  required bool isActive,
  required bool isUrgent,
}) {
  if (closeAt == null) {
    return isActive ? '종료 일정 없음' : '종료된 투표';
  }

  final formatted = _formatDateTime(closeAt);
  if (!isActive) {
    return '$formatted 종료된 투표';
  }
  if (isUrgent) {
    return '종료 임박 · $formatted 종료 예정';
  }
  return '$formatted 종료 예정';
}
