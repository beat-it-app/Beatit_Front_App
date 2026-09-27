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
import 'package:beatit_front_app/src/domain/etc/view/location_map_preview_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/music_preview_page.dart';
import 'package:beatit_front_app/src/domain/etc/widget/location_result_widget.dart';
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
      final data = await ref.read(postApiProvider).getPoll(widget.pollId);
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
    if (mounted)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
  }

  void _showOptionsPreview() {
    final data = _data;
    if (data == null) return;
    final isMusic = data.pollType == 'MUSIC';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.grays.white,
      builder: (sheetContext) => SafeArea(
        child: FractionallySizedBox(
          heightFactor: 0.58,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.x20),
                child: Row(
                  children: [
                    const SizedBox(width: 24),
                    Expanded(
                      child: Text(
                        isMusic ? '음악 미리듣기' : '장소 미리보기',
                        textAlign: TextAlign.center,
                        style: FontStyles.bold20.copyWith(
                          color: context.grays.black,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.pollItems.length,
                  itemBuilder: (context, index) {
                    final item = data.pollItems[index];
                    if (!isMusic) {
                      return LocationResultWidget(
                        name: item.locationName ?? item.location ?? '장소',
                        address: item.roadAddress ?? '',
                        onTap: item.locationId == null
                            ? null
                            : () {
                                Navigator.of(sheetContext).pop();
                                Navigator.of(this.context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LocationMapPreviewPage(
                                      locationId: item.locationId!,
                                    ),
                                  ),
                                );
                              },
                      );
                    }
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x20,
                      ),
                      leading: SvgPicture.asset(
                        'assets/icons/post/music_symbol.svg',
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          context.brands.beatOrange1,
                          BlendMode.srcIn,
                        ),
                      ),
                      title: Text(
                        item.title ?? '',
                        style: FontStyles.med16.copyWith(
                          color: context.grays.black,
                        ),
                      ),
                      subtitle: Text(item.artist ?? ''),
                      onTap: item.previewUrl == null || item.previewUrl!.isEmpty
                          ? null
                          : () {
                              Navigator.of(sheetContext).pop();
                              Navigator.of(this.context).push(
                                MaterialPageRoute(
                                  builder: (_) => MusicPreviewPage(
                                    musicTitle: item.title ?? '',
                                    artist: item.artist ?? '',
                                    imageUrl: '',
                                    previewUrl: item.previewUrl!,
                                  ),
                                ),
                              );
                            },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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

    if (_data == null)
      return Scaffold(
        body: Center(
          child: _error == null
              ? const CircularProgressIndicator()
              : Text(_error!),
        ),
      );
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
              _showError('수정 화면은 아직 연결되지 않았습니다.');
            },
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
