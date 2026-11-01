import 'dart:io';

import 'package:flutter/material.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_room_provider.dart';

/// 여러 사진을 하나의 업로드 중 채팅 카드로 표시합니다.
/// 서버에는 사진별 메시지가 전송되지만, 완료 전에는 분리된 로딩 카드를 보여주지 않습니다.
class ChatPendingImageBatchItem extends StatelessWidget {
  const ChatPendingImageBatchItem({
    super.key,
    required this.batch,
    required this.onRetry,
    required this.onDismiss,
  });

  final ChatImageUploadBatch batch;
  final VoidCallback onRetry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final columns = batch.files.length <= 4 ? 2 : 3;
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: SizedBox(
              width: 245,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: AppSpacing.x4,
                  crossAxisSpacing: AppSpacing.x4,
                ),
                itemCount: batch.files.length,
                itemBuilder: (context, index) {
                  final file = batch.files[index];
                  final done = file.messageId != null;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(file.path),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.broken_image_outlined,
                          color: context.grays.gray5,
                        ),
                      ),
                      if (!done)
                        ColoredBox(
                          color: Theme.of(context)
                              .colorScheme.scrim.withValues(alpha: 0.26),
                          child: Center(
                            child: file.progress > 0
                                ? CircularProgressIndicator(value: file.progress)
                                : Icon(Icons.cloud_upload_outlined,
                                    color: context.grays.white),
                          ),
                        ),
                      if (done)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.x4),
                            child: Icon(Icons.check_circle,
                                color: context.grays.white, size: 18),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x8),
          Text(
            '${batch.completedCount}/${batch.files.length}장 전송 완료',
            style: FontStyles.med11.copyWith(color: context.grays.gray5),
          ),
          if (!batch.isUploading) ...[
            const SizedBox(height: AppSpacing.x8),
            Text(batch.errorMessage ?? '일부 사진 전송 실패',
                style: FontStyles.med12.copyWith(
                    color: Theme.of(context).colorScheme.error)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(onPressed: onRetry, child: const Text('재시도')),
                TextButton(onPressed: onDismiss, child: const Text('닫기')),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
