import 'dart:ui' as ui;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthSplashPage extends StatefulWidget {
  const AuthSplashPage({super.key});

  @override
  State<AuthSplashPage> createState() => _AuthSplashPageState();
}

class _AuthSplashPageState extends State<AuthSplashPage>
    with SingleTickerProviderStateMixin {
  static const _introDelay = Duration(seconds: 1);
  static const _entranceDuration = Duration(seconds: 2);

  static const _windowAsset = 'assets/images/auth/window.png';
  static const _headphoneAsset = 'assets/images/auth/headphone.png';
  static const _logoAsset = 'assets/icons/auth/main_logo.svg';

  late final AnimationController _controller;
  late final Animation<double> _windowEntrance;
  late final Animation<double> _headphoneEntrance;
  late final Animation<double> _logoEntrance;
  late final Animation<double> _windowOpacity;
  late final Animation<double> _headphoneOpacity;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textTransition;

  bool _didPrecacheImages = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _entranceDuration,
    );

    // 실제 이동은 초반 약 0.8~1초 안에 끝낸다.
    // 남은 시간은 완성된 화면을 잠깐 보여 준 뒤 로그인으로 넘어간다.
    _windowEntrance = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.38, curve: Curves.easeOutCubic),
    );
    _headphoneEntrance = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.03, 0.43, curve: Curves.easeOutCubic),
    );
    _logoEntrance = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.08, 0.48, curve: Curves.easeOutCubic),
    );

    _windowOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.18, curve: Curves.easeOut),
    );
    _headphoneOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.03, 0.20, curve: Curves.easeOut),
    );
    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.08, 0.24, curve: Curves.easeOut),
    );
    _textTransition = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.04, 0.58, curve: Curves.easeInOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _runSequence());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didPrecacheImages) {
      return;
    }

    _didPrecacheImages = true;
    precacheImage(const AssetImage(_windowAsset), context);
    precacheImage(const AssetImage(_headphoneAsset), context);
  }

  Future<void> _runSequence() async {
    await Future<void>.delayed(_introDelay);

    if (!mounted) {
      return;
    }

    await _controller.forward();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 180),
        pageBuilder: (_, animation, secondaryAnimation) => const SigninPage(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: Builder(
        builder: (context) {
          final colors = Theme.of(context).colorScheme;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: colors.surface,
            ),
            child: Scaffold(
              backgroundColor: colors.surface,
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return _buildSplashScene(
                        context,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSplashScene(
    BuildContext context, {
    required double width,
    required double height,
  }) {
    final colors = Theme.of(context).colorScheme;
    final grayText = context.grays.gray5;
    final textColor = Color.lerp(
      grayText,
      colors.onSurface,
      _textTransition.value,
    )!;

    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // BackdropFilter는 이미 그려진 픽셀만 흐릴 수 있으므로
          // 헤드셋을 먼저 그리고 유리 패널을 그 위에 올린다.
          _buildHeadphone(width: width, height: height),
          _buildWindow(
            context,
            width: width,
            height: height,
          ),
          _buildLogoAndCaption(
            context,
            width: width,
            height: height,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildWindow(
    BuildContext context, {
    required double width,
    required double height,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Opacity(
      opacity: _windowOpacity.value,
      child: Transform.translate(
        offset: Offset(
          0,
          -height * 0.72 * (1 - _windowEntrance.value),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            // 레퍼런스처럼 화면 좌측 절반을 유리 패널 영역으로 사용한다.
            width: width * 0.5,
            height: height,
            child: ClipRect(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Figma Background Blur에 대응하는 실시간 블러.
                  // 이 레이어보다 먼저 그려진 헤드셋이 실제로 흐려진다.
                  BackdropFilter(
                    filter: ui.ImageFilter.blur(
                      sigmaX: 15,
                      sigmaY: 15,
                    ),
                    child: ColoredBox(
                      color: colors.onSurface.withValues(alpha: 0.018),
                    ),
                  ),

                  // 아주 약한 유리 틴트와 가장자리 하이라이트.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: colors.onSurface.withValues(alpha: 0.10),
                          width: 1,
                        ),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colors.onSurface.withValues(alpha: 0.055),
                          colors.onSurface.withValues(alpha: 0.018),
                          colors.onSurface.withValues(alpha: 0.035),
                        ],
                        stops: const [0, 0.52, 1],
                      ),
                    ),
                  ),

                  // 기존 window.png는 블러를 대신하는 이미지가 아니라,
                  // 세로 반사선/굴절 질감을 더하는 오버레이로만 사용한다.
                  IgnorePointer(
                    child: Image.asset(
                      _windowAsset,
                      width: width * 0.5,
                      height: height,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeadphone({
    required double width,
    required double height,
  }) {
    return Opacity(
      opacity: _headphoneOpacity.value,
      child: Transform.translate(
        offset: Offset(
          0,
          -height * 0.70 * (1 - _headphoneEntrance.value),
        ),
        child: Align(
          // 최종 헤드셋 중심은 화면 중앙보다 살짝 위, 오른쪽에 둔다.
          alignment: const Alignment(0.10, -0.18),
          child: Transform.scale(
            scale: 0.98 + (0.02 * _headphoneEntrance.value),
            child: Image.asset(
              _headphoneAsset,
              // 원본 883 x 883 중 실제 헤드셋 픽셀은 중앙 약 59% 폭만 차지한다.
              // 따라서 canvas 자체를 화면 폭과 비슷하게 잡아야 최종 오브젝트가
              // 레퍼런스처럼 화면의 약 60% 폭으로 보인다.
              width: width * 1.05,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoAndCaption(
    BuildContext context, {
    required double width,
    required double height,
    required Color textColor,
  }) {
    return Align(
      // 로고가 헤드셋 중앙부를 가로지르고 문구가 바로 아래 붙도록 배치한다.
      alignment: const Alignment(0, -0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: _logoOpacity.value,
            child: Transform.translate(
              offset: Offset(
                0,
                height * 0.44 * (1 - _logoEntrance.value),
              ),
              child: SvgPicture.asset(
                _logoAsset,
                width: width * 0.78,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -5),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '음악 모임 공간은 ',
                    style: FontStyles.med16.copyWith(color: textColor),
                  ),
                  TextSpan(
                    text: '빗잇',
                    style: FontStyles.exbold16.copyWith(color: textColor),
                  ),
                  TextSpan(
                    text: '에서!',
                    style: FontStyles.med16.copyWith(color: textColor),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
