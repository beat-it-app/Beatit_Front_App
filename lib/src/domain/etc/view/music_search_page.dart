import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/etc/provider/music_search_provider.dart';
import 'package:beatit_front_app/src/domain/etc/widget/music_result_widget.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MusicSearchPage extends ConsumerStatefulWidget {
  const MusicSearchPage({super.key});

  @override
  ConsumerState<MusicSearchPage> createState() => _MusicSearchPageState();
}

class _MusicSearchPageState extends ConsumerState<MusicSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    FocusScope.of(context).unfocus();
    await ref.read(musicSearchProvider.notifier).search(_searchController.text);
  }

  void _handleSearchChanged(String value) {
    if (value.trim().isEmpty) {
      ref.read(musicSearchProvider.notifier).clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(musicSearchProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchInputWidget(
                      controller: _searchController,
                      onSearchPressed: _handleSearch,
                      onChanged: _handleSearchChanged,
                      hintText: '어떤 음원을 선택하고 싶나요?',
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
              Expanded(
                child: _buildSearchContent(searchState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchContent(MusicSearchState searchState) {
    if (searchState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchState.errorMessage != null) {
      return Center(
        child: Text(
          searchState.errorMessage!,
          textAlign: TextAlign.center,
          style: FontStyles.med14.copyWith(color: context.grays.gray5),
        ),
      );
    }

    if (searchState.results.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: searchState.results.length,
      itemBuilder: (context, index) {
        final music = searchState.results[index];

        return MusicResultWidget(
          musicTitle: music.title,
          artist: music.artist,
          imageUrl: music.imageUrl ?? '',
          isSelected: identical(searchState.selectedMusic, music),
          onTap: () => ref
              .read(musicSearchProvider.notifier)
              .selectMusic(music),
        );
      },
    );
  }
}
