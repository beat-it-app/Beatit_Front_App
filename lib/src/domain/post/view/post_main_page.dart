import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String _goodIconPath = 'assets/icons/post/good.svg';
const String _chatIconPath = 'assets/icons/post/chat.svg';

typedef PostDetailPageBuilder =
    Widget Function(BuildContext context, int postId);

enum PostMainType { notice, poll, meetit }

extension PostMainTypeExtension on PostMainType {
  String get title {
    switch (this) {
      case PostMainType.notice:
        return '공지';
      case PostMainType.poll:
        return '투표';
      case PostMainType.meetit:
        return '밋잇';
    }
  }

  String get createMenuLabel {
    switch (this) {
      case PostMainType.notice:
        return '공지 작성하기';
      case PostMainType.poll:
        return '투표 생성하기';
      case PostMainType.meetit:
        return '밋잇 생성하기';
    }
  }
}

class PostMainPage extends StatefulWidget {
  const PostMainPage({
    super.key,
    this.onCreateNotice,
    this.onCreatePoll,
    this.onCreateMeetit,
    this.noticeDetailPageBuilder,
    this.pollDetailPageBuilder,
    this.meetitDetailPageBuilder,
  });

  final VoidCallback? onCreateNotice;
  final VoidCallback? onCreatePoll;
  final VoidCallback? onCreateMeetit;

  final PostDetailPageBuilder? noticeDetailPageBuilder;
  final PostDetailPageBuilder? pollDetailPageBuilder;
  final PostDetailPageBuilder? meetitDetailPageBuilder;

  @override
  State<PostMainPage> createState() => _PostMainPageState();
}

class _PostMainPageState extends State<PostMainPage> {
  PostMainType _selectedType = PostMainType.notice;

  void _changePostType(PostMainType type) {
    if (_selectedType == type) {
      return;
    }

    setState(() {
      _selectedType = type;
    });
  }

  void _handleCreatePressed(PostMainType type) {
    switch (type) {
      case PostMainType.notice:
        widget.onCreateNotice?.call();
        return;
      case PostMainType.poll:
        widget.onCreatePoll?.call();
        return;
      case PostMainType.meetit:
        widget.onCreateMeetit?.call();
        return;
    }
  }

