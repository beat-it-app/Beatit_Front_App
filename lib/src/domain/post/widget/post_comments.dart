import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/etc/model/team_member_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/member_selection_provider.dart';
import 'package:beatit_front_app/src/domain/etc/widget/member_selection_item.dart';
import 'package:beatit_front_app/src/domain/post/model/post_detail_models.dart';
import 'package:beatit_front_app/src/domain/post/widget/app_comment_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostCommentList extends StatelessWidget {
  const PostCommentList({
    super.key,
    required this.comments,
    required this.canModerate,
    required this.onReply,
    required this.onDelete,
  });

  final List<PostComment> comments;
  final bool canModerate;
  final ValueChanged<PostComment> onReply;
  final Future<void> Function(int commentId) onDelete;

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x20),
        child: Column(
          children: [
            Text(
              '아직 단 댓글이 없어요.',
              style: FontStyles.med14.copyWith(color: context.grays.gray4),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              '가장 먼저 댓글을 남겨보세요.',
              style: FontStyles.med14.copyWith(color: context.grays.gray4),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final comment in comments) ...[
          _SwipeComment(
            key: ValueKey(comment.commentId),
            comment: comment,
            canDelete: canModerate || comment.isMine,
            onReply: () => onReply(comment),
            onDelete: () => onDelete(comment.commentId),
          ),
          for (final reply in comment.replies)
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.x20,
                top: AppSpacing.x12,
              ),
              child: _SwipeComment(
                key: ValueKey(reply.commentId),
                comment: reply,
                canDelete: canModerate || reply.isMine,
                onReply: () => onReply(reply),
                onDelete: () => onDelete(reply.commentId),
              ),
            ),
          const SizedBox(height: AppSpacing.x20),
        ],
      ],
    );
  }
}

class _SwipeComment extends StatefulWidget {
  const _SwipeComment({
    super.key,
    required this.comment,
    required this.canDelete,
    required this.onReply,
    required this.onDelete,
  });

  final PostComment comment;
  final bool canDelete;
  final VoidCallback onReply;
  final Future<void> Function() onDelete;

  @override
  State<_SwipeComment> createState() => _SwipeCommentState();
}

class _SwipeCommentState extends State<_SwipeComment> {
  bool _opened = false;
  bool _deleting = false;
  double _dragDistance = 0;

