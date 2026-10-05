import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/etc/model/team_member_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/location_detail_provider.dart';
import 'package:beatit_front_app/src/domain/etc/provider/member_selection_provider.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_map_preview_page.dart';
import 'package:beatit_front_app/src/domain/etc/widget/kakao_static_map_widget.dart';
import 'package:beatit_front_app/src/domain/etc/widget/member_selection_item.dart';
import 'package:beatit_front_app/src/domain/post/widget/app_comment_input.dart';
import 'package:beatit_front_app/src/domain/team/api/team_archive_api.dart';
import 'package:beatit_front_app/src/domain/team/model/team_archive_detail_model.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_archive_provider.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_list_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_update_page.dart';

class TeamArchiveDetailPage extends ConsumerStatefulWidget {
  final int archiveId;

  const TeamArchiveDetailPage({super.key, required this.archiveId});

  @override
  ConsumerState<TeamArchiveDetailPage> createState() =>
      _TeamArchiveDetailPageState();
}

class _TeamArchiveDetailPageState extends ConsumerState<TeamArchiveDetailPage> {
  final _composerKey = GlobalKey<_ArchiveCommentComposerState>();

  bool _isMapVisible = true;
  bool _isLoading = true;
  String? _errorMessage;
  TeamArchiveDetailModel? _detail;

  // 지도 프리로드 및 상태 관리
  bool _isMapReady = false;
  String? _preloadKey;
  Future<void>? _mapPreloadFuture;

  int? _myRating;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(teamArchiveApiProvider);
      final data = await api.getArchiveDetail(widget.archiveId);

      if (mounted) {
        setState(() {
          _detail = data;
          _isLoading = false;
          if (data.rating.myRating != null && data.rating.myRating! > 0) {
            _myRating = data.rating.myRating.toInt();
          }
        });

        if (data.locationId > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _prepareMapInBackground(data.locationId);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _prepareMapInBackground(int locationId) async {
    try {
      final location = await ref.read(
        locationDetailProvider(locationId).future,
      );

      if (!mounted) return;

      final latitude = location.latitude;
      final longitude = location.longitude;
      if (latitude == null || longitude == null) return;

      final logicalWidth =
          (MediaQuery.sizeOf(context).width - (AppSpacing.x20 * 2))
              .clamp(1.0, double.infinity)
              .toDouble();
      final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
      final preloadKey =
          '$locationId:$latitude:$longitude:$logicalWidth:$devicePixelRatio';

      if (_preloadKey == preloadKey) return;

      _preloadKey = preloadKey;
      final preloadFuture = KakaoStaticMapWidget.precacheMap(
        context: context,
        latitude: latitude,
        longitude: longitude,
        logicalWidth: logicalWidth,
        logicalHeight: 210,
        level: 3,
      );
      _mapPreloadFuture = preloadFuture;

      try {
        await preloadFuture;
      } catch (_) {}

      if (!mounted || _mapPreloadFuture != preloadFuture) return;

      setState(() {
        _isMapReady = true;
      });
    } catch (_) {}
  }

  void _openMapPreview(int locationId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LocationMapPreviewPage(locationId: locationId),
      ),
    );
  }

  void _toggleMapVisibility() {
    setState(() {
      _isMapVisible = !_isMapVisible;
    });
  }

