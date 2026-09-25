import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/etc/widget/location_reference_widget.dart';
import 'package:beatit_front_app/src/domain/etc/widget/location_result_widget.dart';
import 'package:beatit_front_app/src/domain/etc/widget/music_result_widget.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  final _searchController = TextEditingController();
  final _referenceController = TextEditingController();

  bool _isReferenceInputVisible = false;
  bool _showSearchResult = false;

  @override
  void dispose() {
    _searchController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    FocusScope.of(context).unfocus();

    setState(() {
      _showSearchResult = _searchController.text.trim().isNotEmpty;
    });
  }

  void _handleAddReference() {
    setState(() {
      _isReferenceInputVisible = true;
    });
  }

  void _handleDeleteReference() {
    _referenceController.clear();

    setState(() {
      _isReferenceInputVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.x20),
              Row(
                children: [
                  Expanded(
                    child: SearchInputWidget(
                      controller: _searchController,
                      onSearchPressed: _handleSearch,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x12),
                  Semantics(
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
                ],
              ),
              const SizedBox(height: AppSpacing.x8),
              LocationReferenceWidget(
                isInputVisible: _isReferenceInputVisible,
                controller: _referenceController,
                onAddPressed: _handleAddReference,
                onDeletePressed: _handleDeleteReference,
              ),
              if (_showSearchResult)
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: const [
                      LocationResultWidget(
                        name: '그라운드합주실 본점 A3',
                        distance: '250m',
                        address: '서울특별시 마포구 양화로 147 지하 2층',
                      ),
                    ],
                  ),
                )
              else
                const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
