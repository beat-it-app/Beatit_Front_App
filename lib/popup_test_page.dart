import 'package:flutter/material.dart';

class GroupChatProfile extends StatelessWidget {
  const GroupChatProfile({
    super.key,
    required this.imageUrls,
    this.size = 47.0,
  });

  final List<String> imageUrls;
  final double size;

  @override
  Widget build(BuildContext context) {
    // 빈 URL은 제외하고 최대 4개까지만 표시
    final urls = imageUrls
        .where((url) => url.trim().isNotEmpty)
        .take(4)
        .toList(growable: false);

    if (urls.isEmpty) {
      return _buildEmpty(context);
    }

    if (urls.length == 1) {
      return _buildOne(context, urls[0]);
    }

    if (urls.length == 2) {
      return _buildTwo(context, urls);
    }

    if (urls.length == 3) {
      return _buildThree(context, urls);
    }

    return _buildFourOrMore(context, urls);
  }

  Widget _buildEmpty(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.surfaceContainerHighest,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildOne(BuildContext context, String url) {
    return SizedBox(
      width: size,
      height: size,
      child: _circleImage(context: context, url: url, imageSize: size),
    );
  }

  Widget _buildTwo(BuildContext context, List<String> urls) {
    // 기존 0.65보다 크게 잡아 두 이미지가 확실하게 겹치도록 설정
    final itemSize = size * 0.72;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 첫 번째 이미지: 왼쪽 위
          Positioned(
            top: 0,
            left: 0,
            child: _circleImage(
              context: context,
              url: urls[0],
              imageSize: itemSize,
            ),
          ),

          // 두 번째 이미지: 오른쪽 아래
          // 나중에 선언되었으므로 첫 번째 이미지 위로 올라옴
          Positioned(
            right: 0,
            bottom: 0,
            child: _circleImage(
              context: context,
              url: urls[1],
              imageSize: itemSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThree(BuildContext context, List<String> urls) {
    final itemSize = size * 0.57;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 오른쪽 아래
          Positioned(
            right: 0,
            bottom: 0,
            child: _circleImage(
              context: context,
              url: urls[2],
              imageSize: itemSize,
            ),
          ),
          // 위쪽 중앙
          Positioned(
            top: 0,
            left: (size - itemSize) / 2,
            child: _circleImage(
              context: context,
              url: urls[0],
              imageSize: itemSize,
            ),
          ),
          // 왼쪽 아래
          Positioned(
            bottom: 0,
            left: 0,
            child: _circleImage(
              context: context,
              url: urls[1],
              imageSize: itemSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFourOrMore(BuildContext context, List<String> urls) {
    // 절반보다 크게 설정해야 네 이미지가 중앙에서 서로 겹침
    final itemSize = size * 0.90;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 왼쪽 위
          Positioned(
            top: 0,
            left: 0,
            child: _circleImage(
              context: context,
              url: urls[0],
              imageSize: itemSize,
            ),
          ),

          // 오른쪽 위
          Positioned(
            top: 0,
            right: 0,
            child: _circleImage(
              context: context,
              url: urls[1],
              imageSize: itemSize,
            ),
          ),

          // 왼쪽 아래
          Positioned(
            bottom: 0,
            left: 0,
            child: _circleImage(
              context: context,
              url: urls[2],
              imageSize: itemSize,
            ),
          ),

          // 오른쪽 아래
          // 마지막에 선언되어 가장 위쪽에 표시됨
          Positioned(
            right: 0,
            bottom: 0,
            child: _circleImage(
              context: context,
              url: urls[3],
              imageSize: itemSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleImage({
    required BuildContext context,
    required String url,
    required double imageSize,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: imageSize,
      height: imageSize,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,

        // 프로필 간 경계선 역할
        color: colorScheme.surface,
      ),
      child: ClipOval(
        child: Image.network(
          url,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                return ColoredBox(
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: imageSize * 0.45,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
        ),
      ),
    );
  }
}
