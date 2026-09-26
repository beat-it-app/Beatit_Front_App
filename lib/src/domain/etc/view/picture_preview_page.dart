import 'dart:io';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PicturePreviewPage extends StatefulWidget {
  const PicturePreviewPage({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  }) : assert(
         imageUrls.length == 0 ||
             (initialIndex >= 0 && initialIndex < imageUrls.length),
       );

  final List<String> imageUrls;
  final int initialIndex;

  @override
  State<PicturePreviewPage> createState() => _PicturePreviewPageState();
}

class _PicturePreviewPageState extends State<PicturePreviewPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.imageUrls.isEmpty ? 0 : widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void didUpdateWidget(covariant PicturePreviewPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.imageUrls.isEmpty) {
      if (_currentIndex != 0) {
        setState(() {
          _currentIndex = 0;
        });
      }
      return;
    }

    if (_currentIndex >= widget.imageUrls.length) {
      final newIndex = widget.imageUrls.length - 1;

      setState(() {
        _currentIndex = newIndex;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(newIndex);
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.imageUrls.length;
    final currentNumber = totalCount == 0 ? 0 : _currentIndex + 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildCloseButton(context),
            Expanded(
              child: widget.imageUrls.isEmpty
                  ? _buildEmptyState(context)
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: totalCount,
                      onPageChanged: _handlePageChanged,
                      itemBuilder: (context, index) {
                        return _buildImage(
                          context,
                          widget.imageUrls[index],
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x20),
              child: _buildPageIndicator(
                context,
                currentNumber: currentNumber,
                totalCount: totalCount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.x16),
        child: Semantics(
          button: true,
          label: '이전 화면으로 이동',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: SizedBox(
              width: 32,
              height: 54,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/etc/delete.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    context.grays.gray1,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String imageSource) {
    final uri = Uri.tryParse(imageSource);
    final isRemote = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https');
    final isFileUri = uri != null && uri.scheme == 'file';

    final image = isRemote
        ? Image.network(
            imageSource,
            width: double.infinity,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes == null
                      ? null
                      : loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!,
                ),
              );
            },
            errorBuilder: _buildImageError,
          )
        : Image.file(
            File(isFileUri ? uri.toFilePath() : imageSource),
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: _buildImageError,
          );

    return Center(child: image);
  }

  Widget _buildImageError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: 48,
        color: context.grays.gray5,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 48,
        color: context.grays.gray5,
      ),
    );
  }

  Widget _buildPageIndicator(
    BuildContext context, {
    required int currentNumber,
    required int totalCount,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x12,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: context.grays.gray4,
          width: 1,
        ),
      ),
      child: Text(
        '$currentNumber/$totalCount',
        style: FontStyles.reg12.copyWith(
          color: context.grays.gray1,
        ),
      ),
    );
  }
}
