import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_message_models.dart';

enum ChatAttachmentKind { image, video, audio, document, file }

class ChatAttachmentMessageCard extends StatelessWidget {
  const ChatAttachmentMessageCard({
    super.key,
    required this.message,
    this.onTap,
  });

  final ChatMessage message;
  final VoidCallback? onTap;

  static const Set<String> imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'heic',
  };

  static const Set<String> videoExtensions = {'mp4', 'mov', 'avi'};

  static const Set<String> audioExtensions = {
    'mp3',
    'wav',
    'm4a',
    'aac',
    'ogg',
    'flac',
  };

  static String resolveFileName(ChatMessage message) {
    final localName = message.attachmentName?.trim();
    if (localName != null && localName.isNotEmpty) return localName;

    final uri = Uri.tryParse(message.content);
    final rawName = uri == null || uri.pathSegments.isEmpty
        ? message.content
        : Uri.decodeComponent(uri.pathSegments.last);

    final uuidPrefix = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}_(.+)$',
    );
    final match = uuidPrefix.firstMatch(rawName);
    return match?.group(1) ?? rawName;
  }

  static String extensionOf(String fileName) {
    final index = fileName.lastIndexOf('.');
    if (index < 0 || index == fileName.length - 1) return '';
    return fileName.substring(index + 1).toLowerCase();
  }

  static String baseNameOf(String fileName) {
    final index = fileName.lastIndexOf('.');
    if (index <= 0 || index == fileName.length - 1) return fileName;
    return fileName.substring(0, index);
  }

  static String visibleExtensionOf(String fileName) {
    final extension = extensionOf(fileName);
    return extension.isEmpty ? '' : '.$extension';
  }

  static ChatAttachmentKind kindFor({
    required ChatMessageType messageType,
    required String fileName,
  }) {
    final extension = extensionOf(fileName);

    if (messageType == ChatMessageType.image) {
      return ChatAttachmentKind.image;
    }
    if (messageType == ChatMessageType.video) {
      return ChatAttachmentKind.video;
    }
    if (imageExtensions.contains(extension)) {
      return ChatAttachmentKind.image;
    }
    if (videoExtensions.contains(extension)) {
      return ChatAttachmentKind.video;
    }
    if (audioExtensions.contains(extension)) {
      return ChatAttachmentKind.audio;
    }
    if (extension == 'pdf') {
      return ChatAttachmentKind.document;
    }
    return ChatAttachmentKind.file;
  }

  static String? formatFileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return null;
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  static String iconPathFor(ChatMessage message) {
    return iconPathForValues(
      messageType: message.messageType,
      fileName: resolveFileName(message),
    );
  }

  static String iconPathForValues({
    required ChatMessageType messageType,
    required String fileName,
  }) {
    return switch (kindFor(messageType: messageType, fileName: fileName)) {
      ChatAttachmentKind.video => 'assets/icons/cloud/video.svg',
      ChatAttachmentKind.audio => 'assets/icons/cloud/music_simbol.svg',
      _ => 'assets/icons/cloud/file.svg',
    };
  }

  @override
  Widget build(BuildContext context) {
    final fileName = resolveFileName(message);
    final sizeLabel = formatFileSize(message.attachmentSizeBytes);
    final local = message.createdAt.toLocal();
    final dateLabel =
        '${local.year}.${local.month.toString().padLeft(2, '0')}.${local.day.toString().padLeft(2, '0')}';

    final content = Container(
      width: 280,
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x10,
      ),
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          _AttachmentIcon(path: iconPathFor(message)),
          const SizedBox(width: AppSpacing.x16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _AttachmentNameAndSize(
                  fileName: fileName,
                  sizeLabel: sizeLabel,
                ),
                const SizedBox(height: 2),
                _AttachmentDate(dateLabel: dateLabel),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: content,
      ),
    );
  }
}

class _AttachmentIcon extends StatelessWidget {
  const _AttachmentIcon({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(path, width: 22, height: 22);
  }
}

class _AttachmentNameAndSize extends StatelessWidget {
  const _AttachmentNameAndSize({
    required this.fileName,
    required this.sizeLabel,
  });

  final String fileName;
  final String? sizeLabel;

  @override
  Widget build(BuildContext context) {
    final baseName = ChatAttachmentMessageCard.baseNameOf(fileName);
    final extension = ChatAttachmentMessageCard.visibleExtensionOf(fileName);

    return Row(
      children: [
        Flexible(
          child: Text(
            baseName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FontStyles.med16.copyWith(color: context.grays.black),
          ),
        ),
        if (extension.isNotEmpty)
          Text(
            extension,
            style: FontStyles.med16.copyWith(color: context.grays.black),
          ),
        if (sizeLabel != null) ...[
          const SizedBox(width: AppSpacing.x4),
          Text(
            '($sizeLabel)',
            style: FontStyles.med16.copyWith(color: context.grays.gray4),
          ),
        ],
      ],
    );
  }
}

class _AttachmentDate extends StatelessWidget {
  const _AttachmentDate({required this.dateLabel});

  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Text(
      dateLabel,
      style: FontStyles.med14.copyWith(color: context.grays.gray5),
    );
  }
}
