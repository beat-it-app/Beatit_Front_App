import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_message_models.dart';
import 'package:beatit_front_app/src/domain/chat/widget/chat_attachment_message_card.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_appbar.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_preview_background.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';

class ChatImagePreviewPage extends StatefulWidget {
  const ChatImagePreviewPage({
    super.key,
    required this.images,
    required this.initialMessageId,
    this.onDownloadPressed,
  });

  final List<ChatMessage> images;
  final int initialMessageId;
  final ValueChanged<ChatMessage>? onDownloadPressed;

  @override
  State<ChatImagePreviewPage> createState() => _ChatImagePreviewPageState();
}

class _ChatImagePreviewPageState extends State<ChatImagePreviewPage> {
  late int _currentIndex = _initialIndex();
  late final PageController _pageController = PageController(
    initialPage: _currentIndex,
  );

  int _initialIndex() {
    final index = widget.images.indexWhere(
      (message) => message.messageId == widget.initialMessageId,
    );
    return index < 0 ? 0 : index;
  }

  ChatMessage get _current => widget.images[_currentIndex];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: CloudFileAppbar(
        titleText: ChatAttachmentMessageCard.resolveFileName(_current),
      ),
      body: CloudPreviewBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final message = widget.images[index];
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5,
                  child: Center(
                    child: Image.network(
                      message.content,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) =>
                          progress == null
                          ? child
                          : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: context.grays.gray5,
                      ),
                    ),
                  ),
                );
              },
            ),
            if (widget.onDownloadPressed != null)
              Positioned(
                left: AppSpacing.x16,
                bottom: AppSpacing.x16 + MediaQuery.paddingOf(context).bottom,
                child: CloudSelectionFloatingBar(
                  showDelete: false,
                  showMove: false,
                  showDownload: true,
                  onDeletePressed: () {},
                  onMovePressed: () {},
                  onDownloadPressed: () =>
                      widget.onDownloadPressed?.call(_current),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
