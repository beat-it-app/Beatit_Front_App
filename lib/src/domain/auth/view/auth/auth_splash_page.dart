import 'dart:ui' as ui;

import 'package:beatit_front_app/src/app.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/auth_session.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signin_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/profile/create_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthSplashPage extends ConsumerStatefulWidget {
  const AuthSplashPage({super.key});

  @override
  ConsumerState<AuthSplashPage> createState() => _AuthSplashPageState();
}

class _AuthSplashPageState extends ConsumerState<AuthSplashPage>
    with SingleTickerProviderStateMixin {
  static const _introDelay = Duration(seconds: 1);
  static const _entranceDuration = Duration(seconds: 2);

  static const _headphoneAsset = 'assets/images/auth/headphone.png';
  static const _logoAsset = 'assets/icons/auth/main_logo.svg';

  static const _glassPaneCount = 7;

  late final AnimationController _controller;
  late final Animation<double> _headphoneEntrance;
  late final Animation<double> _logoEntrance;
  late final Animation<double> _headphoneOpacity;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textTransition;

  bool _didPrecacheImages = false;
  late final Future<AuthSession?> _sessionRestoreFuture;

  @override
  void initState() {
    super.initState();

    _sessionRestoreFuture = ref.read(authProvider.notifier).restoreSession();

    _controller = AnimationController(
      vsync: this,
      duration: _entranceDuration,
    );

    _headphoneEntrance = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.03, 0.43, curve: Curves.easeOutCubic),
    );
    _logoEntrance = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.08, 0.48, curve: Curves.easeOutCubic),
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
    precacheImage(const AssetImage(_headphoneAsset), context);
  }

  Future<void> _runSequence() async {
    await Future<void>.delayed(_introDelay);

    if (!mounted) {
      return;
    }

    await _controller.forward();
    final session = await _sessionRestoreFuture;

    if (!mounted) {
      return;
    }

    _navigateAfterSplash(session);
  }

  void _navigateAfterSplash(AuthSession? session) {
    final Widget nextPage;

    if (session == null) {
      nextPage = const SigninPage();
    } else if (session.createdProfile) {
      nextPage = const MainShell();
    } else {
      nextPage = const CreateProfilePage();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 180),
        pageBuilder: (_, animation, secondaryAnimation) => nextPage,
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
          _buildHeadphone(width: width, height: height),
          _buildGlassPanes(
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

  Widget _buildGlassPanes(
    BuildContext context, {
    required double width,
    required double height,
  }) {
    final glassWidth = width * 0.57;
    final paneWidth = glassWidth / _glassPaneCount;

    // 각 패널마다 아주 미세하게 다른 굴절량을 줘서
    // 하나의 큰 blur가 아니라 여러 장의 유리가 이어진 느낌을 만든다.
    const refractionOffsets = <double>[-12, 9, -7, 13, -10, 8, -5];
    const refractionScales = <double>[1.035, 0.985, 1.045, 0.975, 1.04, 0.99, 1.025];

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: glassWidth,
        height: height,
        child: Stack(
          children: List.generate(_glassPaneCount, (index) {
            final paneLeft = paneWidth * index;
            final paneProgress = _glassPaneProgress(index);
            final paneOffsetY = -height * 0.78 * (1 - paneProgress);

            return Positioned(
              left: paneLeft,
              top: 0,
              width: paneWidth + 0.5,
              height: height,
              child: Transform.translate(
                offset: Offset(0, paneOffsetY),
                child: _buildGlassPane(
                  context,
                  width: width,
                  height: height,
                  paneLeft: paneLeft,
                  paneWidth: paneWidth,
                  paneOffsetY: paneOffsetY,
                  refractionOffsetX: refractionOffsets[index],
                  refractionScaleX: refractionScales[index],
                  index: index,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildGlassPane(
    BuildContext context, {
    required double width,
    required double height,
    required double paneLeft,
    required double paneWidth,
    required double paneOffsetY,
    required double refractionOffsetX,
    required double refractionScaleX,
    required int index,
  }) {
    final colors = Theme.of(context).colorScheme;
    final headphoneOffsetY = -height * 0.70 * (1 - _headphoneEntrance.value);

    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 실제 뒤 레이어를 살짝만 흐린다. 굴절감은 아래 복제 레이어가 담당한다.
          BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 2.8,
              sigmaY: 1.8,
            ),
            child: ColoredBox(
              color: colors.onSurface.withValues(alpha: 0.015),
            ),
          ),

          // 패널 안에서만 헤드셋을 다시 그려 위치와 폭을 조금씩 틀어준다.
          // 이 레이어가 각 유리 조각마다 서로 다른 굴절을 만드는 핵심이다.
          Opacity(
            opacity: _headphoneOpacity.value * 0.50,
            child: OverflowBox(
              alignment: Alignment.topLeft,
              minWidth: width,
              maxWidth: width,
              minHeight: height,
              maxHeight: height,
              child: Transform.translate(
                offset: Offset(
                  -paneLeft + refractionOffsetX,
                  headphoneOffsetY - paneOffsetY,
                ),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(refractionScaleX, 1.0),
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: _buildHeadphoneArtwork(
                      width: width,
                      entranceScale: _headphoneEntrance.value,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 유리 가장자리의 빛과 음영을 각각의 사각 패널에 따로 준다.
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: colors.onSurface.withValues(
                    alpha: index == 0 ? 0.12 : 0.06,
                  ),
                  width: 0.6,
                ),
                right: BorderSide(
                  color: colors.onSurface.withValues(alpha: 0.16),
                  width: 0.8,
                ),
              ),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  colors.onSurface.withValues(alpha: 0.045),
                  colors.onSurface.withValues(alpha: 0.012),
                  colors.surface.withValues(alpha: 0.055),
                  colors.onSurface.withValues(alpha: 0.035),
                ],
                stops: const [0, 0.18, 0.78, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _glassPaneProgress(int index) {
    final start = 0.010 * index;
    final end = 0.38 + (0.010 * index);

    return Interval(
      start,
      end,
      curve: Curves.easeOutCubic,
    ).transform(_controller.value);
  }

  Widget _buildHeadphone({
    required double width,
    required double height,
  }) {
    return Opacity(
      // 요청한 대로 원본 헤드셋 자체는 50% 투명도로 표시한다.
      opacity: _headphoneOpacity.value * 0.50,
      child: Transform.translate(
        offset: Offset(
          0,
          -height * 0.70 * (1 - _headphoneEntrance.value),
        ),
        child: SizedBox.expand(
          child: _buildHeadphoneArtwork(
            width: width,
            entranceScale: _headphoneEntrance.value,
          ),
        ),
      ),
    );
  }

  Widget _buildHeadphoneArtwork({
    required double width,
    required double entranceScale,
  }) {
    return Align(
      // 레퍼런스처럼 우측 컵이 화면 바깥으로 일부 잘릴 정도로 크게 배치한다.
      alignment: const Alignment(0.22, -0.14),
      child: Transform.scale(
        scale: 0.97 + (0.03 * entranceScale),
        child: Image.asset(
          _headphoneAsset,
          width: width * 1.34,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
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
