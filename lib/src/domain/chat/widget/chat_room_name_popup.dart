import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';

Future<String?> showChatRoomNamePopup(
  BuildContext context, {
  required String initialName,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => ChatRoomNamePopup(initialName: initialName),
  );
}

class ChatRoomNamePopup extends StatefulWidget {
  const ChatRoomNamePopup({super.key, required this.initialName});

  final String initialName;

  @override
  State<ChatRoomNamePopup> createState() => _ChatRoomNamePopupState();
}

class _ChatRoomNamePopupState extends State<ChatRoomNamePopup> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName,
  );

  bool get _canSubmit => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  void _submit() {
    if (!_canSubmit) return;
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 310),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x16),
                child: Text(
                  '이름 수정하기',
                  textAlign: TextAlign.center,
                  style: FontStyles.bold22.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x8),
              Container(
                constraints: const BoxConstraints(minHeight: 45),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x10),
                decoration: BoxDecoration(
                  color: context.grays.gray8,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLines: 1,
                  cursorColor: Theme.of(context).colorScheme.primary,
                  style: FontStyles.reg18.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(height: AppSpacing.x40),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: '취소',
                      variant: ButtonVariant.gray,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  Expanded(
                    child: AppButton(
                      text: '확인',
                      onPressed: _canSubmit ? _submit : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
