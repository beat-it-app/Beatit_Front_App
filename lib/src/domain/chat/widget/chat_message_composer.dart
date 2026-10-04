import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';

class ChatMessageComposer extends StatefulWidget {
  const ChatMessageComposer({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onFilePressed,
    required this.onMediaPressed,
    this.hintText = '대화 시작하기',
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSend;
  final VoidCallback onFilePressed;
  final VoidCallback onMediaPressed;
  final String hintText;
  final bool enabled;

  @override
  State<ChatMessageComposer> createState() => _ChatMessageComposerState();
}

class _ChatMessageComposerState extends State<ChatMessageComposer> {
  bool get _canSend =>
      widget.enabled && widget.controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(covariant ChatMessageComposer oldWidget) {
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
    if (mounted) setState(() {});
  }

  void _send() {
    if (!_canSend) return;
    widget.onSend(widget.controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;
    final inputBackground =
        inputTheme.fillColor ?? colors.surfaceContainerHighest;
    final hintColor = inputTheme.hintStyle?.color ?? colors.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44, maxHeight: 120),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: inputBackground,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  5.0,
                  AppSpacing.x4,
                  AppSpacing.x12,
                  AppSpacing.x4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppDropdownList(
                      width: 156,
                      alignmentOffset: const Offset(0, 8),
                      showPressedCheck: false,
                      items: [
                        AppDropdownItem(
                          label: '파일',
                          onPressed: widget.onFilePressed,
                          svgLink: 'assets/icons/chat/folder.svg',
                        ),
                        AppDropdownItem(
                          label: '이미지/영상',
                          onPressed: widget.onMediaPressed,
                          svgLink: 'assets/icons/chat/picture.svg',
                        ),
                      ],
                      triggerBuilder: (context, menuController) {
                        return SizedBox(
                          width: 36,
                          height: 36,
                          child: Material(
                            color: colors.surface,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: widget.enabled
                                  ? menuController.open
                                  : null,
                              child: Icon(
                                Icons.add,
                                color: colors.onSurfaceVariant,
                                size: AppSpacing.x24,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: AppSpacing.x8),
                    Expanded(
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
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x8),
        _SendButton(enabled: _canSend, onPressed: _send),
      ],
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      enabled: enabled,
      label: '메시지 보내기',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled ? colors.primary : colors.onSurface.withAlpha(31),
          shape: BoxShape.circle,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            customBorder: const CircleBorder(),
            child: Icon(
              Icons.arrow_upward_rounded,
              size: 26,
              color: enabled
                  ? colors.onPrimary
                  : colors.onSurface.withAlpha(71),
            ),
          ),
        ),
      ),
    );
  }
}
