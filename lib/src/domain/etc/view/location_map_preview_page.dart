import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/location_detail_provider.dart';
import 'package:beatit_front_app/src/domain/etc/widget/kakao_static_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationMapPreviewPage extends ConsumerWidget {
  const LocationMapPreviewPage({super.key, required this.locationId});

  final int locationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationDetailProvider(locationId));

    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppTopAppBar.closeOnly(
        onClosePressed: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        top: false,
        child: locationAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _LocationLoadError(
            message: error.toString(),
            onRetry: () => ref.invalidate(locationDetailProvider(locationId)),
          ),
          data: (location) => _LocationMapPreviewContent(location: location),
        ),
      ),
    );
  }
}

class _LocationMapPreviewContent extends StatelessWidget {
  const _LocationMapPreviewContent({required this.location});

  final LocationData location;

  @override
  Widget build(BuildContext context) {
    final latitude = location.latitude;
    final longitude = location.longitude;

    return Stack(
      children: [
        Positioned.fill(
          child: latitude != null && longitude != null
              ? KakaoStaticMapWidget(
                  latitude: latitude,
                  longitude: longitude,
                  level: 3,
                )
              : Container(
                  color: context.grays.gray8,
                  alignment: Alignment.center,
                  child: Text(
                    '저장된 위치 좌표가 없습니다.',
                    style: FontStyles.med14.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                ),
        ),
        Positioned(
          left: AppSpacing.x20,
          right: AppSpacing.x20,
          bottom: AppSpacing.x20,
          child: _LocationInfoCard(location: location),
        ),
      ],
    );
  }
}

class _LocationInfoCard extends StatelessWidget {
  const _LocationInfoCard({required this.location});

  final LocationData location;

  Future<void> _openKakaoMap(BuildContext context) async {
    final rawUrl = location.mapUrl?.trim();
    final uri = rawUrl == null || rawUrl.isEmpty ? null : Uri.tryParse(rawUrl);

    if (uri == null || !uri.hasScheme) {
      _showOpenError(context);
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        _showOpenError(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showOpenError(context);
      }
    }
  }

  void _showOpenError(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('카카오맵을 열 수 없습니다.')));
  }

  @override
  Widget build(BuildContext context) {
    final locationName = _textOrFallback(location.locationName, '장소 정보 없음');
    final roadAddress = _textOrFallback(location.roadAddress, '주소 정보 없음');
    final phone = location.phone?.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.grays.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locationName,
            style: FontStyles.semi20.copyWith(color: context.colors.onSurface),
          ),
          const SizedBox(height: AppSpacing.x8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _openKakaoMap(context),
            child: Text(
              '카카오맵에서 보기',
              style: FontStyles.med14.copyWith(
                color: context.brands.beatOrange2,
                decoration: TextDecoration.underline,
                decorationColor: context.brands.beatOrange2,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x16),
          _InfoLine(label: '장소', value: roadAddress),
          if (phone != null && phone.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x8),
            _InfoLine(label: '전화', value: phone),
          ],
        ],
      ),
    );
  }

  static String _textOrFallback(String? value, String fallback) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? fallback : trimmed;
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x8,
            vertical: AppSpacing.x4,
          ),
          decoration: BoxDecoration(
            color: context.grays.gray8,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            label,
            style: FontStyles.semi12.copyWith(color: context.grays.gray1),
          ),
        ),
        const SizedBox(width: AppSpacing.x8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.x4),
            child: Text(
              value,
              style: FontStyles.med14.copyWith(color: context.colors.onSurface),
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationLoadError extends StatelessWidget {
  const _LocationLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: FontStyles.med14.copyWith(color: context.grays.gray5),
            ),
            const SizedBox(height: AppSpacing.x16),
            TextButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
