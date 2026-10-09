import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/post/widget/post_comments.dart';
import 'package:beatit_front_app/src/domain/post/widget/poll_selection_box.dart';
import 'package:beatit_front_app/src/domain/post/model/post_detail_models.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_api_provider.dart';
import 'package:beatit_front_app/src/domain/post/post_date_time.dart';
import 'package:beatit_front_app/src/domain/post/view/poll_create_page.dart';
import 'package:beatit_front_app/src/domain/post/widget/poll_options_preview_sheet.dart';
import 'package:beatit_front_app/src/domain/post/widget/poll_voters_sheet.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_map_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PollDetailPage extends ConsumerStatefulWidget {
  const PollDetailPage({
    super.key,
    required this.pollId,
    this.participantCount,
  });
  final int pollId;
  final int? participantCount;

  @override
  ConsumerState<PollDetailPage> createState() => _PollDetailPageState();
}

class _PollDetailPageState extends ConsumerState<PollDetailPage> {
  PollDetailData? _data;
  bool _remindBeforeClose = false;
  String? _error;
  final _composerKey = GlobalKey<PostCommentComposerState>();
  final ScrollController _scrollController = ScrollController();
  int get _commentCount => _data?.commentCount ?? 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    try {
      final result = await ref
          .read(postApiProvider)
          .getPollWithMetadata(widget.pollId);
      if (!mounted) return;
      setState(() {
        _data = result.data;
        _remindBeforeClose = result.remindBeforeClose;
        _error = null;
      });
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  void _showError(Object error) {
    if (mounted)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
  }

  void _showOptionsPreview() {
    final data = _data;
    if (data == null) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      builder: (sheetContext) => PollOptionsPreviewSheet(
        items: data.pollItems,
        isMusic: data.pollType == 'MUSIC',
        onLocationTap: (locationId) {
          Navigator.of(sheetContext).pop();
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => LocationMapPreviewPage(locationId: locationId),
          ));
        },
      ),
    );
  }

  void _showOptionVoters(int index) {
    final data = _data;
    if (data == null || data.isAnonymous ||
        !data.pollItems.any((item) => item.isVoted) ||
        index < 0 || index >= data.pollItems.length) return;
    final optionId = data.pollItems[index].itemId;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surface,
      isScrollControlled: true,
      builder: (_) => PollVotersSheet(
        loadVoters: () => ref.read(postApiProvider)
            .getPollOptionVoters(widget.pollId, optionId),
      ),
    );
  }

  Future<bool> _addComment(
    String message,
    int? parentId,
    List<int> mentions,
  ) async {
    if (message.trim().isEmpty) return false;
    try {
      await ref
          .read(postApiProvider)
          .commentPoll(
            widget.pollId,
            message.trim(),
            parentCommentId: parentId,
            mentionedUserIds: mentions,
          );
      if (mounted) await _load();
      return true;
    } catch (error) {
      _showError(error);
      return false;
    }
  }

  Future<void> _deleteComment(int id) async {
    try {
      await ref.read(postApiProvider).deletePollComment(widget.pollId, id);
      if (mounted) await _load();
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _openEditPage() async {
    final data = _data;
    if (data == null || !data.isWriter) return;

    final hasVotes =
        (widget.participantCount ?? 0) > 0 ||
        data.pollItems.any((item) => item.voteCount > 0);
    if (hasVotes) {
      _showError('참여자가 있는 투표는 수정할 수 없습니다.');
      return;
    }

    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PollCreatePage(
          initialData: data,
          initialRemindBeforeClose: _remindBeforeClose,
        ),
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
      await ref.read(postApiProvider).deletePoll(widget.pollId);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      _showError(error);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return formatPostDateTime(dateTime);
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

    if (_data == null)
      return Scaffold(
        body: Center(
          child: _error == null
              ? const CircularProgressIndicator()
              : Text(_error!),
        ),
      );
    return Scaffold(
      appBar: _data!.isWriter
          ? AppTopAppBar.backMore(
              onBackPressed: () {
                Navigator.of(context).maybePop();
              },
              moreMenuOffset: const Offset(-16, 40),
              moreMenuItems: [
                AppDropdownItem(
                  label: '수정하기',
                  onPressed: _openEditPage,
                ),
                AppDropdownItem(
                  label: '삭제하기',
                  onPressed: _confirmDelete,
                ),
              ],
            )
          : AppTopAppBar.backOnly(
              onBackPressed: () {
                Navigator.of(context).maybePop();
              },
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
                        AppSpacing.x16,
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
                              _ProfileAvatar(
                                imageUrl: _data!.writerProfileImageUrl,
                              ),
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
                                            text: _formatDateTime(
                                              _data!.createdAt.toLocal(),
                                            ),
                                            style: FontStyles.reg12.copyWith(
                                              color: context.grays.gray4,
                                            ),
                                          ),
                                          if (!_data!.updatedAt.isAtSameMomentAs(
                                            _data!.createdAt,
                                          ))
                                            TextSpan(
                                              text:
                                                  ' ｜최종수정일 ${_formatDateTime(_data!.updatedAt.toLocal())}',
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
                              _data!.content ?? '',
                              softWrap: true,
                              style: FontStyles.reg14.copyWith(
                                color: context.grays.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x24),
                          PollSelectionBox(
                            key: ValueKey(
                              '${_data!.pollId}-${_data!.updatedAt}',
                            ),
                            options: _data!.pollItems
                                .map(
                                  (item) =>
                                      item.content ??
                                      item.locationName ??
                                      item.location ??
                                      ((item.title ?? '') +
                                          (item.artist == null
                                              ? ''
                                              : ' - ${item.artist}')),
                                )
                                .toList(),
                            status:
                                _data!.closeAt != null &&
                                    !_data!.closeAt!.isAfter(DateTime.now())
                                ? PollStatus.completed
                                : PollStatus.inProgress,
                            isAnonymous: _data!.isAnonymous,
                            participantCount: widget.participantCount ?? 0,
                            selectionMode: _data!.allowMultipleChoice
                                ? PollSelectionMode.multiple
                                : PollSelectionMode.single,
                            initialVoteCounts: _data!.pollItems
                                .map((item) => item.voteCount)
                                .toList(),
                            initialSelectedIndexes: {
                              for (
                                var index = 0;
                                index < _data!.pollItems.length;
                                index++
                              )
                                if (_data!.pollItems[index].isVoted) index,
                            },
                            initialHasVoted: _data!.pollItems.any(
                              (item) => item.isVoted,
                            ),
                            optionType: switch (_data!.pollType) {
                              'MUSIC' => PollOptionDisplayType.music,
                              'LOCATION' => PollOptionDisplayType.location,
                              _ => PollOptionDisplayType.text,
                            },
                            onPreviewTap:
                                _data!.pollType == 'MUSIC' ||
                                    _data!.pollType == 'LOCATION'
                                ? _showOptionsPreview
                                : null,
                            onVoteSubmitted: (indexes) async {
                              try {
                                await ref
                                    .read(postApiProvider)
                                    .votePoll(
                                      widget.pollId,
                                      indexes
                                          .map(
                                            (index) =>
                                                _data!.pollItems[index].itemId,
                                          )
                                          .toList(),
                                    );
                                if (mounted) await _load();
                                return true;
                              } catch (error) {
                                _showError(error);
                                return false;
                              }
                            },
                            onParticipantTap: _showOptionVoters,
                            onMapTap: (index) {
                              final locationId =
                                  _data!.pollItems[index].locationId;
                              if (locationId != null)
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LocationMapPreviewPage(
                                      locationId: locationId,
                                    ),
                                  ),
                                );
                            },
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
                      child: PostCommentList(
                        comments: _data!.commentList,
                        canModerate: _data!.isWriter,
                        onReply: (comment) =>
                            _composerKey.currentState?.replyTo(comment),
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

  static const String _fallbackAsset =
      'assets/images/auth/profile_orange.png';

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasImageUrl = imageUrl?.trim().isNotEmpty == true;

    return SizedBox(
      width: 40,
      height: 40,
      child: ClipOval(
        child: hasImageUrl
            ? Image.network(
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
                  return Image.asset(_fallbackAsset, fit: BoxFit.cover);
                },
              )
            : Image.asset(_fallbackAsset, fit: BoxFit.cover),
      ),
    );
  }
}
