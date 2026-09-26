import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/etc/api/etc_api_exception.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/location_search_provider.dart';
import 'package:beatit_front_app/src/domain/etc/widget/location_reference_widget.dart';
import 'package:beatit_front_app/src/domain/etc/widget/location_result_widget.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationSearchPage extends ConsumerStatefulWidget {
  const LocationSearchPage({
    super.key,
    this.returnRegisteredLocationOnSelect = false,
  });

  /// 일정 생성처럼 검색 결과를 고르는 즉시 장소를 등록하고 이전 화면으로
  /// 등록 결과를 반환해야 할 때 사용한다. 기본값은 기존 화면 동작을 유지한다.
  final bool returnRegisteredLocationOnSelect;

  @override
  ConsumerState<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends ConsumerState<LocationSearchPage> {
  final _searchController = TextEditingController();
  final _referenceController = TextEditingController();

  bool _isReferenceInputVisible = false;
  bool _isRegisteringLocation = false;

  @override
  void dispose() {
    _searchController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    FocusScope.of(context).unfocus();
    await ref
        .read(locationSearchProvider.notifier)
        .searchLocations(_searchController.text);
  }

  void _handleSearchChanged(String value) {
    if (value.trim().isEmpty) {
      ref.read(locationSearchProvider.notifier).clearSearchResults();
    }
  }

  void _handleAddReference() {
    setState(() {
      _isReferenceInputVisible = true;
    });
  }

  Future<void> _handleReferenceSearch() async {
    FocusScope.of(context).unfocus();
    await ref
        .read(locationSearchProvider.notifier)
        .searchReferenceLocations(_referenceController.text);
  }

  void _handleReferenceChanged(String value) {
    final state = ref.read(locationSearchProvider);
    final selectedReference = state.referenceLocation;

    if (selectedReference != null &&
        value.trim() != selectedReference.locationName) {
      ref.read(locationSearchProvider.notifier).clearReferenceLocation();
      _refreshMainSearchWithoutReferenceIfNeeded();
    }

    if (value.trim().isEmpty) {
      ref.read(locationSearchProvider.notifier).clearReferenceSearchResults();
    }
  }

  void _handleDeleteReference() {
    _referenceController.clear();
    ref.read(locationSearchProvider.notifier).clearReferenceLocation();

    setState(() {
      _isReferenceInputVisible = false;
    });

    _refreshMainSearchWithoutReferenceIfNeeded();
  }

  Future<void> _handleReferenceSelected(LocationSearchResult location) async {
    ref.read(locationSearchProvider.notifier).selectReferenceLocation(location);

    _referenceController.text = location.locationName;
    _referenceController.selection = TextSelection.collapsed(
      offset: _referenceController.text.length,
    );

    final mainQuery = _searchController.text.trim();
    if (mainQuery.isNotEmpty) {
      await ref
          .read(locationSearchProvider.notifier)
          .searchLocations(mainQuery);
    }
  }

  Future<void> _handleLocationSelected(LocationSearchResult location) async {
    if (_isRegisteringLocation) {
      return;
    }

    ref.read(locationSearchProvider.notifier).selectLocation(location);

    if (!widget.returnRegisteredLocationOnSelect) {
      return;
    }

    setState(() {
      _isRegisteringLocation = true;
    });

    try {
      final registered = await ref
          .read(locationSearchProvider.notifier)
          .registerLocation(location);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop<LocationData>(registered);
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = error is EtcApiException
          ? error.message
          : '장소 등록에 실패했습니다.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isRegisteringLocation = false;
        });
      }
    }
  }

  void _refreshMainSearchWithoutReferenceIfNeeded() {
    final mainQuery = _searchController.text.trim();
    if (mainQuery.isEmpty) {
      return;
    }

    ref.read(locationSearchProvider.notifier).searchLocations(mainQuery);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(locationSearchProvider);
    final showReferenceResults =
        searchState.isReferenceLoading ||
        searchState.referenceErrorMessage != null ||
        searchState.referenceResults.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IgnorePointer(
              ignoring: _isRegisteringLocation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SearchInputWidget(
                                controller: _searchController,
                                onSearchPressed: _handleSearch,
                                onChanged: _handleSearchChanged,
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
                        const SizedBox(height: AppSpacing.x4),
                        LocationReferenceWidget(
                          isInputVisible: _isReferenceInputVisible,
                          controller: _referenceController,
                          onAddPressed: _handleAddReference,
                          onSearchPressed: _handleReferenceSearch,
                          onDeletePressed: _handleDeleteReference,
                          onChanged: _handleReferenceChanged,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x10),
                  Expanded(
                    child: showReferenceResults
                        ? _LocationResultList(
                            isLoading: searchState.isReferenceLoading,
                            errorMessage: searchState.referenceErrorMessage,
                            results: searchState.referenceResults,
                            onTap: _handleReferenceSelected,
                          )
                        : _LocationResultList(
                            isLoading: searchState.isLoading,
                            errorMessage: searchState.errorMessage,
                            results: searchState.results,
                            selectedLocation: searchState.selectedLocation,
                            onTap: _handleLocationSelected,
                          ),
                  ),
                ],
              ),
            ),
            if (_isRegisteringLocation)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

class _LocationResultList extends StatelessWidget {
  const _LocationResultList({
    required this.isLoading,
    required this.results,
    required this.onTap,
    this.errorMessage,
    this.selectedLocation,
  });

  final bool isLoading;
  final String? errorMessage;
  final List<LocationSearchResult> results;
  final LocationSearchResult? selectedLocation;
  final ValueChanged<LocationSearchResult> onTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          textAlign: TextAlign.center,
          style: FontStyles.med14.copyWith(color: context.grays.gray5),
        ),
      );
    }

    if (results.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: results.length,
      itemBuilder: (context, index) {
        final location = results[index];

        return LocationResultWidget(
          name: location.locationName,
          address: location.roadAddress,
          distance: location.distance,
          isSelected: identical(selectedLocation, location),
          onTap: () => onTap(location),
        );
      },
    );
  }
}
