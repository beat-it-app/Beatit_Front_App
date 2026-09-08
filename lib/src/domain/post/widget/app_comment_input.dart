import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AppCommentInput extends StatefulWidget {
  const AppCommentInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.focusNode,
    this.hintText = '댓글을 입력해주세요.',
    this.sendButtonSemanticLabel = '메시지 보내기',
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;

  final String hintText;
  final String sendButtonSemanticLabel;
  final bool enabled;

  final ValueChanged<String> onSend;

  @override
  State<AppCommentInput> createState() => _AppCommentInputState();
}

class _AppCommentInputState extends State<AppCommentInput> {
  static const double _minimumHeight = 44;
  static const double _maximumHeight = 128;
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
  void didUpdateWidget(covariant AppCommentInput oldWidget) {
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

  void _sendComment() {
    if (!_canSend) {
      return;
    }

    final comment = widget.controller.text.trim();

    widget.onSend(comment);
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
        ? const Color(0xFF333333)
        : colors.onSurface.withAlpha(31);

    final sendIconColor = _canSend
        ? Colors
              .white // 다크 테마 대응 시 colors.surface 사용 권장
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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x16,
            vertical: AppSpacing.x8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: inputBackgroundColor,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x16,
                      vertical: AppSpacing.x4,
                    ),
                    child: TextField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      enabled: widget.enabled,

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
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              Semantics(
                button: true,
                enabled: _canSend,
                label: widget.sendButtonSemanticLabel,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: _sendButtonSize,
                  height: _sendButtonSize,
                  margin: const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    color: sendButtonColor,
                    shape: BoxShape.circle,
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: _canSend ? _sendComment : null,
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
    );
  }
}
