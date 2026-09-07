import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class AppTextArea extends StatefulWidget {
  const AppTextArea({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.requiredMark = false,
    this.enabled = true,
    this.readOnly = false,
    this.isError = false,
    this.errorText,
    this.maxLength = 200,
    this.showCounter = true,
    this.fieldHeight = 140,
    this.onChanged,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? label;
  final String? hintText;
  final bool requiredMark;

  final bool enabled;
  final bool readOnly;

  /// 외부에서 오류 문구를 표시할 때, 문구 없이 오류 테두리만 적용함.
  ///
  /// 기존처럼 [errorText]를 전달하면 오류 테두리와 문구가 모두 표시됨.
  final bool isError;
  final String? errorText;

  final int? maxLength;
  final bool showCounter;
  final double fieldHeight;

  final ValueChanged<String>? onChanged;

  @override
  State<AppTextArea> createState() => _AppTextAreaState();
}

class _AppTextAreaState extends State<AppTextArea> {
  late final TextEditingController _internalController;

  TextEditingController get _controller {
    return widget.controller ?? _internalController;
  }

  bool get _hasInlineError {
    return widget.errorText != null && widget.errorText!.isNotEmpty;
  }

  bool get _hasError {
    return widget.isError || _hasInlineError;
  }

  bool get _shouldShowCounter {
    return widget.showCounter && widget.maxLength != null;
  }

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
  }

  @override
  void dispose() {
    _internalController.dispose();
    super.dispose();
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

    final areaTextStyle = FontStyles.reg16.copyWith(color: inputTextColor);

    final areaHintStyle = FontStyles.reg16.copyWith(
      color: inputTheme.hintStyle?.color ?? colors.onSurfaceVariant,
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: BorderSide(color: colors.error, width: 1),
    );

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
        SizedBox(
          height: widget.fieldHeight,
          child: TextFormField(
            controller: _controller,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLength: widget.maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            expands: true,
            minLines: null,
            maxLines: null,
            textAlignVertical: TextAlignVertical.top,

            // 핵심: text area 실제 입력값은 med16
            style: areaTextStyle,

            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: areaHintStyle,
              counterText: '',

              border: _hasError ? errorBorder : null,
              enabledBorder: _hasError ? errorBorder : null,
              focusedBorder: _hasError ? errorBorder : null,
              disabledBorder: _hasError ? errorBorder : null,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x16,
                vertical: AppSpacing.x12,
              ),
            ),
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        if (_hasInlineError || _shouldShowCounter) ...[
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _hasInlineError
                    ? Text(widget.errorText!, style: inputTheme.errorStyle)
                    : const SizedBox.shrink(),
              ),
              if (_shouldShowCounter)
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, _) {
                    return Text(
                      '${value.text.length}/${widget.maxLength}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurface,
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }
}
