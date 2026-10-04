import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthSplashPage extends StatefulWidget {
  const AuthSplashPage({super.key});

  @override
  State<AuthSplashPage> createState() => _AuthSplashPageState();
}

class _AuthSplashPageState extends State<AuthSplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runSequence();
    });
  }

  Future<void> _runSequence() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) {
      return;
    }

    await _controller.forward();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 220),
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

          return Scaffold(
            backgroundColor: colors.surface,
            body: SafeArea(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final progress = _controller.value;
                  final entranceProgress = Curves.easeOutCubic.transform(
                    (progress / 0.48).clamp(0.0, 1.0),
                  );
                  final fadeProgress = Curves.easeOut.transform(
                    (progress / 0.30).clamp(0.0, 1.0),
                  );
                  final textColor = Color.lerp(
                    context.grays.gray5,
                    colors.onSurface,
                    Curves.easeInOut.transform(progress),
                  )!;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final height = constraints.maxHeight;

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          if (progress > 0) ...[
                            Opacity(
                              opacity: fadeProgress,
                              child: Transform.translate(
                                offset: Offset(
                                  0,
                                  -height * 0.55 * (1 - entranceProgress),
                                ),
                                child: Align(
                                  alignment: const Alignment(0, -0.05),
                                  child: _WindowBars(
                                    width: width * 0.55,
                                    height: height * 0.54,
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: fadeProgress,
                              child: Transform.translate(
                                offset: Offset(
                                  0,
                                  -height * 0.42 * (1 - entranceProgress),
                                ),
                                child: Align(
                                  alignment: const Alignment(0.18, -0.20),
                                  child: _HeadsetGraphic(size: width * 0.46),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: fadeProgress,
                              child: Transform.translate(
                                offset: Offset(
                                  0,
                                  height * 0.46 * (1 - entranceProgress),
                                ),
                                child: Align(
                                  alignment: const Alignment(0, -0.02),
                                  child: SizedBox(
                                    width: width * 0.70,
                                    child: SvgPicture.asset(
                                      'assets/icons/auth/main_logo.svg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          Align(
                            alignment: const Alignment(0, 0.18),
                            child: Text(
                              '음악 모임 공간은 빗잇에서!',
                              style: FontStyles.med16.copyWith(
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
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
}

class _WindowBars extends StatelessWidget {
  const _WindowBars({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final lineColor = context.grays.gray6.withOpacity(0.34);
    final glowColor = context.brands.beatOrange3.withOpacity(0.08);

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, glowColor, Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: List.generate(7, (index) {
            return Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(width: 1, color: lineColor),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _HeadsetGraphic extends StatelessWidget {
  const _HeadsetGraphic({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.grays.gray4,
            context.brands.beatOrange3,
            context.grays.gray2,
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Icon(
        Icons.headphones_rounded,
        size: size,
        color: context.grays.white,
      ),
    );
  }
}
