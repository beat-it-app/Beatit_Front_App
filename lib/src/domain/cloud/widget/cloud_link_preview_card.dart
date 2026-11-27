import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudLinkPreviewCard extends StatelessWidget {
  const CloudLinkPreviewCard({
    super.key,
    required this.title,
    required this.domain,
    this.imageUri,
    this.onPressed,
  });

  final String title;
  final String domain;
  final Uri? imageUri;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final content = Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: context.grays.gray8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _CloudLinkPreviewThumbnail(imageUri: imageUri),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.x20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.reg18.copyWith(color: context.grays.black),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        domain,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyles.reg16.copyWith(
                          color: context.grays.gray5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onPressed == null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        clipBehavior: Clip.antiAlias,
        child: content,
      );
    }

    return Semantics(
      button: true,
      label: '$title 링크 열기',
      child: Material(
        color: context.grays.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onPressed, child: content),
      ),
    );
  }
}

class _CloudLinkPreviewThumbnail extends StatelessWidget {
  const _CloudLinkPreviewThumbnail({required this.imageUri});

  final Uri? imageUri;

  @override
  Widget build(BuildContext context) {
    final uri = imageUri;

    if (uri == null) {
      return const _CloudLinkPreviewThumbnailFallback();
    }

    return Image.network(
      uri.toString(),
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const _CloudLinkPreviewThumbnailFallback(showLoading: true);
      },
      errorBuilder: (context, error, stackTrace) {
        return const _CloudLinkPreviewThumbnailFallback();
      },
    );
  }
}

class _CloudLinkPreviewThumbnailFallback extends StatelessWidget {
  const _CloudLinkPreviewThumbnailFallback({this.showLoading = false});

  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.grays.gray8,
      child: Center(
        child: showLoading
            ? const CircularProgressIndicator()
            : SvgPicture.asset(
                'assets/icons/cloud/link.svg',
                width: 24.0,
                height: 24.0,
                colorFilter: ColorFilter.mode(
                  context.grays.gray4,
                  BlendMode.srcIn,
                ),
              ),
      ),
    );
  }
}
