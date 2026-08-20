import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Post 영역에서 사용하는 전용 TextField.
///
/// 기존 [AppTextField]의 입력/포커스/에러 처리 구조를 따르되,
/// Post 디자인에 맞게 아래 스타일을 고정한다.
/// - 배경: 흰색
/// - trailing SVG 색상: Post 전용 회색
/// - 높이 기본값: 45
///
/// 날짜/음악/장소처럼 직접 입력하지 않는 항목은
/// [readOnly] + [onTap] + [suffixIconPath] 조합으로 사용한다.
class PostTextField extends StatefulWidget {
  const PostTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.suffixIconPath,
    this.onSuffixPressed,
    this.suffixIconSize = 24,
    this.height = 45,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? hintText;

  final bool enabled;
  final bool readOnly;
  final bool obscureText;

  final String? errorText;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  /// trailing에 표시할 SVG asset 경로.
  ///
  /// 예:
  /// `assets/icons/cal/calendar.svg`
  /// `assets/icons/cal/music_symbol.svg`
  /// `assets/icons/cal/search.svg`
  final String? suffixIconPath;

  /// trailing 아이콘을 눌렀을 때 실행할 동작.
  final VoidCallback? onSuffixPressed;

  final double suffixIconSize;
  final double height;

  @override
  State<PostTextField> createState() => _PostTextFieldState();
}

class _PostTextFieldState extends State<PostTextField> {
  late final FocusNode _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  bool get _hasError {
    return widget.errorText != null && widget.errorText!.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant PostTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode).removeListener(
        _handleFocusChanged,
      );
      _focusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _internalFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final inputTextColor = widget.enabled
        ? colors.onSurface
        : colors.onSurfaceVariant;

    final hintColor = context.grays.gray4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
          decoration: BoxDecoration(
            color: context.grays.white,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: _borderColor(colors),
              width: _borderWidth,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      enabled: widget.enabled,
                      readOnly: widget.readOnly,
                      obscureText: widget.obscureText,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      onChanged: widget.onChanged,
                      onTap: widget.onTap,
                      cursorColor: colors.primary,
                      style: FontStyles.reg18.copyWith(
                        color: inputTextColor,
                        height: 1.0,
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        filled: false,
                        fillColor: Colors.transparent,
                        hintText: widget.hintText,
                        hintStyle: FontStyles.reg18.copyWith(
                          color: hintColor,
                          height: 1.0,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
              ),
              if (widget.suffixIconPath != null) ...[
                const SizedBox(width: AppSpacing.x8),
                _PostSuffixIcon(
                  iconPath: widget.suffixIconPath!,
                  size: widget.suffixIconSize,
                  onPressed: widget.onSuffixPressed ?? widget.onTap,
                ),
              ],
            ],
          ),
        ),
        if (_hasError) ...[
          const SizedBox(height: AppSpacing.x4),
          Text(
            widget.errorText!,
            style: FontStyles.reg12.copyWith(color: colors.error),
          ),
        ],
      ],
    );
  }

  Color _borderColor(ColorScheme colors) {
    if (_hasError) {
      return colors.error;
    }

    if (_focusNode.hasFocus) {
      return colors.secondary;
    }

    return Colors.transparent;
  }

  double get _borderWidth {
    if (_hasError || _focusNode.hasFocus) {
      return 1;
    }

    return 0;
  }
}

class _PostSuffixIcon extends StatelessWidget {
  const _PostSuffixIcon({
    required this.iconPath,
    required this.size,
    this.onPressed,
  });

  final String iconPath;
  final double size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(context.grays.gray5, BlendMode.srcIn),
    );

    if (onPressed == null) {
      return icon;
    }

    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox(width: 32, height: 32, child: Center(child: icon)),
      ),
    );
  }
}
