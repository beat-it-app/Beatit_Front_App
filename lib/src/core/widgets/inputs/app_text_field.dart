import 'package:flutter/material.dart';

import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

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
    this.errorText,
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
  final String? errorText;

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

    final labelStyle = textTheme.labelMedium?.copyWith(
      color: colors.onSurface,
    );

    final inputTextColor = widget.enabled
        ? colors.onSurface
        : colors.onSurfaceVariant;

    final hintColor = widget.enabled
        ? inputTheme.hintStyle?.color ?? colors.onSurfaceVariant
        : colors.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              style: labelStyle,
              children: [
                TextSpan(text: widget.label),
                if (widget.requiredMark)
                  TextSpan(
                    text: ' *',
                    style: labelStyle?.copyWith(
                      color: colors.primary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x8),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: widget.height,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x16,
          ),
          decoration: BoxDecoration(
            color: inputTheme.fillColor,
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
                  textAlignVertical: TextAlignVertical.center,
                  style: FontStyles.med18.copyWith(
                    color: inputTextColor,
                    height: 1.0,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    filled: false,
                    fillColor: Colors.transparent,
                    hintText: widget.hintText,
                    hintStyle: FontStyles.med18.copyWith(
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
        if (_hasError) ...[
          const SizedBox(height: AppSpacing.x8),
          Text(
            widget.errorText!,
            style: inputTheme.errorStyle,
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