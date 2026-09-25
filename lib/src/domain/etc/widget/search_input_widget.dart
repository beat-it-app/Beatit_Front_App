import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class SearchInputWidget extends StatelessWidget {
  const SearchInputWidget({
    super.key,
    required this.controller,
    required this.onSearchPressed,
    this.hintText = '검색어를 입력하세요.',
    this.focusNode,
    this.onChanged,
  });

  final TextEditingController controller;
  final VoidCallback onSearchPressed;
  final String hintText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      height: 45,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      suffixIcon: Semantics(
        button: true,
        label: '검색',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onSearchPressed,
          child: SvgPicture.asset(
            'assets/icons/etc/search.svg',
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
