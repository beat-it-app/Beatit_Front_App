// lib/src/domain/performance/view/performance_main_page.dart

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/toggles/app_toggle.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_input_widget.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_model.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_information_page.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_detail_page.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_mine_page.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_item_widget.dart';

enum _PerformanceFilter {
  all('ALL'),
  upcoming('UPCOMING'),
  past('PAST');

  final String apiValue;

  const _PerformanceFilter(this.apiValue);
}

class PerformanceMainPage extends ConsumerStatefulWidget {
  const PerformanceMainPage({super.key, this.onPerformanceTap});

  final ValueChanged<PerformanceModel>? onPerformanceTap;

  @override
  ConsumerState<PerformanceMainPage> createState() =>
      _PerformanceMainPageState();
}

class _PerformanceMainPageState extends ConsumerState<PerformanceMainPage> {
  final _searchController = TextEditingController();
  _PerformanceFilter _filter = _PerformanceFilter.all;
  String _query = '';
  Timer? _debounce;

  bool _isLoading = false;
  String? _errorMessage;
  List<PerformanceModel> _performances = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPerformances();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  /// 백엔드 API (GET /performances) 호출
  Future<void> _fetchPerformances() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get(
        '/performances',
        queryParameters: {
          'filter': _filter.apiValue,
          if (_query.trim().isNotEmpty) 'keyword': _query.trim(),
          'page': 0,
          'size': 30,
        },
      );

      final resData = response.data;
      if (resData is Map<String, dynamic> && resData['data'] != null) {
        final parsedResponse = PerformanceResponseModel.fromJson(
          resData['data'] as Map<String, dynamic>,
        );

        final List<PerformanceModel> items = switch (_filter) {
          _PerformanceFilter.all => parsedResponse.allItems,
          _PerformanceFilter.upcoming => parsedResponse.upcoming,
          _PerformanceFilter.past => parsedResponse.past,
        };

        if (mounted) {
          setState(() {
            _performances = items;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _performances = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String value) {
    _query = value;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _fetchPerformances();
    });
  }

  void _onFilterChanged(_PerformanceFilter filter) {
    if (_filter == filter) return;
    setState(() {
      _filter = filter;
    });
    _fetchPerformances();
  }

  void _openCreatePage() {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => const PerformanceInformationPage(),
          ),
        )
        .then((_) {
          _fetchPerformances();
        });
  }

  /// 💡 '내 공연 보기' 페이지로 이동
  void _openMinePage() {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(builder: (_) => const PerformanceMinePage()),
        )
        .then((_) {
          // 내 공연 페이지에서 수정/삭제 후 돌아왔을 때 메인 목록 갱신
          _fetchPerformances();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: AppTopAppBar.backMore(
        onBackPressed: () => Navigator.of(context).maybePop(),
        actionIconColor: context.grays.black,
        moreMenuOffset: const Offset(-16, 56),
        moreMenuItems: [
          AppDropdownItem(
            label: '내 공연 보기',
            onPressed: _openMinePage, // 💡 PerformanceMinePage로 이동
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // 1. 검색 입력창
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: SearchInputWidget(
                controller: _searchController,
                onSearchPressed: () => FocusScope.of(context).unfocus(),
                onChanged: _onSearchChanged,
              ),
            ),
            const SizedBox(height: AppSpacing.x10),

            // 2. 필터 토글 버튼 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: AppSpacing.x8,
                children: [
                  _filterToggle('전체 보기', _PerformanceFilter.all),
                  _filterToggle('진행 예정 공연', _PerformanceFilter.upcoming),
                  _filterToggle('지난 공연', _PerformanceFilter.past),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x16),

            // 3. 공연 그리드 목록 영역
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '공연 목록을 불러오지 못했습니다.',
                            style: FontStyles.med14.copyWith(
                              color: context.colors.error,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _fetchPerformances,
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    )
                  : _performances.isEmpty
                  ? Center(
                      child: Text(
                        '조건에 맞는 공연이 없습니다.',
                        style: FontStyles.med14.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    )
                  : PerformanceGrid(
                      performances: _performances,
                      showPastLabel: _filter == _PerformanceFilter.all,
                      onTap: (item) {
                        if (widget.onPerformanceTap != null) {
                          widget.onPerformanceTap!(item);
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => PerformanceDetailPage(
                              performancePublicId: item.performancePublicId,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // 4. 하단 공연 등록 플로팅 버튼
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 155,
        height: 50,
        child: OutlinedButton(
          onPressed: _openCreatePage,
          style: OutlinedButton.styleFrom(
            backgroundColor: context.grays.white,
            foregroundColor: context.colors.onSurface,
            side: BorderSide(color: context.grays.gray7),
            shape: const StadiumBorder(),
            textStyle: FontStyles.med16.copyWith(color: context.grays.gray3),
          ),
          child: const Text('공연 등록하기'),
        ),
      ),
    );
  }

  Widget _filterToggle(String label, _PerformanceFilter filter) => AppToggle(
    text: label,
    isSelected: _filter == filter,
    onChanged: (_) => _onFilterChanged(filter),
  );
}
