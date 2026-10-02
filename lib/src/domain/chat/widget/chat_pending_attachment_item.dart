import 'dart:io';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_message_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatPendingAttachmentItem extends StatelessWidget {
  const ChatPendingAttachmentItem({
    super.key,
    required this.attachment,
    required this.onRetry,
    required this.onDelete,
  });

  final ChatPendingAttachment attachment;
  final VoidCallback onRetry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isFailed =
        attachment.status == ChatPendingAttachmentStatus.failed;

    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (attachment.messageType == ChatMessageType.image)
            _PendingImage(attachment: attachment)
          else
            _PendingFileCard(attachment: attachment),
          const SizedBox(height: AppSpacing.x8),
          if (isFailed)
            _FailedActions(onRetry: onRetry, onDelete: onDelete)
          else
            SizedBox(
              width: 280,
              child: Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: attachment.progress.clamp(0.0, 1.0).toDouble(),
                      minHeight: 3,
                      backgroundColor: context.grays.gray7,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  Text(
                    '${(attachment.progress * 100).round()}%',
                    style: FontStyles.med11.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PendingImage extends StatelessWidget {
  const _PendingImage({required this.attachment});

  final ChatPendingAttachment attachment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        width: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.file(
              File(attachment.filePath),
              width: 280,
              fit: BoxFit.fitWidth,
              errorBuilder: (_, __, ___) => Container(
                width: 280,
                height: 160,
                alignment: Alignment.center,
                color: context.grays.gray8,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: context.grays.gray5,
                ),
              ),
            ),
            if (attachment.status == ChatPendingAttachmentStatus.uploading)
              Positioned.fill(
                child: ColoredBox(
                  color: Theme.of(context)
                      .colorScheme
                      .scrim
                      .withValues(alpha: 0.28),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: attachment.progress > 0
                          ? attachment.progress.clamp(0.0, 1.0).toDouble()
                          : null,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PendingFileCard extends StatelessWidget {
  const _PendingFileCard({required this.attachment});

  final ChatPendingAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final local = attachment.createdAt.toLocal();
    final dateLabel =
        '${local.year}.${local.month.toString().padLeft(2, '0')}.${local.day.toString().padLeft(2, '0')}';

    return Container(
      width: 280,
      constraints: const BoxConstraints(minHeight: 80),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x12,
        vertical: AppSpacing.x10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: context.grays.gray7),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            attachment.messageType == ChatMessageType.video
                ? 'assets/icons/cloud/video.svg'
                : 'assets/icons/cloud/file.svg',
            width: 22,
            height: 22,
          ),
          const SizedBox(width: AppSpacing.x10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        attachment.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyles.med14.copyWith(
                          color: context.grays.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x4),
                    Text(
                      '(${_formatBytes(attachment.fileSizeBytes)})',
                      style: FontStyles.med12.copyWith(
                        color: context.grays.gray5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  dateLabel,
                  style: FontStyles.med11.copyWith(
                    color: context.grays.gray5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    const kb = 1024;
    const mb = 1024 * 1024;
    if (bytes >= mb) return '${(bytes / mb).toStringAsFixed(1)}MB';
    if (bytes >= kb) return '${(bytes / kb).toStringAsFixed(1)}KB';
    return '${bytes}B';
  }
}

class _FailedActions extends StatelessWidget {
  const _FailedActions({required this.onRetry, required this.onDelete});

  final VoidCallback onRetry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: 16, color: colors.error),
        const SizedBox(width: AppSpacing.x4),
        Text(
          '전송 실패',
          style: FontStyles.med12.copyWith(color: colors.error),
        ),
        const SizedBox(width: AppSpacing.x8),
        TextButton(onPressed: onRetry, child: const Text('다시 보내기')),
        TextButton(onPressed: onDelete, child: const Text('삭제')),
      ],
    );
  }
}
