import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/etc/view/member_selection_page.dart';
import 'package:beatit_front_app/src/domain/post/model/post_detail_models.dart';
import 'package:beatit_front_app/src/domain/post/widget/app_comment_input.dart';
import 'package:flutter/material.dart';
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
      if (mounted)
        setState(() {
          _deleting = false;
          _opened = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
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
            onHorizontalDragUpdate: (details) =>
                _dragDistance += details.delta.dx,
            onHorizontalDragEnd: (_) {
              if (!widget.canDelete || _deleting) return;
              if (_dragDistance > 48) {
                if (_opened) {
                  _delete();
                } else {
                  setState(() => _opened = true);
                }
              } else if (_dragDistance < -32) {
                setState(() => _opened = false);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              transform: Matrix4.translationValues(_opened ? -80 : 0, 0, 0),
              color: context.grays.white,
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
                            color: context.grays.gray1,
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
      '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';

  static TextSpan _mentionText(BuildContext context, String content) {
    final spans = <TextSpan>[];
    final pattern = RegExp(r'@\{([^}]+)\}|@([a-zA-Z0-9가-힣_]+)');
    var cursor = 0;
    for (final match in pattern.allMatches(content)) {
      if (match.start > cursor)
        spans.add(TextSpan(text: content.substring(cursor, match.start)));
      spans.add(
        TextSpan(
          text: '${match.group(1) ?? match.group(2)}',
          style: TextStyle(color: context.brands.beatOrange1),
        ),
      );
      cursor = match.end;
    }
    if (cursor < content.length)
      spans.add(TextSpan(text: content.substring(cursor)));
    return TextSpan(
      style: FontStyles.reg14.copyWith(color: context.grays.gray1),
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

class PostCommentComposer extends StatefulWidget {
  const PostCommentComposer({super.key, required this.onSend});
  final SendPostComment onSend;

  @override
  State<PostCommentComposer> createState() => PostCommentComposerState();
}

class PostCommentComposerState extends State<PostCommentComposer> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _selectedMembers = <MemberSelectionMember>[];
  int? _parentId;
  String? _replyName;
  bool _sending = false;

  void replyTo(PostComment comment) {
    setState(() {
      _parentId = comment.commentId;
      _replyName = comment.writerName;
    });
    _focusNode.requestFocus();
  }

  Future<void> _selectMentions() async {
    final selected = await Navigator.of(context)
        .push<List<MemberSelectionMember>>(
          MaterialPageRoute(
            builder: (_) => MemberSelectionPage(
              initialSelectedMemberIds: _selectedMembers
                  .map((member) => member.id)
                  .toSet(),
              initialSelectedUserIds: _selectedMembers
                  .map((member) => member.userId)
                  .whereType<int>()
                  .toSet(),
            ),
          ),
        );
    if (!mounted || selected == null) return;
    setState(() {
      final selectedIds = selected.map((member) => member.id).toSet();
      for (final member in _selectedMembers) {
        if (!selectedIds.contains(member.id)) {
          _controller.text = _controller.text
              .replaceAll('@{${member.name}}', '')
              .trim();
        }
      }
      _selectedMembers
        ..clear()
        ..addAll(selected);
      for (final member in selected) {
        final token = '@{${member.name}}';
        if (!_controller.text.contains(token)) {
          _controller.text += '${_controller.text.isEmpty ? '' : ' '}$token ';
        }
      }
    });
    _focusNode.requestFocus();
  }

  Future<void> _send(String content) async {
    if (_sending) return;
    final ids = _selectedMembers
        .where(
          (member) =>
              member.userId != null && content.contains('@{${member.name}}'),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (_replyName != null) ...[
              const SizedBox(width: AppSpacing.x16),
              Expanded(
                child: Text(
                  '$_replyName님에게 답글',
                  style: FontStyles.med12.copyWith(color: context.grays.gray4),
                ),
              ),
              IconButton(
                onPressed: () => setState(() {
                  _parentId = null;
                  _replyName = null;
                }),
                icon: const Icon(Icons.close, size: 18),
              ),
            ] else
              const Spacer(),
            TextButton(
              onPressed: _sending ? null : _selectMentions,
              child: const Text('@ 언급'),
            ),
            const SizedBox(width: AppSpacing.x8),
          ],
        ),
        AppCommentInput(
          controller: _controller,
          focusNode: _focusNode,
          enabled: !_sending,
          onSend: (message) {
            _send(message);
          },
        ),
      ],
    );
  }
}
