import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/location_detail_provider.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_map_preview_page.dart';
import 'package:beatit_front_app/src/domain/etc/widget/kakao_static_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// CalDetailPage와 동일하게 지도 토글 후 지도를 누르면 장소 상세 지도로 이동한다.
class PerformanceLocationSection extends ConsumerStatefulWidget {
  const PerformanceLocationSection({super.key, required this.location});

  final LocationData location;

  @override
  ConsumerState<PerformanceLocationSection> createState() =>
      _PerformanceLocationSectionState();
}

class _PerformanceLocationSectionState
    extends ConsumerState<PerformanceLocationSection> {
  bool _showMap = false;
  bool _mapReady = false;
  String? _precacheKey;

  @override
  void didUpdateWidget(covariant PerformanceLocationSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location.locationId != widget.location.locationId) {
      _precacheKey = null;
      _mapReady = false;
      _showMap = false;
    }
  }

  Future<void> _prepareMap(double latitude, double longitude) async {
    final width = MediaQuery.sizeOf(context).width - AppSpacing.x20 * 2;
    final scale = MediaQuery.devicePixelRatioOf(context);
    final key = '$latitude:$longitude:$width:$scale';
    if (key == _precacheKey) return;
    _precacheKey = key;
    _mapReady = false;
    try {
      await KakaoStaticMapWidget.precacheMap(
        context: context,
        latitude: latitude,
        longitude: longitude,
        logicalWidth: width,
        logicalHeight: 210,
        level: 3,
      );
    } catch (_) {
      // Cal과 동일하게 지도 프리로드 실패가 페이지 이용을 막지 않도록 한다.
    }
    if (!mounted || _precacheKey != key) return;
    setState(() => _mapReady = true);
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.location;
    if (location.latitude != null && location.longitude != null) {
      return _locationContent(
        name: location.locationName ?? location.roadAddress ?? '공연 장소',
        latitude: location.latitude,
        longitude: location.longitude,
      );
    }
    if (location.locationId <= 0) {
      return _locationContent(
        name: location.locationName ?? location.roadAddress ?? '공연 장소',
      );
    }
    return ref
        .watch(locationDetailProvider(location.locationId))
        .when(
          loading: () =>
              _locationContent(name: location.locationName ?? '장소 불러오는 중...'),
          error: (_, __) =>
              _locationContent(name: location.locationName ?? '공연 장소'),
          data: (detail) => _locationContent(
            name: detail.locationName ?? location.locationName ?? '공연 장소',
            latitude: detail.latitude,
            longitude: detail.longitude,
          ),
        );
  }

  Widget _locationContent({
    required String name,
    double? latitude,
    double? longitude,
  }) {
    final hasMap = latitude != null && longitude != null;
    if (latitude != null && longitude != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _prepareMap(latitude, longitude);
      });
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '공연 장소',
            style: FontStyles.reg14.copyWith(color: context.grays.gray5),
          ),
          const SizedBox(height: AppSpacing.x8),
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: FontStyles.reg14.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
              ),
              if (hasMap)
                InkWell(
                  onTap: () => setState(() => _showMap = !_showMap),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '지도보기',
                        style: FontStyles.med14.copyWith(
                          color: context.brands.beatOrange2,
                          decoration: TextDecoration.underline,
                          decorationColor: context.brands.beatOrange2,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                      AnimatedRotation(
                        turns: _showMap ? 0.5 : 0,
                        duration: const Duration(milliseconds: 220),
                        child: SvgPicture.asset(
                          'assets/icons/cal/toggle_down.svg',
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            context.brands.beatOrange2,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (_showMap && latitude != null && longitude != null) ...[
            const SizedBox(height: AppSpacing.x12),
            _mapReady
                ? KakaoStaticMapWidget(
                    latitude: latitude,
                    longitude: longitude,
                    height: 210,
                    level: 3,
                    borderRadius: BorderRadius.circular(8),
                    onTap: widget.location.locationId <= 0
                        ? null
                        : () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => LocationMapPreviewPage(
                                locationId: widget.location.locationId,
                              ),
                            ),
                          ),
                  )
                : const SizedBox(
                    height: 210,
                    child: Center(child: CircularProgressIndicator()),
                  ),
          ],
        ],
      ),
    );
  }
}
