import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';

class ChatImageMessage extends StatelessWidget {
  const ChatImageMessage({
    super.key,
    required this.imageUrl,
    this.onTap,
  });

  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Image.network(
        imageUrl,
        width: 240,
        height: 180,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: 240,
            height: 180,
            child: Center(
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes == null
                    ? null
                    : progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!,
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          width: 240,
          height: 180,
          alignment: Alignment.center,
          color: context.grays.gray8,
          child: Icon(
            Icons.broken_image_outlined,
            color: context.grays.gray5,
          ),
        ),
      ),
    );

    if (onTap == null) return image;
    return GestureDetector(onTap: onTap, child: image);
  }
}
