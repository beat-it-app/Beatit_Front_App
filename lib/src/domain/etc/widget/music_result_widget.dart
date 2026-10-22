import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class MusicResultWidget extends StatefulWidget {
  const MusicResultWidget({
    super.key,
    required this.musicTitle,
    required this.artist,
    required this.imageUrl,
    this.isSelected = false,
    this.onTap,
  });

  final String musicTitle;
  final String artist;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  State<MusicResultWidget> createState() => _MusicResultWidgetState();
}

class _MusicResultWidgetState extends State<MusicResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.isSelected ? context.grays.gray8 : Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: widget.imageUrl.trim().isEmpty
                    ? _MusicImageFallback()
                    : Image.network(
                        widget.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const _MusicImageFallback();
                        },
                      ),
              ),
              const SizedBox(width: AppSpacing.x12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.musicTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.med20.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      widget.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.med16.copyWith(
                        color: context.grays.gray5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MusicImageFallback extends StatelessWidget {
  const _MusicImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      color: context.grays.gray7,
      alignment: Alignment.center,
      child: Icon(Icons.music_note, color: context.grays.gray5),
    );
  }
}
