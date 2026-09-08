import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/domain/post/widget/app_comment_input.dart';
import 'package:beatit_front_app/src/domain/post/widget/poll_selection_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PollDetailPage extends StatefulWidget {
  const PollDetailPage({super.key});

  @override
  State<PollDetailPage> createState() => _PollDetailPageState();
}

class _PollDetailPageState extends State<PollDetailPage> {
  static const String _currentUserName = '송하은';
  static const int _initialLikedCount = 100;
  static const int _initialDislikedCount = 90;

  final List<String> imageUrls = [
    'https://picsum.photos/id/237/200/200',
    'https://picsum.photos/id/238/200/200',
    'https://picsum.photos/id/239/200/200',
  ];

  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<_PostComment> _comments = [
    const _PostComment(
      name: '송하은',
      time: '2026.07.22 15:47',
      comment: '안녕하세요?안녕하세요?안녕하세요?안녕하세요?',
    ),
  ];

  bool _isLiked = false;
  bool _isDisliked = false;

  int get _likedCount => _initialLikedCount + (_isLiked ? 1 : 0);
  int get _dislikedCount => _initialDislikedCount + (_isDisliked ? 1 : 0);
  int get _commentCount => _comments.length;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _toggleDislike() {
    setState(() {
      _isDisliked = !_isDisliked;
    });
  }

  void _addComment(String message) {
    final comment = message.trim();

    if (comment.isEmpty) {
      return;
    }

    setState(() {
      _comments.add(
        _PostComment(
          name: _currentUserName,
          time: _formatDateTime(DateTime.now()),
          comment: comment,
        ),
      );
    });

    _commentController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    });
  }

  String _formatDateTime(DateTime dateTime) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${dateTime.year}.${twoDigits(dateTime.month)}.'
        '${twoDigits(dateTime.day)} ${twoDigits(dateTime.hour)}:'
        '${twoDigits(dateTime.minute)}';
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.backMore(
        onBackPressed: () {
          Navigator.of(context).maybePop();
        },
        onMorePressed: () {},
        moreMenuOffset: const Offset(-16, 40),
        moreMenuItems: [
          AppDropdownItem(
            label: '수정하기',
            onPressed: () {
              debugPrint('수정');
            },
          ),
          AppDropdownItem(
            label: '삭제하기',
            onPressed: () {
              debugPrint('삭제');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.x16,
                        AppSpacing.x24,
                        AppSpacing.x16,
                        AppSpacing.x24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '4월 28일 합주',
                            softWrap: true,
                            style: FontStyles.bold34.copyWith(
                              color: colors.onSurface,
                              letterSpacing: -0.68,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _ProfileAvatar(),
                              const SizedBox(width: AppSpacing.x8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '송하은',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: FontStyles.semi14.copyWith(
                                        color: context.grays.black,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.x4),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '2026.07.22 15:47',
                                            style: FontStyles.reg12.copyWith(
                                              color: context.grays.gray4,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ｜최종수정일 2026.04.03 15:00',
                                            style: FontStyles.reg12.copyWith(
                                              color: context.grays.gray5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x24),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              '안녕하세요! 오늘 합주는 아래 두 곡 연습 예정입니다.\n\n'
                              '파일에는 악보를 pdf로 첨부했으니 참고 부탁드려요 !\n'
                              '합주는 약 3시간 진행 후 함께 점심식사 예정입니다.\n'
                              '(메뉴는 아마도 닭갈비...)\n\n'
                              '오늘은 악기 대여를 안 했으니, 본인이 지참해주세요~',
                              softWrap: true,
                              style: FontStyles.reg14.copyWith(
                                color: context.grays.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x24),
                          PollSelectionBox(),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: context.grays.gray7,
                    ),
                    const SizedBox(height: AppSpacing.x16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x16,
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.x4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/post/chat_off.svg',
                              colorFilter: ColorFilter.mode(
                                context.grays.gray4,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x4),
                            Text(
                              '댓글 $_commentCount',
                              style: FontStyles.reg14.copyWith(
                                color: context.grays.gray4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.x16,
                        0,
                        AppSpacing.x16,
                        AppSpacing.x24,
                      ),
                      child: _comments.isEmpty
                          ? const _EmptyCommentWidget()
                          : Column(
                              children: [
                                for (
                                  var index = 0;
                                  index < _comments.length;
                                  index++
                                ) ...[
                                  _CommentTile(comment: _comments[index]),
                                  if (index != _comments.length - 1)
                                    const SizedBox(height: AppSpacing.x20),
                                ],
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            ColoredBox(
              color: colors.surface,
              child: AppCommentInput(
                controller: _commentController,
                focusNode: _commentFocusNode,
                hintText: '댓글을 입력해주세요.',
                sendButtonSemanticLabel: '댓글 등록하기',
                onSend: _addComment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostComment {
  const _PostComment({
    required this.name,
    required this.time,
    required this.comment,
    this.imageUrl = 'https://picsum.photos/80/80',
  });

  final String name;
  final String time;
  final String comment;
  final String imageUrl;
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final _PostComment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProfileAvatar(imageUrl: comment.imageUrl),
        const SizedBox(width: AppSpacing.x8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: FontStyles.semi14.copyWith(color: context.grays.gray1),
              ),
              Text(
                comment.time,
                style: FontStyles.reg12.copyWith(color: context.grays.gray4),
              ),
              const SizedBox(height: AppSpacing.x8),
              Text(
                comment.comment,
                softWrap: true,
                style: FontStyles.reg14.copyWith(color: context.grays.gray1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.imageUrl = 'https://picsum.photos/80/80'});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 40,
      height: 40,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return ColoredBox(
              color: colors.surfaceContainerHighest,
              child: const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return ColoredBox(
              color: colors.errorContainer,
              child: Icon(
                Icons.person_outline_rounded,
                color: colors.onErrorContainer,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyCommentWidget extends StatelessWidget {
  const _EmptyCommentWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '아직 단 댓글이 없어요.',
            textAlign: TextAlign.center,
            style: FontStyles.med14.copyWith(color: context.grays.gray4),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            '가장 먼저 댓글을 남겨보세요.',
            textAlign: TextAlign.center,
            style: FontStyles.med14.copyWith(color: context.grays.gray4),
          ),
        ],
      ),
    );
  }
}
