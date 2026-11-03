import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/etc/model/team_member_search_result.dart';
import 'package:beatit_front_app/src/domain/post/post_date_time.dart';
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
    required this.onReply,
    required this.onDelete,
  });

  final List<PostComment> comments;
  final ValueChanged<PostComment> onReply;
  final Future<void> Function(int commentId) onDelete;

  void _replyKeepingParentVisible(
    BuildContext parentContext,
    PostComment comment,
  ) {
    onReply(comment);
    // 키보드 높이가 반영된 뒤 부모 댓글을 입력창 위에 남깁니다.
    Future<void>.delayed(const Duration(milliseconds: 320), () {
      if (!parentContext.mounted) return;
      Scrollable.ensureVisible(
        parentContext,
        alignment: 0.1,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x40),
        child: Text(
          '가장 먼저 댓글을 남겨주세요',
          textAlign: TextAlign.center,
          style: FontStyles.med14.copyWith(color: context.grays.gray5),
        ),
      );
    }

    return Column(
      children: [
        for (final comment in comments)
          Builder(
            builder: (parentContext) => Column(
              children: [
                _SwipeComment(
                  key: ValueKey(comment.commentId),
                  comment: comment,
                  canDelete: comment.isMine,
                  onReply: () =>
                      _replyKeepingParentVisible(parentContext, comment),
                  replyToName: null,
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
                      canDelete: reply.isMine,
                      onReply: () =>
                          _replyKeepingParentVisible(parentContext, reply),
                      // 서버가 대댓글을 최상위 댓글 아래에 평탄화합니다.
                      replyToName: comment.writerName,
                      onDelete: () => onDelete(reply.commentId),
                    ),
                  ),
                const SizedBox(height: AppSpacing.x20),
              ],
            ),
          ),
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
    required this.replyToName,
  });

  final PostComment comment;
  final String? replyToName;
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
            // 열린 상태에서 빈 오른쪽 영역의 탭이 뒤쪽 삭제 버튼으로 전달됩니다.
            behavior: HitTestBehavior.deferToChild,
            onHorizontalDragStart: (_) => _dragDistance = 0,
            onHorizontalDragUpdate: (details) {
              _dragDistance += details.delta.dx;
            },
            onHorizontalDragEnd: (_) {
              if (!widget.canDelete || _deleting) return;

              if (_dragDistance < -48) {
                // 드래그는 삭제 버튼만 열고, 실제 삭제는 빨간 버튼을 눌렀을 때만 합니다.
                if (!_opened) setState(() => _opened = true);
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
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: ClipOval(
                      child: comment.profileImageUrl?.trim().isNotEmpty == true
                          ? Image.network(
                              comment.profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/auth/profile_orange.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              'assets/images/auth/profile_orange.png',
                              fit: BoxFit.cover,
                            ),
                    ),
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
                          _commentContent(
                            context,
                            comment.content,
                            comment.mentionedUsers,
                            widget.replyToName,
                          ),
                          softWrap: true,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        TextButton(
                          onPressed: widget.onReply,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size.zero,
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

  static String _formatDate(DateTime date) => formatPostDateTime(date);

  // 서버는 답글의 부모 ID를 최상위 댓글 ID로 평탄화합니다.
  // 답글의 답글도 정확한 대상 이름을 알 수 있도록 댓글 내용에만 대상 정보를
  // 보관합니다. @멘션과는 별개이며 멘션 ID 목록에도 추가하지 않습니다.
  static final RegExp _replyTargetPattern = RegExp(r'^↳([^↳\n]{1,80})↳\s*');
  static final RegExp _legacyMentionPattern = RegExp(
    r'@\{([^}]+)\}|@([a-zA-Z0-9가-힣_]+)',
  );

  static TextSpan _commentContent(
    BuildContext context,
    String content,
    List<PostMentionUser> mentionedUsers,
    String? fallbackReplyToName,
  ) {
    final replyMatch = fallbackReplyToName == null
        ? null
        : _replyTargetPattern.firstMatch(content);
    final replyName = replyMatch?.group(1)?.trim() ?? fallbackReplyToName;
    final body = replyMatch == null
        ? content
        : content.substring(replyMatch.end);
    final bodySpan = _mentionText(context, body, mentionedUsers);
    if (replyName == null || replyName.isEmpty) return bodySpan;

    return TextSpan(
      style: FontStyles.reg14.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.x4),
            child: SvgPicture.asset(
              'assets/icons/core/enter.svg',
              width: 14,
              height: 14,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        TextSpan(
          text: replyName,
          style: FontStyles.semi14.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const TextSpan(text: ' '),
        bodySpan,
      ],
    );
  }

  static TextSpan _mentionText(
    BuildContext context,
    String content,
    List<PostMentionUser> mentionedUsers,
  ) {
    // @문법을 그대로 포함한 구형 댓글도 표시할 수 있습니다.
    final explicitNames = <String>{};
    final visibleText = content.replaceAllMapped(_legacyMentionPattern, (
      match,
    ) {
      final name = match.group(1) ?? match.group(2) ?? '';
      if (name.isNotEmpty) explicitNames.add(name);
      return name;
    });
    final names =
        <String>{
            ...mentionedUsers.map((item) => item.name.trim()),
            ...explicitNames,
          }.where((value) => value.isNotEmpty).toList()
          ..sort((a, b) => b.length.compareTo(a.length));

    final baseStyle = FontStyles.reg14.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    );
    if (names.isEmpty) return TextSpan(text: visibleText, style: baseStyle);

    final tokenPattern = RegExp(names.map(RegExp.escape).join('|'));
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final match in tokenPattern.allMatches(visibleText)) {
      // 이름 중간이나 일반 단어 속에 포함된 문자열은 멘션으로 처리하지 않습니다.
      final startsAtWordBoundary =
          match.start == 0 ||
          !RegExp(r'[a-zA-Z0-9가-힣_]').hasMatch(visibleText[match.start - 1]);
      final endsAtWordBoundary =
          match.end == visibleText.length ||
          !RegExp(r'[a-zA-Z0-9가-힣_]').hasMatch(visibleText[match.end]);
      if (!startsAtWordBoundary || !endsAtWordBoundary) continue;

      if (match.start > cursor) {
        spans.add(TextSpan(text: visibleText.substring(cursor, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: FontStyles.semi14.copyWith(color: context.brands.beatOrange1),
        ),
      );
      cursor = match.end;
    }
    if (cursor < visibleText.length) {
      spans.add(TextSpan(text: visibleText.substring(cursor)));
    }
    return TextSpan(style: baseStyle, children: spans);
  }
}

typedef SendPostComment =
    Future<bool> Function(
      String content,
      int? parentCommentId,
      List<int> mentionedUserIds,
    );

class PostCommentComposer extends ConsumerStatefulWidget {
  const PostCommentComposer({
    super.key,
    required this.onSend,
    this.onFocusForNewComment,
  });

  final SendPostComment onSend;
  final VoidCallback? onFocusForNewComment;

  @override
  ConsumerState<PostCommentComposer> createState() =>
      PostCommentComposerState();
}

class PostCommentComposerState extends ConsumerState<PostCommentComposer> {
  final _controller = _MentionCommentController();
  final _focusNode = FocusNode();
  final _selectedMembers = <TeamMemberSearchResult>[];

  int? _parentId;
  String? _replyName;
  bool _sending = false;
  int? _mentionStart;
  String? _mentionQuery;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  void _handleFocusChanged() {
    if (_focusNode.hasFocus && _parentId == null) {
      widget.onFocusForNewComment?.call();
    }
  }

  bool get isReplying => _parentId != null;

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

    // 화면에는 @나 @{...} 문법을 남기지 않고 이름만 표시한다.
    // 실제 멘션 대상은 mentionedUserIds로 별도 전달한다.
    final visibleMention = '${member.userName} ';
    final updated = _controller.text.replaceRange(
      start,
      cursor,
      visibleMention,
    );
    final nextCursor = start + visibleMention.length;

    _controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: nextCursor),
    );

    if (!_selectedMembers.any(
      (selected) => selected.userPublicId == member.userPublicId,
    )) {
      _selectedMembers.add(member);
    }
    _syncMentionTextStyle();

    setState(() {
      _mentionStart = null;
      _mentionQuery = null;
    });
    _focusNode.requestFocus();
  }

  void _syncMentionTextStyle() {
    _controller.setMentionNames(
      _selectedMembers.map((member) => member.userName),
    );
  }

  Future<void> _send(String content) async {
    if (_sending) return;

    final ids = _selectedMembers
        .where(
          (member) =>
              member.userId != null && content.contains(member.userName),
        )
        .map((member) => member.userId!)
        .toSet()
        .toList();

    setState(() => _sending = true);
    try {
      // 답글 대상의 이름을 서버 댓글 본문에도 담아, 서버가 parentCommentId를
      // 루트로 정규화하더라도 답글의 답글 대상자를 다시 표시할 수 있도록 합니다.
      // @멘션 기능과는 별개이므로 mentionedUserIds에는 추가하지 않습니다.
      final payload = _parentId == null || _replyName == null
          ? content
          : '↳${_replyName!}↳ $content';
      final sent = await widget.onSend(payload, _parentId, ids);
      if (sent && mounted) {
        setState(() {
          _controller.clear();
          _selectedMembers.clear();
          _controller.setMentionNames(const <String>[]);
          _parentId = null;
          _replyName = null;
          _mentionStart = null;
          _mentionQuery = null;
        });
        if (_focusNode.hasFocus) widget.onFocusForNewComment?.call();
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _cancelReply() {
    setState(() {
      _parentId = null;
      _replyName = null;
    });
    if (_focusNode.hasFocus) widget.onFocusForNewComment?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_handleFocusChanged);
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
          _ReplyTargetBar(replyName: _replyName!, onClose: _cancelReply),
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
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 240),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: context.grays.gray7)),
      ),
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
                  style: FontStyles.med14.copyWith(color: context.grays.gray5),
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
                  role: MemberSelectionRole.fromApiValue(member.teamRole),
                  profileImageUrl: member.profileImageUrl,
                  isSelected: false,
                  onTap: () => onSelected(member),
                );
              },
            ),
    );
  }
}

