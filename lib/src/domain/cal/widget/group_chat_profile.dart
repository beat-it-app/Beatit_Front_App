import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

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
    int count = imageUrls.length;
    final colors = Theme.of(context).colorScheme;

    if (count == 0) return _buildEmpty();
    if (count == 1) return _buildOne(imageUrls[0]);
    if (count == 2) return _buildTwo();
    if (count == 3) return _buildThree();

    // 4명 이상일 때는 앞에서부터 4개만 잘라서 사용
    return _buildFourOrMore(imageUrls.take(4).toList());
  }

  Widget _buildEmpty() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildOne(String url) {
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(backgroundImage: NetworkImage(url)),
    );
  }

  Widget _buildTwo() {
    final double itemSize = size * 0.65; // 각 이미지 크기를 전체의 65% 정도로 설정
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: _circleImage(imageUrls[0], itemSize),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _circleImage(imageUrls[1], itemSize),
          ),
        ],
      ),
    );
  }

  Widget _buildThree() {
    final double itemSize = size * 0.55;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // 왼쪽 아래
          Positioned(
            bottom: 0,
            left: 0,
            child: _circleImage(imageUrls[1], itemSize),
          ),
          // 오른쪽 아래
          Positioned(
            bottom: 0,
            right: 0,
            child: _circleImage(imageUrls[2], itemSize),
          ),
          // 위쪽 가운데 (제일 위에 덮임)
          Positioned(
            top: 0,
            left: (size - itemSize) / 2, // 가로 중앙 정렬
            child: _circleImage(imageUrls[0], itemSize),
          ),
        ],
      ),
    );
  }

  Widget _buildFourOrMore(List<String> urls) {
    final double itemSize = size * 0.48; // 2x2이므로 절반보다 약간 작게 설정하여 틈(여백)을 줌

    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleImage(urls[0], itemSize),
              _circleImage(urls[1], itemSize),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleImage(urls[2], itemSize),
              _circleImage(urls[3], itemSize),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleImage(String url, double imageSize) {
    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5), // 겹칠 때 경계선 역할
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}
