import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/utils/should_show_updated_at.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/etc/provider/location_detail_provider.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_map_preview_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/picture_preview_page.dart';
import 'package:beatit_front_app/src/domain/etc/widget/kakao_static_map_widget.dart';
import 'package:beatit_front_app/src/domain/team/api/team_archive_api.dart';
import 'package:beatit_front_app/src/domain/team/model/team_archive_detail_model.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_archive_provider.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_list_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_update_page.dart';
import 'package:beatit_front_app/src/domain/team/widget/team_archive_comments.dart';

class TeamArchiveDetailPage extends ConsumerStatefulWidget {
  final int archiveId;

  const TeamArchiveDetailPage({super.key, required this.archiveId});

  @override
  ConsumerState<TeamArchiveDetailPage> createState() =>
      _TeamArchiveDetailPageState();
}

class _TeamArchiveDetailPageState extends ConsumerState<TeamArchiveDetailPage> {
  final _composerKey = GlobalKey<TeamArchiveCommentComposerState>();

  bool _isMapVisible = false;
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
          if (data.rating.myRating > 0) {
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

  void _openImagePreview(List<String> imageUrls, int initialIndex) {
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

  // 💡 디자인 시안과 동일한 '2026. 4. 2. 15:47' 형태 포맷팅
  String _formatDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final year = dt.year;
      final month = dt.month;
      final day = dt.day;
      final hour = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return '$year. $month. $day. $hour:$min';
    } catch (_) {
      return raw;
    }
  }

  // 💡 PostDetailPage에서 사용하는 shouldShowUpdatedAt 유틸리티 연동
  bool _isUpdated(String? createdAt, String? updatedAt) {
    if (createdAt == null || updatedAt == null) return false;
    if (createdAt.trim().isEmpty || updatedAt.trim().isEmpty) return false;

    final created = DateTime.tryParse(createdAt);
    final updated = DateTime.tryParse(updatedAt);
    if (created == null || updated == null) return false;

    return shouldShowUpdatedAt(created, updated);
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
          _myRating = newRating.myRating > 0
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
                // 💡 수정 화면으로 이동 후 복귀 시 무조건 최신 상세 정보 재조회
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeamArchiveUpdatePage(detail: detail),
                  ),
                );

                if (mounted) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
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

                          // 2. 작성일 / 최종수정일 (시안 포맷 적용)
                          Row(
                            children: [
                              Text(
                                _formatDateTime(detail.createdAt),
                                style: FontStyles.reg14.copyWith(
                                  color: context.grays.gray4,
                                ),
                              ),
                              if (_isUpdated(
                                detail.createdAt,
                                detail.updatedAt,
                              )) ...[
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
                                      detail.rating.averageRating
                                          .toStringAsFixed(1),
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
                                    horizontal: 10,
                                    vertical: 5,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              const SizedBox(width: AppSpacing.x8),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: canShowMap ? _toggleMapVisibility : null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.x4,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '지도보기',
                                        style: FontStyles.med15.copyWith(
                                          color: canShowMap
                                              ? context.brands.beatOrange2
                                              : context.grays.gray5,
                                          decoration: canShowMap
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                          decorationColor:
                                              context.brands.beatOrange2,
                                          decorationThickness: 1.06,
                                          height: 1,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.x4),
                                      AnimatedRotation(
                                        turns: _isMapVisible ? 0.5 : 0,
                                        duration: const Duration(
                                          milliseconds: 220,
                                        ),
                                        curve: Curves.easeInOut,
                                        child: SvgPicture.asset(
                                          'assets/icons/cal/toggle_down.svg',
                                          width: 20,
                                          height: 20,
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
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x10),

                          // 6. 카카오 정적 지도 미리보기
                          _VerticalAccordion(
                            isExpanded: _isMapVisible && canShowMap,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.x20,
                              ),
                              child:
                                  (_isMapReady &&
                                      locationData?.latitude != null &&
                                      locationData?.longitude != null)
                                  ? KakaoStaticMapWidget(
                                      latitude: locationData!.latitude!,
                                      longitude: locationData.longitude!,
                                      height: 210,
                                      level: 3,
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () =>
                                          _openMapPreview(detail.locationId),
                                    )
                                  : _InlineMapLoading(
                                      onReady: () => _prepareMapInBackground(
                                        detail.locationId,
                                      ),
                                    ),
                            ),
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
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => _openImagePreview(
                                      detail.archiveImageUrls,
                                      index,
                                    ),
                                    child: ClipRRect(
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
                                      width: 16,
                                      height: 16,
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
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/post/chat_off.svg',
                                    width: 16,
                                    height: 16,
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
                        ],
                      ),
                    ),

                    // 9. 댓글 리스트
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.x16,
                        0,
                        AppSpacing.x16,
                        AppSpacing.x24,
                      ),
                      child: TeamArchiveCommentList(
                        comments: detail.commentList,
                        canModerate: detail.isWriter,
                        onReply: (comment) =>
                            _composerKey.currentState?.replyTo(comment),
                        onDelete: _deleteComment,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 10. 댓글 입력창
            ColoredBox(
              color: colors.surface,
              child: TeamArchiveCommentComposer(
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

class _VerticalAccordion extends StatelessWidget {
  const _VerticalAccordion({required this.isExpanded, required this.child});

  final bool isExpanded;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 220),
      firstCurve: Curves.easeInOut,
      secondCurve: Curves.easeInOut,
      sizeCurve: Curves.easeInOut,
      crossFadeState: isExpanded
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: SizedBox(width: double.infinity, child: child),
      secondChild: const SizedBox(width: double.infinity, height: 0),
    );
  }
}

class _InlineMapLoading extends StatefulWidget {
  const _InlineMapLoading({required this.onReady});

  final Future<void> Function() onReady;

  @override
  State<_InlineMapLoading> createState() => _InlineMapLoadingState();
}

class _InlineMapLoadingState extends State<_InlineMapLoading> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onReady();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