  void _openDetailPage({
    required int postId,
    required PostDetailPageBuilder? pageBuilder,
  }) {
    if (pageBuilder == null) {
      debugPrint('postId=$postId 상세 페이지 builder가 연결되지 않았습니다.');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => pageBuilder(context, postId)),
    );
  }

  Widget _buildSelectedContent() {
    switch (_selectedType) {
      case PostMainType.notice:
        return _NoticeContent(
          onItemTap: (postId) => _openDetailPage(
            postId: postId,
            pageBuilder: widget.noticeDetailPageBuilder,
          ),
        );
      case PostMainType.poll:
        return _PollContent(
          onItemTap: (postId) => _openDetailPage(
            postId: postId,
            pageBuilder: widget.pollDetailPageBuilder,
          ),
        );
      case PostMainType.meetit:
        return _MeetitContent(
          onItemTap: (postId) => _openDetailPage(
            postId: postId,
            pageBuilder: widget.meetitDetailPageBuilder,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTwoAppBar(
        trailing: AppTwoAppBarTrailing.add,
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
              _PostTypeDropdown(
                selectedType: _selectedType,
                onChanged: _changePostType,
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
                    child: _buildSelectedContent(),
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
      items: PostMainType.values.map((type) {
        return AppDropdownItem(
          label: type.title,
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

// -----------------------------------------------------------------------------
// 공지
// -----------------------------------------------------------------------------

class _NoticeContent extends StatelessWidget {
  const _NoticeContent({required this.onItemTap});

  final ValueChanged<int> onItemTap;

  static const List<_NoticeData> _items = [
    _NoticeData(
      id: 1,
      title: '[중요] 합주실 사용 공지',
      description: '안녕하세요. 합주실 사용과 관련하여 안내드립니다.',
      likeCount: 16,
      commentCount: 55,
      dateText: '2026.04.08 10:16 · 작성자 송하은',
      hasThumbnail: true,
    ),
    _NoticeData(
      id: 2,
      title: '합주 일정 합류 공지',
      description: '잘 나가는 밴드 합주 일정은 다음과 같이 이루어집니다.',
      likeCount: 16,
      commentCount: 55,
      dateText: '2026.04.08 10:16 · 작성자 송하은',
      hasThumbnail: true,
    ),
    _NoticeData(
      id: 3,
      title: '합주 일정 합류 공지',
      description: '잘 나가는 밴드 합주 일정은 방장의 투표 공지로 참여해주세요.',
      likeCount: 16,
      commentCount: 55,
      dateText: '2026.04.08 10:16 · 작성자 송하은',
      hasThumbnail: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_items.length, (index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == _items.length - 1 ? 0 : AppSpacing.x20,
          ),
          child: _NoticeListItem(
            item: _items[index],
            onTap: () => onItemTap(_items[index].id),
          ),
        );
      }),
    );
  }
}

class _NoticeListItem extends StatelessWidget {
  const _NoticeListItem({required this.item, required this.onTap});

  final _NoticeData item;
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
                  firstIconPath: 'assets/icons/post/good.svg',
                  firstText: '${item.likeCount}',
                  secondIconPath: 'assets/icons/post/chat.svg',
                  secondText: '${item.commentCount}',
                ),
                const SizedBox(height: AppSpacing.x8),
                Text(
                  item.dateText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.reg12.copyWith(color: context.grays.gray4),
                ),
              ],
            ),
          ),
          if (item.hasThumbnail) ...[
            const SizedBox(width: AppSpacing.x12),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: context.grays.gray8,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NoticeData {
  const _NoticeData({
    required this.id,
    required this.title,
    required this.description,
    required this.likeCount,
    required this.commentCount,
    required this.dateText,
    required this.hasThumbnail,
  });

  final int id;
  final String title;
  final String description;
  final int likeCount;
  final int commentCount;
  final String dateText;
  final bool hasThumbnail;
}

// -----------------------------------------------------------------------------
// 투표
// -----------------------------------------------------------------------------

class _PollContent extends StatelessWidget {
  const _PollContent({required this.onItemTap});

  final ValueChanged<int> onItemTap;

  static const List<_PollData> _activePolls = [
    _PollData(
      id: 1,
      title: '[중요] 4월 합주 일정 투표',
      dateText: '2026.04.08 10:16 종료 예정',
      participantCount: 7,
      voteStatus: '투표 완료',
      isUrgent: true,
    ),
    _PollData(
      id: 2,
      title: '5월 합주 일정 투표',
      dateText: '2026.04.08 10:16 종료 예정',
      participantCount: 7,
      voteStatus: '투표 안함',
    ),
    _PollData(
      id: 3,
      title: '6월 합주 일정 투표',
      dateText: '2026.04.08 10:16 종료 예정',
      participantCount: 7,
      voteStatus: '투표 안함',
    ),
  ];

  static const List<_PollData> _completedPolls = [
    _PollData(
      id: 4,
      title: '2월 합주 일정 투표',
      dateText: '2026.04.08 10:16 종료된 투표',
      participantCount: 28,
      voteStatus: '투표 안함',
    ),
    _PollData(
      id: 5,
      title: '1월 합주 일정 투표',
      dateText: '2026.04.08 10:16 종료된 투표',
      participantCount: 19,
      voteStatus: '투표 완료',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PollSection(
          title: '진행 중인 투표',
          items: _activePolls,
          isActive: true,
          onItemTap: onItemTap,
        ),
        const SizedBox(height: AppSpacing.x20),
        Divider(height: 1, thickness: 1, color: context.grays.gray7),
        const SizedBox(height: AppSpacing.x20),
        _PollSection(
          title: '종료한 투표',
          items: _completedPolls,
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
  final List<_PollData> items;
  final bool isActive;
  final ValueChanged<int> onItemTap;

  @override
  Widget build(BuildContext context) {
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
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 ? 0 : AppSpacing.x20,
            ),
            child: isActive
                ? _PollListItem(
                    item: items[index],
                    onTap: () => onItemTap(items[index].id),
                  )
                : Opacity(
                    opacity: 0.42,
                    child: _PollListItem(
                      item: items[index],
                      onTap: () => onItemTap(items[index].id),
                    ),
                  ),
          );
        }),
      ],
    );
  }
}

class _PollListItem extends StatelessWidget {
  const _PollListItem({required this.item, required this.onTap});

  final _PollData item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.x8,
            children: [
              if (item.isUrgent)
                Text(
                  '[종료 임박]',
                  style: FontStyles.reg12.copyWith(color: context.brands.error),
                ),
              Text(
                item.dateText,
                style: FontStyles.reg12.copyWith(color: context.grays.gray4),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x8),
          _PostMetaChip(
            firstIconPath: 'assets/icons/post/vote.svg',
            firstText: '${item.participantCount}명',
            secondText: item.voteStatus,
            secondTextColor: item.isUrgent ? colorScheme.primary : null,
          ),
        ],
      ),
    );
  }
}

class _PollData {
  const _PollData({
    required this.id,
    required this.title,
    required this.dateText,
    required this.participantCount,
    required this.voteStatus,
    this.isUrgent = false,
  });

  final int id;
  final String title;
  final String dateText;
  final int participantCount;
  final String voteStatus;
  final bool isUrgent;
}

// -----------------------------------------------------------------------------
// 밋잇
// -----------------------------------------------------------------------------

class _MeetitContent extends StatelessWidget {
  const _MeetitContent({required this.onItemTap});

  final ValueChanged<int> onItemTap;

  static const List<_MeetitData> _items = [
    _MeetitData(
      id: 1,
      title: '4월 둘째주 합주',
      participantCount: 7,
      resultText: '2명 완료',
      hasCompletedResult: true,
    ),
    _MeetitData(
      id: 2,
      title: '4월 첫째주 회식',
      participantCount: 6,
      resultText: '4명 완료',
      hasCompletedResult: true,
    ),
    _MeetitData(
      id: 3,
      title: '합주',
      participantCount: 7,
      resultText: '미완료',
      hasCompletedResult: false,
    ),
  ];

  void _handleDelete(_MeetitData item) {
    // TODO: 삭제 확인 팝업 또는 삭제 API 연결
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_items.length, (index) {
        final item = _items[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == _items.length - 1 ? 0 : AppSpacing.x20,
          ),
          child: _MeetitListItem(
            item: item,
            onTap: () => onItemTap(item.id),
            onDelete: () => _handleDelete(item),
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

  final _MeetitData item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                  firstText: '${item.participantCount}명',
                  secondText: item.resultText,
                  secondTextColor: item.hasCompletedResult
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

class _MeetitData {
  const _MeetitData({
    required this.id,
    required this.title,
    required this.participantCount,
    required this.resultText,
    required this.hasCompletedResult,
  });

  final int id;
  final String title;
  final int participantCount;
  final String resultText;
  final bool hasCompletedResult;
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
          borderRadius: BorderRadius.circular(5),
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
        borderRadius: BorderRadius.circular(5),
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
