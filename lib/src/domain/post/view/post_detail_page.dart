import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/etc/view/picture_preview_page.dart';
import 'package:beatit_front_app/src/domain/post/view/post_create_page.dart';
import 'package:beatit_front_app/src/domain/post/widget/post_comments.dart';
import 'package:beatit_front_app/src/domain/post/model/post_detail_models.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({super.key, required this.noticeId});
  final int noticeId;

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  NoticeDetailData? _data;
  String? _error;
  final _composerKey = GlobalKey<PostCommentComposerState>();
  final ScrollController _scrollController = ScrollController();
  bool _reactionPending = false;
  int get _commentCount => _data?.reaction.commentCount ?? 0;
  List<String> get imageUrls => _data?.images ?? const [];

  @override
  void initState() { super.initState(); Future.microtask(_load); }

  Future<void> _load() async {
    try {
      final data = await ref.read(postApiProvider).getNotice(widget.noticeId);
      if (!mounted) return;
      setState(() {
        _data = data;
        _error = null;
      });
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  void _showError(Object error) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
  }

  bool get _isLiked => _data?.reaction.isLiked ?? false;
  bool get _isDisliked => _data?.reaction.isDisliked ?? false;
  int get _likedCount => _data?.reaction.likeCount ?? 0;
  int get _dislikedCount => _data?.reaction.dislikeCount ?? 0;
  Future<void> _toggleLike() async {
    if (_reactionPending || _data == null) return;
    _reactionPending = true;
    try {
      final api = ref.read(postApiProvider);
      if (_isDisliked) await api.toggleNoticeDislike(widget.noticeId);
      await api.toggleNoticeLike(widget.noticeId);
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) await _load();
      _reactionPending = false;
    }
  }
  Future<void> _toggleDislike() async {
    if (_reactionPending || _data == null) return;
    _reactionPending = true;
    try {
      final api = ref.read(postApiProvider);
      if (_isLiked) await api.toggleNoticeLike(widget.noticeId);
      await api.toggleNoticeDislike(widget.noticeId);
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) await _load();
      _reactionPending = false;
    }
  }

  Future<bool> _addComment(String message, int? parentId, List<int> mentions) async {
    if (message.trim().isEmpty) return false;
    try {
      await ref.read(postApiProvider).commentNotice(widget.noticeId, message.trim(),
        parentCommentId: parentId, mentionedUserIds: mentions);
      if (mounted) await _load();
      return true;
    } catch (error) { _showError(error); return false; }
  }

  Future<void> _deleteComment(int id) async {
    try {
      await ref.read(postApiProvider).deleteNoticeComment(widget.noticeId, id);
      if (mounted) await _load();
    } catch (error) { _showError(error); }
  }

  Future<void> _openEditPage() async {
    final data = _data;
    if (data == null) return;

    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PostCreatePage(initialNotice: data),
      ),
    );

    if (updated == true && mounted) {
      await _load();
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await AppPopup.show(
      context,
      title: '삭제하시겠습니까?',
      content: '삭제한 내용은 복구할 수 없습니다.',
      buttonNum: ButtonNum.two,
      warningType: WarningType.circle,
      confirmText: '삭제',
      cancelText: '취소',
    );
    if (confirmed != true || !mounted) return;

    try {
      await ref.read(postApiProvider).deleteNotice(widget.noticeId);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      _showError(error);
    }
  }

  void _openImagePreview(int initialIndex) {
    if (imageUrls.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PicturePreviewPage(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${dateTime.year}.${twoDigits(dateTime.month)}.'
        '${twoDigits(dateTime.day)} ${twoDigits(dateTime.hour)}:'
        '${twoDigits(dateTime.minute)}';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (_data == null) return Scaffold(body: Center(child: _error == null ? const CircularProgressIndicator() : Text(_error!)));
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
            onPressed: _openEditPage,
          ),
          AppDropdownItem(
            label: '삭제하기',
            onPressed: () {
              _confirmDelete();
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
                            _data!.title,
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
                              _ProfileAvatar(imageUrl: _data!.writerProfileImageUrl),
                              const SizedBox(width: AppSpacing.x8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _data!.writerName,
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
                                            text: _formatDateTime(_data!.createdAt.toLocal()),
                                            style: FontStyles.reg12.copyWith(
                                              color: context.grays.gray4,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ｜최종수정일 ${_formatDateTime(_data!.updatedAt.toLocal())}',
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
                              _data!.content,
                              softWrap: true,
                              style: FontStyles.reg14.copyWith(
                                color: context.grays.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x24),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(top: AppSpacing.x8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < imageUrls.length; i++) ...[
                                  Semantics(
                                    button: true,
                                    label: '${i + 1}번째 사진 크게 보기',
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => _openImagePreview(i),
                                      child: SizedBox(
                                        width: 190,
                                        height: 190,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.lg,
                                          ),
                                          child: Image.network(
                                            imageUrls[i],
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }

                                              return ColoredBox(
                                                color: colors.surfaceContainerHighest,
                                                child: const Center(
                                                  child: SizedBox(
                                                    width: 18,
                                                    height: 18,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return ColoredBox(
                                                color: colors.errorContainer,
                                                child: Icon(
                                                  Icons.image_not_supported_outlined,
                                                  color: colors.onErrorContainer,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (i < imageUrls.length - 1)
                                    const SizedBox(width: AppSpacing.x8),
                                ],
                              ],
                            ),
                          ),
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
                      child: Wrap(
                        spacing: AppSpacing.x10,
                        runSpacing: AppSpacing.x4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Semantics(
                            button: true,
                            toggled: _isLiked,
                            label: '좋아요',
                            child: InkWell(
                              onTap: _toggleLike,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.x4,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      _isLiked
                                          ? 'assets/icons/post/heart.svg'
                                          : 'assets/icons/post/heart_off.svg',
                                      width: 24,
                                      height: 24,
                                      colorFilter: ColorFilter.mode(
                                        _isLiked
                                            ? colors.primary
                                            : context.grays.gray4,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.x4),
                                    Text(
                                      '좋아요 $_likedCount',
                                      style: FontStyles.reg14.copyWith(
                                        color: context.grays.gray4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Semantics(
                            button: true,
                            toggled: _isDisliked,
                            label: '싫어요',
                            child: InkWell(
                              onTap: _toggleDislike,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.x4,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 19,
                                      height: 19,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _isDisliked
                                            ? colors.primary
                                            : context.grays.white,
                                        border: Border.all(
                                          color: _isDisliked
                                              ? colors.primary
                                              : context.grays.gray4,
                                          width: 0.9,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/post/sad_face.svg',
                                        colorFilter: ColorFilter.mode(
                                          _isDisliked
                                              ? context.grays.white
                                              : context.grays.gray4,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.x4),
                                    Text(
                                      '싫어요 $_dislikedCount',
                                      style: FontStyles.reg14.copyWith(
                                        color: context.grays.gray4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
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
                        ],
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
                      child: PostCommentList(
                        comments: _data!.commentList,
                        canModerate: _data!.isWriter,
                        onReply: (comment) => _composerKey.currentState?.replyTo(comment),
                        onDelete: _deleteComment,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ColoredBox(
              color: colors.surface,
              child: PostCommentComposer(
                key: _composerKey,
                onSend: _addComment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 40,
      height: 40,
      child: ClipOval(
        child: imageUrl == null || imageUrl!.isEmpty
            ? const Icon(Icons.person_outline_rounded)
            : Image.network(
          imageUrl!,
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