  Future<void> _delete() async {
    if (_deleting) return;

    setState(() => _deleting = true);
    try {
      await widget.onDelete();
    } finally {
      if (mounted) {
        setState(() {
          _deleting = false;
          _opened = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final colors = Theme.of(context).colorScheme;

    return ClipRect(
      child: Stack(
        children: [
          if (widget.canDelete)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 80,
                  child: Material(
                    color: context.brands.beatOrange1,
                    child: InkWell(
                      onTap: _delete,
                      child: Center(
                        child: _deleting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : SvgPicture.asset(
                                'assets/icons/post/waste.svg',
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  context.grays.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (_) => _dragDistance = 0,
            onHorizontalDragUpdate: (details) {
              _dragDistance += details.delta.dx;
            },
            onHorizontalDragEnd: (_) {
              if (!widget.canDelete || _deleting) return;

              if (_dragDistance < -48) {
                if (_opened) {
                  _delete();
                } else {
                  setState(() => _opened = true);
                }
                return;
              }

              if (_dragDistance > 32 && _opened) {
                setState(() => _opened = false);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              transform: Matrix4.translationValues(_opened ? -80 : 0, 0, 0),
              color: colors.surface,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: comment.profileImageUrl?.isNotEmpty == true
                        ? NetworkImage(comment.profileImageUrl!)
                        : null,
                    child: comment.profileImageUrl?.isNotEmpty == true
                        ? null
                        : const Icon(Icons.person_outline),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.writerName,
                          style: FontStyles.semi14.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        Text(
                          _formatDate(comment.createdAt.toLocal()),
                          style: FontStyles.reg12.copyWith(
                            color: context.grays.gray4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x8),
                        Text.rich(
                          _mentionText(context, comment.content),
                          softWrap: true,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        TextButton(
                          onPressed: widget.onReply,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(40, 28),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            '답글',
                            style: FontStyles.med12.copyWith(
                              color: context.grays.gray4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) =>
      '${date.year}.${date.month.toString().padLeft(2, '0')}.'
      '${date.day.toString().padLeft(2, '0')}';

  static TextSpan _mentionText(BuildContext context, String content) {
    final spans = <TextSpan>[];
    final pattern = RegExp(r'@\{([^}]+)\}|@([a-zA-Z0-9가-힣_]+)');
    var cursor = 0;

    for (final match in pattern.allMatches(content)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: content.substring(cursor, match.start)));
      }

      spans.add(
        TextSpan(
          text: match.group(1) ?? match.group(2),
          style: FontStyles.reg14.copyWith(
            color: context.brands.beatOrange1,
          ),
        ),
      );
      cursor = match.end;
    }

    if (cursor < content.length) {
      spans.add(TextSpan(text: content.substring(cursor)));
    }

    return TextSpan(
      style: FontStyles.reg14.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      children: spans,
    );
  }
}

typedef SendPostComment =
    Future<bool> Function(
      String content,
      int? parentCommentId,
      List<int> mentionedUserIds,
    );

class PostCommentComposer extends ConsumerStatefulWidget {
  const PostCommentComposer({super.key, required this.onSend});

  final SendPostComment onSend;

  @override
  ConsumerState<PostCommentComposer> createState() =>
      PostCommentComposerState();
}

class PostCommentComposerState extends ConsumerState<PostCommentComposer> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _selectedMembers = <TeamMemberSearchResult>[];

  int? _parentId;
  String? _replyName;
  bool _sending = false;
  int? _mentionStart;
  String? _mentionQuery;

  void replyTo(PostComment comment) {
    setState(() {
      _parentId = comment.commentId;
      _replyName = comment.writerName;
    });
    _focusNode.requestFocus();
  }

  void _handleInputChanged(String value) {
    final selection = _controller.selection;
    final cursor = selection.baseOffset;
    if (cursor < 0 || cursor > value.length) {
      _hideMentionSuggestions();
      return;
    }

    final beforeCursor = value.substring(0, cursor);
    final atIndex = beforeCursor.lastIndexOf('@');
    if (atIndex < 0) {
      _hideMentionSuggestions();
      return;
    }

    if (atIndex > 0 && !RegExp(r'\s').hasMatch(beforeCursor[atIndex - 1])) {
      _hideMentionSuggestions();
      return;
    }

    final query = beforeCursor.substring(atIndex + 1);
    if (query.contains(RegExp(r'[\s{}]'))) {
      _hideMentionSuggestions();
      return;
    }

    setState(() {
      _mentionStart = atIndex;
      _mentionQuery = query;
    });

    final memberState = ref.read(memberSelectionProvider);
    if (!memberState.isLoading && memberState.members.isEmpty) {
      ref.read(memberSelectionProvider.notifier).loadMembers();
    }
  }

  void _hideMentionSuggestions() {
    if (_mentionQuery == null && _mentionStart == null) return;

    setState(() {
      _mentionStart = null;
      _mentionQuery = null;
    });
  }

  List<TeamMemberSearchResult> _visibleMentionMembers(
    MemberSelectionState state,
  ) {
    final query = (_mentionQuery ?? '').trim().toLowerCase();
    final members = query.isEmpty
        ? state.members
        : state.members.where(
            (member) => member.userName.toLowerCase().contains(query),
          );

    return members.take(5).toList(growable: false);
  }

  void _selectMention(TeamMemberSearchResult member) {
    final start = _mentionStart;
    final cursor = _controller.selection.baseOffset;
    if (start == null || cursor < start || cursor > _controller.text.length) {
      return;
    }

    final token = '@{${member.userName}} ';
    final updated = _controller.text.replaceRange(start, cursor, token);
    final nextCursor = start + token.length;

    _controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: nextCursor),
    );

    if (!_selectedMembers.any(
      (selected) => selected.userPublicId == member.userPublicId,
    )) {
      _selectedMembers.add(member);
    }

    setState(() {
      _mentionStart = null;
      _mentionQuery = null;
    });
    _focusNode.requestFocus();
  }

  Future<void> _send(String content) async {
    if (_sending) return;

    final ids = _selectedMembers
        .where(
          (member) =>
              member.userId != null &&
              content.contains('@{${member.userName}}'),
        )
        .map((member) => member.userId!)
        .toSet()
        .toList();

    setState(() => _sending = true);
    try {
      final sent = await widget.onSend(content, _parentId, ids);
      if (sent && mounted) {
        setState(() {
          _controller.clear();
          _selectedMembers.clear();
          _parentId = null;
          _replyName = null;
          _mentionStart = null;
          _mentionQuery = null;
        });
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memberState = ref.watch(memberSelectionProvider);
    final mentionMembers = _visibleMentionMembers(memberState);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_mentionQuery != null)
          _MentionSuggestionList(
            state: memberState,
            members: mentionMembers,
            onSelected: _selectMention,
          ),
        if (_replyName != null)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.x16,
              right: AppSpacing.x8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$_replyName님에게 답글',
                    style: FontStyles.med12.copyWith(
                      color: context.grays.gray4,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    _parentId = null;
                    _replyName = null;
                  }),
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
          ),
        AppCommentInput(
          controller: _controller,
          focusNode: _focusNode,
          enabled: !_sending,
          onChanged: _handleInputChanged,
          onSend: _send,
        ),
      ],
    );
  }
}

class _MentionSuggestionList extends StatelessWidget {
  const _MentionSuggestionList({
    required this.state,
    required this.members,
    required this.onSelected,
  });

  final MemberSelectionState state;
  final List<TeamMemberSearchResult> members;
  final ValueChanged<TeamMemberSearchResult> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(maxHeight: 240),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: context.grays.gray7),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      clipBehavior: Clip.antiAlias,
      child: state.isLoading
          ? const SizedBox(
              height: 56,
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : state.errorMessage != null
              ? const SizedBox.shrink()
              : members.isEmpty
                  ? SizedBox(
                      height: 56,
                      child: Center(
                        child: Text(
                          '검색된 멤버가 없습니다.',
                          style: FontStyles.med14.copyWith(
                            color: context.grays.gray5,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return MemberSelectionItem(
                          name: member.userName,
                          role: MemberSelectionRole.fromApiValue(
                            member.teamRole,
                          ),
                          profileImageUrl: member.profileImageUrl,
                          isSelected: false,
                          onTap: () => onSelected(member),
                        );
                      },
                    ),
    );
  }
}
