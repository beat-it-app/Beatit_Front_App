import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchInputWidget extends StatefulWidget {
  const SearchInputWidget({
    super.key,
    required this.controller,
    required this.onSearchPressed,
    this.hintText = '검색어를 입력하세요.',
    this.focusNode,
    this.onChanged,
    this.showSearchIcon = true,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final VoidCallback onSearchPressed;
  final String hintText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final bool showSearchIcon;
  final Widget? suffixIcon;

  @override
  State<SearchInputWidget> createState() => _SearchInputWidgetState();
}

class _SearchInputWidgetState extends State<SearchInputWidget> {
  late final FocusNode _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant SearchInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)
          .removeListener(_handleFocusChanged);
      _focusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _internalFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _submitSearch(String _) {
    widget.onSearchPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

    final suffix = widget.suffixIcon ??
        (widget.showSearchIcon
            ? Semantics(
                button: true,
                label: '검색',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onSearchPressed,
                  child: SvgPicture.asset(
                    'assets/icons/etc/search.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              )
            : null);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
      decoration: BoxDecoration(
        color: inputTheme.fillColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: _focusNode.hasFocus ? colors.secondary : Colors.transparent,
          width: _focusNode.hasFocus ? 1 : 0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: _submitSearch,
                  cursorColor: colors.primary,
                  style: FontStyles.reg18.copyWith(
                    color: colors.onSurface,
                    height: 1.0,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    filled: false,
                    fillColor: Colors.transparent,
                    hintText: widget.hintText,
                    hintStyle: FontStyles.reg18.copyWith(
                      color: inputTheme.hintStyle?.color ??
                          colors.onSurfaceVariant,
                      height: 1.0,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ),
          ),
          if (suffix != null) ...[
            const SizedBox(width: AppSpacing.x8),
            IconTheme(
              data: IconThemeData(
                color: inputTheme.suffixIconColor,
                size: 20,
              ),
              child: suffix,
            ),
          ],
        ],
      ),
    );
  }
}
