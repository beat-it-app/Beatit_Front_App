import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/etc/widget/music_result_widget.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MusicSearchPage extends StatefulWidget {
  const MusicSearchPage({super.key});

  @override
  State<MusicSearchPage> createState() => _MusicSearchPageState();
}

class _MusicSearchPageState extends State<MusicSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<_MockMusicResult> _searchResults = const [];

  static const List<_MockMusicResult> _mockMusicResults = [
    _MockMusicResult(
      musicTitle: 'WISH',
      artist: 'nct wish',
      imageUrl:
          'https://image.utoimage.com/preview/cp872722/2022/12/202212008462_500.jpg',
    ),
    _MockMusicResult(
      musicTitle: 'Color',
      artist: 'nct wish',
      imageUrl:
          'https://image.utoimage.com/preview/cp872722/2022/12/202212008462_500.jpg',
    ),
    _MockMusicResult(
      musicTitle: '고양이 릴스',
      artist: 'nct wish',
      imageUrl:
          'https://image.utoimage.com/preview/cp872722/2022/12/202212008462_500.jpg',
    ),
    _MockMusicResult(
      musicTitle: 'Songbird',
      artist: 'nct wish',
      imageUrl:
          'https://image.utoimage.com/preview/cp872722/2022/12/202212008462_500.jpg',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    FocusScope.of(context).unfocus();

    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _searchResults = const [];
        return;
      }

      _searchResults = _mockMusicResults.where((music) {
        final title = music.musicTitle.toLowerCase();
        final artist = music.artist.toLowerCase();

        return title.contains(query) || artist.contains(query);
      }).toList();
    });
  }

  void _handleSearchChanged(String value) {
    if (value.trim().isNotEmpty) {
      return;
    }

    setState(() {
      _searchResults = const [];
    });
  }

  void _handleMusicTap(_MockMusicResult music) {
    // TODO: API 연동 시 선택한 음악 처리
  }

  @override
  Widget build(BuildContext context) {
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
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final music = _searchResults[index];

                    return MusicResultWidget(
                      musicTitle: music.musicTitle,
                      artist: music.artist,
                      imageUrl: music.imageUrl,
                      onTap: () => _handleMusicTap(music),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockMusicResult {
  const _MockMusicResult({
    required this.musicTitle,
    required this.artist,
    required this.imageUrl,
  });

  final String musicTitle;
  final String artist;
  final String imageUrl;
}