  String _formatDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final month = dt.month.toString().padLeft(2, '0');
      final day = dt.day.toString().padLeft(2, '0');
      final hour = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return '${dt.year}.$month.$day $hour:$min';
    } catch (_) {
      return raw;
    }
  }

  Future<bool> _addComment(
    String content,
    int? parentId,
    List<int> mentionedUserIds,
  ) async {
    final text = content.trim();
    if (text.isEmpty) return false;

    try {
      final api = ref.read(teamArchiveApiProvider);
      await api.addComment(
        archiveId: widget.archiveId,
        comment: text,
        parentCommentId: parentId,
        mentionedUserIds: mentionedUserIds,
      );

      await _fetchDetail();
      ref.read(teamArchiveProvider.notifier).fetchArchives();
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('댓글 작성 실패: $e')));
      }
      return false;
    }
  }

  Future<void> _deleteComment(int commentId) async {
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
      final api = ref.read(teamArchiveApiProvider);
      await api.deleteComment(
        archiveId: widget.archiveId,
        commentId: commentId,
      );

      await _fetchDetail();
      ref.read(teamArchiveProvider.notifier).fetchArchives();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('댓글이 삭제되었습니다.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('댓글 삭제 실패: $e')));
      }
    }
  }

  Future<void> _submitRating(int rating) async {
    try {
      final api = ref.read(teamArchiveApiProvider);
      final newRating = await api.updateRating(
        archiveId: widget.archiveId,
        rating: rating,
      );

      if (mounted) {
        setState(() {
          _myRating = (newRating.myRating != null && newRating.myRating! > 0)
              ? newRating.myRating.toInt()
              : rating;
          if (_detail != null) {
            _detail = TeamArchiveDetailModel(
              archiveId: _detail!.archiveId,
              teamId: _detail!.teamId,
              writerId: _detail!.writerId,
              title: _detail!.title,
              roadAddress: _detail!.roadAddress,
              locationId: _detail!.locationId,
              description: _detail!.description,
              archiveImageUrls: _detail!.archiveImageUrls,
              writerName: _detail!.writerName,
              writerProfileImageUrl: _detail!.writerProfileImageUrl,
              isWriter: _detail!.isWriter,
              topArchive: _detail!.topArchive,
              rating: newRating,
              commentCount: _detail!.commentCount,
              commentList: _detail!.commentList,
              createdAt: _detail!.createdAt,
              updatedAt: _detail!.updatedAt,
            );
          }
        });

        ref.read(teamArchiveProvider.notifier).fetchArchives();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('별점이 반영되었습니다.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('별점 등록 실패: $e')));
      }
    }
  }

  void _showRatingDialog(BuildContext context) {
    int tempRating = _myRating ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.fromLTRB(14, 50, 14, 18),
              content: SizedBox(
                width: 280,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _detail?.title ?? '',
                      style: FontStyles.bold22.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '별점을 남기시겠습니까?',
                      style: FontStyles.reg22.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final isFilled = starIndex <= tempRating;

                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              tempRating = starIndex;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: SvgPicture.asset(
                              isFilled
                                  ? 'assets/icons/team/filled_star.svg'
                                  : 'assets/icons/team/star.svg',
                              width: 30,
                              height: 30,
                              colorFilter: ColorFilter.mode(
                                isFilled
                                    ? Theme.of(context).colorScheme.primary
                                    : context.grays.gray7,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '별점을 선택하세요',
                      style: FontStyles.semi16.copyWith(
                        color: context.grays.gray4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: context.grays.gray8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              '취소',
                              style: FontStyles.semi16.copyWith(
                                color: context.grays.gray4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              if (tempRating > 0) {
                                Navigator.pop(context);
                                _submitRating(tempRating);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('별점을 1점 이상 선택해주세요.'),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              '확인',
                              style: FontStyles.semi16.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final double contentWidth =
        MediaQuery.of(context).size.width - (AppSpacing.x20 * 2);

    if (_isLoading) {
      return Scaffold(
        appBar: AppTopAppBar.backMore(
          onBackPressed: () => Navigator.pop(context),
          onMorePressed: () {},
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _detail == null) {
      return Scaffold(
        appBar: AppTopAppBar.backMore(
          onBackPressed: () => Navigator.pop(context),
          onMorePressed: () {},
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage ?? '상세 정보를 불러오지 못했습니다.',
                style: FontStyles.med16.copyWith(color: colors.error),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: _fetchDetail, child: const Text('다시 시도')),
            ],
          ),
        ),
      );
    }

    final detail = _detail!;
    final locationAsync = detail.locationId > 0
        ? ref.watch(locationDetailProvider(detail.locationId))
        : null;

    final locationData = locationAsync?.asData?.value;
    final canShowMap =
        locationData?.latitude != null && locationData?.longitude != null;

    return Scaffold(
      appBar: AppTopAppBar.backMore(
        onBackPressed: () => Navigator.pop(context),
        moreMenuOffset: const Offset(-20, 56),
        moreMenuItems: [
          if (detail.isWriter) ...[
            AppDropdownItem(
              label: '수정하기',
              onPressed: () async {
                final updated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeamArchiveUpdatePage(detail: detail),
                  ),
                );

                if (updated == true && mounted) {
                  await _fetchDetail();
                  ref.read(teamArchiveProvider.notifier).fetchArchives();
                }
              },
            ),
            AppDropdownItem(
              label: '삭제하기',
              onPressed: () async {
                final confirmed = await AppPopup.show(
                  context,
                  title: '정말 삭제하시겠습니까?',
                  content: '삭제된 게시물은\n복구할 수 없습니다.',
                  warningType: WarningType.triangle,
                  contentType: ContentType.small,
                  buttonNum: ButtonNum.two,
                  buttonSymmetric: ButtonSymmetric.horizontal,
                  confirmText: '확인',
                  cancelText: '취소',
                );

                if (!mounted) return;

                if (confirmed == true) {
                  try {
                    await ref
                        .read(teamArchiveApiProvider)
                        .deleteArchive(widget.archiveId);
                    ref.read(teamArchiveProvider.notifier).fetchArchives();

                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeamArchiveListPage(),
                      ),
                      (route) => route.isFirst,
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('삭제에 실패했습니다: $e')));
                  }
                }
              },
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. 연습실 제목
                      Text(
                        detail.title,
                        style: FontStyles.bold34.copyWith(
                          color: colors.onSurface,
                          letterSpacing: -0.68,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),

                      // 2. 작성일 / 최종수정일
                      Row(
                        children: [
                          Text(
                            _formatDateTime(detail.createdAt),
                            style: FontStyles.reg14.copyWith(
                              color: context.grays.gray4,
                            ),
                          ),
                          if (detail.updatedAt.isNotEmpty &&
                              detail.updatedAt != detail.createdAt) ...[
                            Text(
                              ' ｜ 최종수정일 ${_formatDateTime(detail.updatedAt)}',
                              style: FontStyles.reg14.copyWith(
                                color: context.grays.gray5,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x10),

                      // 3. 평점 & 뱃지
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.grays.gray8,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/team/filled_star.svg',
                                  width: 16,
                                  height: 16,
                                  colorFilter: ColorFilter.mode(
                                    colors.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  detail.rating.averageRating.toStringAsFixed(
                                    1,
                                  ),
                                  style: FontStyles.med12.copyWith(
                                    color: colors.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '(${detail.rating.ratingCount})',
                                  style: FontStyles.med12.copyWith(
                                    color: context.grays.gray5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (detail.topArchive) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: context.brands.beatOrange5,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '밴드가 찾는 1순위',
                                style: FontStyles.med12.copyWith(
                                  color: colors.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x16),

                      // 4. 소개글
                      Text(
                        detail.description,
                        style: FontStyles.reg14.copyWith(
                          color: context.grays.black,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x20),

                      // 5. 위치 정보 및 지도보기 토글
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.grays.gray8,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/cal/location.svg',
                                  width: 16,
                                  height: 16,
                                  colorFilter: ColorFilter.mode(
                                    context.grays.gray1,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '위치',
                                  style: FontStyles.semi12.copyWith(
                                    color: colors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              detail.roadAddress ?? '위치 정보 없음',
                              style: FontStyles.med16.copyWith(
                                color: colors.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: canShowMap ? _toggleMapVisibility : null,
                            child: Row(
                              children: [
                                Text(
                                  '지도보기',
                                  style: FontStyles.med16.copyWith(
                                    color: canShowMap
                                        ? context.brands.beatOrange2
                                        : context.grays.gray5,
                                    decoration: canShowMap
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    decorationColor: context.brands.beatOrange2,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                RotatedBox(
                                  quarterTurns: _isMapVisible ? 2 : 0,
                                  child: SvgPicture.asset(
                                    'assets/icons/cal/toggle_down.svg',
                                    colorFilter: ColorFilter.mode(
                                      canShowMap
                                          ? context.brands.beatOrange2
                                          : context.grays.gray5,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x12),

                      // 6. 카카오 정적 지도 미리보기 (토글형)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: _isMapVisible && canShowMap
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.x20,
                                ),
                                child: _isMapReady
                                    ? KakaoStaticMapWidget(
                                        latitude: locationData!.latitude!,
                                        longitude: locationData.longitude!,
                                        height: 210,
                                        level: 3,
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () =>
                                            _openMapPreview(detail.locationId),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 210,
                                        decoration: BoxDecoration(
                                          color: context.grays.gray8,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      // 7. 아카이브 이미지 리스트 (가로 스크롤)
                      if (detail.archiveImageUrls.isNotEmpty) ...[
                        SizedBox(
                          height: 190,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: detail.archiveImageUrls.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final imgUrl = detail.archiveImageUrls[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  width: (contentWidth - 8) / 2,
                                  color: context.grays.gray8,
                                  child: Image.network(
                                    imgUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/team/archive.svg',
                                        width: 28,
                                        height: 28,
                                        colorFilter: ColorFilter.mode(
                                          context.grays.gray5,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x20),
                      ],

                      const Divider(height: 1),
                      const SizedBox(height: AppSpacing.x14),

                      // 8. 내 별점 및 댓글 개수
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showRatingDialog(context),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  _myRating != null
                                      ? 'assets/icons/team/filled_star.svg'
                                      : 'assets/icons/team/star.svg',
                                  width: 18,
                                  height: 18,
                                  colorFilter: ColorFilter.mode(
                                    _myRating != null
                                        ? colors.primary
                                        : context.grays.gray4,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _myRating != null
                                      ? '내 별점 ${_myRating!.toStringAsFixed(1)}'
                                      : '별점 남기기',
                                  style: FontStyles.med14.copyWith(
                                    color: _myRating != null
                                        ? colors.primary
                                        : context.grays.gray4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/team/reply.svg',
                                width: 18,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                  context.grays.gray4,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '댓글 ${detail.commentCount}',
                                style: FontStyles.med14.copyWith(
                                  color: context.grays.gray4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x20),

                      // 9. 댓글 목록
                      _buildCommentList(detail),
                    ],
                  ),
                ),
              ),
            ),

            // 10. 하단 댓글 작성기
            _ArchiveCommentComposer(key: _composerKey, onSend: _addComment),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentList(TeamArchiveDetailModel detail) {
    if (detail.commentList.isEmpty) {
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
        for (final comment in detail.commentList) ...[
          _ArchiveSwipeComment(
            key: ValueKey(comment.commentId),
            comment: comment,
            canDelete: detail.isWriter || comment.isMine,
            onReply: () => _composerKey.currentState?.replyTo(comment),
            onDelete: () => _deleteComment(comment.commentId),
          ),
          for (final reply in comment.replies)
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.x20,
                top: AppSpacing.x12,
              ),
              child: _ArchiveSwipeComment(
                key: ValueKey(reply.commentId),
                comment: reply,
                canDelete: detail.isWriter || reply.isMine,
                onReply: () => _composerKey.currentState?.replyTo(reply),
                onDelete: () => _deleteComment(reply.commentId),
              ),
            ),
          const SizedBox(height: AppSpacing.x20),
        ],
      ],
    );
  }
}

class _ArchiveSwipeComment extends StatefulWidget {
  const _ArchiveSwipeComment({
    super.key,
    required this.comment,
    required this.canDelete,
    required this.onReply,
    required this.onDelete,
  });

  final TeamArchiveCommentModel comment;
  final bool canDelete;
  final VoidCallback onReply;
  final Future<void> Function() onDelete;

  @override
  State<_ArchiveSwipeComment> createState() => _ArchiveSwipeCommentState();
}

class _ArchiveSwipeCommentState extends State<_ArchiveSwipeComment> {
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
                          _formatDate(comment.createdAt),
                          style: FontStyles.reg12.copyWith(
                            color: context.grays.gray4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x8),
                        Text.rich(
                          _mentionText(
                            context,
                            comment.content,
                            comment.mentionedUsers,
                          ),
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

  static String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final date = DateTime.parse(raw).toLocal();
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.'
          '${date.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw;
    }
  }

  static TextSpan _mentionText(
    BuildContext context,
    String content,
    List<ArchiveMentionUserModel> mentionedUsers,
  ) {
    final legacyMentionPattern = RegExp(r'@\{([^}]+)\}|@([a-zA-Z0-9가-힣_]+)');
    final legacyNames = legacyMentionPattern
        .allMatches(content)
        .map((match) => match.group(1) ?? match.group(2) ?? '')
        .where((name) => name.isNotEmpty);

    final visibleText = content.replaceAllMapped(
      legacyMentionPattern,
      (match) => match.group(1) ?? match.group(2) ?? '',
    );

    final mentionNames =
        <String>{
            ...mentionedUsers.map((user) => user.nickname.trim()),
            ...legacyNames,
          }.where((name) => name.isNotEmpty).toList()
          ..sort((a, b) => b.length.compareTo(a.length));

    if (mentionNames.isEmpty) {
      return TextSpan(
        text: visibleText,
        style: FontStyles.reg14.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
    }

    final pattern = RegExp(mentionNames.map(RegExp.escape).join('|'));
    final spans = <TextSpan>[];
    var cursor = 0;

    for (final match in pattern.allMatches(visibleText)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: visibleText.substring(cursor, match.start)));
      }

      spans.add(
        TextSpan(
          text: match.group(0),
          style: FontStyles.reg14.copyWith(color: context.brands.beatOrange1),
        ),
      );
      cursor = match.end;
    }

    if (cursor < visibleText.length) {
      spans.add(TextSpan(text: visibleText.substring(cursor)));
    }

    return TextSpan(
      style: FontStyles.reg14.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      children: spans,
    );
  }
}

typedef SendArchiveComment =
    Future<bool> Function(
      String content,
      int? parentCommentId,
      List<int> mentionedUserIds,
    );

class _ArchiveCommentComposer extends ConsumerStatefulWidget {
  const _ArchiveCommentComposer({super.key, required this.onSend});

  final SendArchiveComment onSend;

  @override
  ConsumerState<_ArchiveCommentComposer> createState() =>
      _ArchiveCommentComposerState();
}

class _ArchiveCommentComposerState
    extends ConsumerState<_ArchiveCommentComposer> {
  final _controller = _ArchiveMentionCommentController();
  final _focusNode = FocusNode();
  final _selectedMembers = <TeamMemberSearchResult>[];

  int? _parentId;
  String? _replyName;
  bool _sending = false;
  int? _mentionStart;
  String? _mentionQuery;

  void replyTo(TeamArchiveCommentModel comment) {
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
      final sent = await widget.onSend(content, _parentId, ids);
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
          _ArchiveMentionSuggestionList(
            state: memberState,
            members: mentionMembers,
            onSelected: _selectMention,
          ),
        if (_replyName != null)
          _ArchiveReplyTargetBar(replyName: _replyName!, onClose: _cancelReply),
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

class _ArchiveMentionSuggestionList extends StatelessWidget {
  const _ArchiveMentionSuggestionList({
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

class _ArchiveReplyTargetBar extends StatelessWidget {
  const _ArchiveReplyTargetBar({
    required this.replyName,
    required this.onClose,
  });

  final String replyName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
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
          Icon(
            Icons.subdirectory_arrow_right_rounded,
            size: 18,
            color: context.grays.gray4,
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

class _ArchiveMentionCommentController extends TextEditingController {
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
