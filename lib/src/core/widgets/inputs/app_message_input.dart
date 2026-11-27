import 'package:flutter/material.dart';

import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class AppMessageInput extends StatefulWidget {
  const AppMessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.focusNode,
    this.hintText = '대화 시작하기',
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;

  final String hintText;
  final bool enabled;

  final ValueChanged<String> onSend;

  @override
  State<AppMessageInput> createState() => _AppMessageInputState();
}

class _AppMessageInputState extends State<AppMessageInput> {
  static const double _minimumHeight = 44;
  static const double _maximumHeight = 120;
  static const double _sendButtonSize = 36;

  bool get _canSend {
    return widget.enabled && widget.controller.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(covariant AppMessageInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleTextChanged);
      widget.controller.addListener(_handleTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChanged);
    super.dispose();
  }

  void _handleTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _sendMessage() {
    if (!_canSend) {
      return;
    }

    final message = widget.controller.text.trim();

    // trim은 문자열 앞뒤 공백과 줄바꿈만 제거합니다.
    // 문장 내부의 \n은 그대로 유지됩니다.
    widget.onSend(message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

    final inputBackgroundColor =
        inputTheme.fillColor ?? colors.surfaceContainerHighest;

    final hintColor = inputTheme.hintStyle?.color ?? colors.onSurfaceVariant;

    final sendButtonColor = _canSend
        ? colors.primary
        : colors.onSurface.withAlpha(31);

    final sendIconColor = _canSend
        ? colors.onPrimary
        : colors.onSurface.withAlpha(71);

    return AnimatedSize(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: _minimumHeight,
          maxHeight: _maximumHeight,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: inputBackgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x16,
              AppSpacing.x4,
              AppSpacing.x4,
              AppSpacing.x4,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    enabled: widget.enabled,

                    // 엔터 입력 시 전송하지 않고 줄바꿈합니다.
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 5,

                    cursorColor: colors.primary,
                    style: FontStyles.med16.copyWith(
                      color: colors.onSurface,
                      height: 1.3,
                    ),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      filled: false,
                      hintText: widget.hintText,
                      hintStyle: FontStyles.med16.copyWith(
                        color: hintColor,
                        height: 1.3,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.x8,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    onTapOutside: (_) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.x8),
                Semantics(
                  button: true,
                  enabled: _canSend,
                  label: '메시지 보내기',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: _sendButtonSize,
                    height: _sendButtonSize,
                    decoration: BoxDecoration(
                      color: sendButtonColor,
                      shape: BoxShape.circle,
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: _canSend ? _sendMessage : null,
                        customBorder: const CircleBorder(),
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          size: 24,
                          color: sendIconColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
