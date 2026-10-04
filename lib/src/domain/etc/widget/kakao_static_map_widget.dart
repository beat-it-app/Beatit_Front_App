import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

const String _kakaoRestApiKey = String.fromEnvironment('KAKAO_REST_API_KEY');

class KakaoStaticMapWidget extends StatelessWidget {
  const KakaoStaticMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height,
    this.level = 3,
    this.borderRadius = BorderRadius.zero,
    this.onTap,
    this.markerLabel,
  });

  final double latitude;
  final double longitude;
  final double? height;
  final int level;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final String? markerLabel;

  static const Map<String, String> _headers = <String, String>{
    'Authorization': 'KakaoAK $_kakaoRestApiKey',
  };

  static Uri _buildUri({
    required double latitude,
    required double longitude,
    required double logicalWidth,
    required double logicalHeight,
    required double devicePixelRatio,
    required int level,
  }) {
    final requestWidth = math.min(
      2048,
      math.max(1, (logicalWidth * devicePixelRatio).round()),
    );
    final requestHeight = math.min(
      1024,
      math.max(1, (logicalHeight * devicePixelRatio).round()),
    );

    return Uri.https('dapi.kakao.com', '/v2/maps/staticmap', <String, String>{
      'center': '$longitude,$latitude',
      'size': '${requestWidth}x$requestHeight',
      'lv': '$level',
    });
  }

  static NetworkImage _imageProvider({
    required double latitude,
    required double longitude,
    required double logicalWidth,
    required double logicalHeight,
    required double devicePixelRatio,
    required int level,
  }) {
    return NetworkImage(
      _buildUri(
        latitude: latitude,
        longitude: longitude,
        logicalWidth: logicalWidth,
        logicalHeight: logicalHeight,
        devicePixelRatio: devicePixelRatio,
        level: level,
      ).toString(),
      headers: _headers,
    );
  }

  /// 상세 화면 진입 시 지도 이미지를 Flutter ImageCache에 미리 올립니다.
  /// 같은 크기/레벨의 지도를 펼칠 때 추가 네트워크 로딩 없이 바로 표시됩니다.
  static Future<void> precacheMap({
    required BuildContext context,
    required double latitude,
    required double longitude,
    required double logicalWidth,
    required double logicalHeight,
    required int level,
  }) async {
    if (_kakaoRestApiKey.trim().isEmpty) {
      return;
    }

    final provider = _imageProvider(
      latitude: latitude,
      longitude: longitude,
      logicalWidth: logicalWidth,
      logicalHeight: logicalHeight,
      devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
      level: level,
    );

    await precacheImage(provider, context);
  }

  @override
  Widget build(BuildContext context) {
    final child = ClipRRect(
      borderRadius: borderRadius,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_kakaoRestApiKey.trim().isEmpty) {
            return _MapFallback(
              height: height,
              message: '카카오 지도 키가 설정되지 않았습니다.',
            );
          }

          final logicalWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : 512.0;
          final logicalHeight =
              height ??
              (constraints.maxHeight.isFinite ? constraints.maxHeight : 210.0);
          final imageProvider = _imageProvider(
            latitude: latitude,
            longitude: longitude,
            logicalWidth: logicalWidth,
            logicalHeight: logicalHeight,
            devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
            level: level,
          );

          return SizedBox(
            width: double.infinity,
            height: height,
            child: Image(
              image: imageProvider,
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (!wasSynchronouslyLoaded && frame == null) {
                  return _MapLoadingPlaceholder(height: height);
                }

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    child,
                    IgnorePointer(
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(0, -50),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (markerLabel?.trim().isNotEmpty == true)
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      constraints: const BoxConstraints(
                                        maxWidth: 250,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.x24,
                                        vertical: AppSpacing.x8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.grays.gray1,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.pill,
                                        ),
                                      ),
                                      child: Text(
                                        markerLabel!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: FontStyles.med16.copyWith(
                                          color: context.grays.white,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -20,
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: context.grays.gray1,
                                        size: 60,
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: 44,
                                height: 44,
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 44,
                                      color: context.brands.beatOrange2,
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 15,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: context.grays.white,
                                          shape: BoxShape.circle,
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
                    ),
                  ],
                );
              },
              errorBuilder: (_, __, ___) {
                return _MapFallback(height: height, message: '지도를 불러오지 못했습니다.');
              },
            ),
          );
        },
      ),
    );

    if (onTap == null) {
      return child;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: child),
    );
  }
}

class _MapLoadingPlaceholder extends StatelessWidget {
  const _MapLoadingPlaceholder({required this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: context.grays.gray8,
    );
  }
}

class _MapFallback extends StatelessWidget {
  const _MapFallback({required this.height, required this.message});

  final double? height;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: context.grays.gray8,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: FontStyles.med14.copyWith(color: context.grays.gray5),
      ),
    );
  }
}
