import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'app_field_message.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.requiredMark = false,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.isError = false,
    this.errorText,
    this.messageText,
    this.messageColor,
    this.messageIcon,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.height = 45,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? label;
  final String? hintText;
  final bool requiredMark;

  final bool enabled;
  final bool readOnly;
  final bool obscureText;

  /// 외부에서 오류 문구를 표시할 때, 문구 없이 오류 테두리만 적용함.
  ///
  /// 기존처럼 [errorText]를 전달하면 오류 테두리와 문구가 모두 표시됨.
  final bool isError;
  final String? errorText;

  final String? messageText;
  final Color? messageColor;
  final String? messageIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  final double height;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  bool get _hasInlineError {
    return widget.errorText != null && widget.errorText!.isNotEmpty;
  }

  bool get _hasError {
    return widget.isError || _hasInlineError;
  }

  bool get _hasMessage {
    return widget.messageText != null && widget.messageText!.isNotEmpty;
  }

  bool get _hasBottomText {
    return _hasInlineError || _hasMessage;
  }

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final inputTheme = theme.inputDecorationTheme;

    final labelStyle = FontStyles.semi16.copyWith(color: colors.onSurface);

    final inputTextColor = widget.enabled
        ? colors.onSurface
        : colors.onSurfaceVariant;

    final hintColor = widget.enabled
        ? inputTheme.hintStyle?.color ?? colors.onSurfaceVariant
        : colors.onSurfaceVariant;

    final bottomText = _hasInlineError ? widget.errorText : widget.messageText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              style: labelStyle,
              children: [
                TextSpan(text: widget.label, style: labelStyle),
                if (widget.requiredMark)
                  TextSpan(
                    text: ' *',
                    style: labelStyle.copyWith(color: colors.primary),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x8),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
          decoration: BoxDecoration(
            color: widget.enabled
                ? inputTheme.fillColor
                : colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: _borderColor(colors),
              width: _borderWidth,
            ),
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: inputTheme.suffixIconColor,
                    size: 20,
                  ),
                  child: widget.prefixIcon!,
                ),
                const SizedBox(width: AppSpacing.x8),
              ],
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
              if (widget.suffixIcon != null) ...[
                const SizedBox(width: AppSpacing.x8),
                IconTheme(
                  data: IconThemeData(
                    color: inputTheme.suffixIconColor,
                    size: 20,
                  ),
                  child: widget.suffixIcon!,
                ),
              ],
            ],
          ),
        ),
        if (_hasBottomText) ...[
          const SizedBox(height: AppSpacing.x4),
          AppFieldMessage(
            text: bottomText!,
            isError: _hasInlineError,
            color: widget.messageColor,
            icon: widget.messageIcon,
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