class _ReplyTargetBar extends StatelessWidget {
  const _ReplyTargetBar({required this.replyName, required this.onClose});

  final String replyName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: AppSpacing.x16,
        right: AppSpacing.x8,
        top: AppSpacing.x8,
        bottom: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: context.grays.white,
        border: Border(top: BorderSide(color: context.grays.gray5)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/core/enter.svg',
            colorFilter: ColorFilter.mode(context.grays.gray1, BlendMode.srcIn),
          ),
          const SizedBox(width: AppSpacing.x8),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: FontStyles.med14.copyWith(color: context.grays.gray4),
                children: [
                  TextSpan(
                    text: replyName,
                    style: FontStyles.med14.copyWith(
                      color: context.brands.beatOrange1,
                    ),
                  ),
                  const TextSpan(text: ' 님에게 답글 작성 중'),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Semantics(
            button: true,
            label: '답글 작성 취소',
            child: IconButton(
              onPressed: onClose,
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.close_rounded,
                size: 18,
                color: context.grays.gray4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MentionCommentController extends TextEditingController {
  List<String> _mentionNames = const <String>[];

  void setMentionNames(Iterable<String> names) {
    final nextNames =
        names
            .map((name) => name.trim())
            .where((name) => name.isNotEmpty)
            .toSet()
            .toList()
          ..sort((a, b) => b.length.compareTo(a.length));

    _mentionNames = nextNames;
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (_mentionNames.isEmpty || text.isEmpty) {
      return TextSpan(style: style, text: text);
    }

    final pattern = RegExp(_mentionNames.map(RegExp.escape).join('|'));
    final spans = <TextSpan>[];
    var cursor = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }

      spans.add(
        TextSpan(
          text: match.group(0),
          style:
              style?.copyWith(color: context.brands.beatOrange1) ??
              TextStyle(color: context.brands.beatOrange1),
        ),
      );
      cursor = match.end;
    }

    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return TextSpan(style: style, children: spans);
  }
}
