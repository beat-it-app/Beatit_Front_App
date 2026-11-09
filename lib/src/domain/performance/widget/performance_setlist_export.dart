import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 팀별 PNG 저장을 위한 렌더링 전용 위젯.
///
/// 화면에서 보이는 10곡 제한과 관계없이 전달된 songs 전체를 렌더링한다.
/// 아주 긴 목록은 [PerformanceSetlistImageExporter]가 여러 조각으로 나눠
/// 캡처 후 하나의 세로 이미지로 이어 붙인다.
class PerformanceSetlistExport extends StatelessWidget {
  const PerformanceSetlistExport({
    super.key,
    required this.team,
    this.songs,
    this.startIndex = 0,
    this.showHeading = true,
    this.showFooter = true,
  });

  final PerformanceSetlistTeam team;
  final List<PerformanceSetlistSong>? songs;
  final int startIndex;
  final bool showHeading;
  final bool showFooter;

  static const double imageWidth = 450;

  @override
  Widget build(BuildContext context) {
    final exportSongs = songs ?? team.musics;

    // 고정 높이 + Spacer를 제거한다. 긴 곡 제목/가수/소개가 자연스럽게
    // 높이를 늘려 화면 밖의 데이터도 PNG에 모두 담긴다.
    return SizedBox(
      width: imageWidth,
      child: ColoredBox(
        color: AppColor.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showHeading) ...[
                const SizedBox(height: 88),
                Text(
                  'SET LIST',
                  textAlign: TextAlign.center,
                  style: FontStyles.med12.copyWith(color: AppColor.white),
                ),
                const SizedBox(height: 29),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '*',
                        style: FontStyles.semi14.copyWith(
                          color: AppColor.beatOrange1,
                        ),
                      ),
                      TextSpan(text: team.teamName),
                    ],
                  ),
                  softWrap: true,
                  style: FontStyles.semi14.copyWith(color: AppColor.white),
                ),
                const SizedBox(height: 16),
              ],
              if (exportSongs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    '등록된 곡이 없습니다.',
                    style: FontStyles.reg14.copyWith(color: AppColor.gray5),
                  ),
                ),
              for (var i = 0; i < exportSongs.length; i++)
                _ExportSongRow(
                  number: startIndex + i + 1,
                  song: exportSongs[i],
                ),
              if (showFooter) ...[
                const SizedBox(height: 56),
                Center(
                  child: Image.asset(
                    'assets/images/beat_it_app_icon.png',
                    width: 33,
                    height: 33,
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ExportSongRow extends StatelessWidget {
  const _ExportSongRow({required this.number, required this.song});

  final int number;
  final PerformanceSetlistSong song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 28,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    '$number',
                    style: FontStyles.med14.copyWith(color: AppColor.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.beatOrange1,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: SvgPicture.asset(
                    'assets/icons/cloud/play.svg',
                    width: 10,
                    height: 10,
                    colorFilter: const ColorFilter.mode(
                      AppColor.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      song.musicTitle,
                      softWrap: true,
                      style: FontStyles.semi18.copyWith(color: AppColor.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.musicArtist,
                      softWrap: true,
                      style: FontStyles.med14.copyWith(color: AppColor.gray5),
                    ),
                    if (song.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        song.description,
                        softWrap: true,
                        style: FontStyles.med14.copyWith(
                          color: AppColor.gray5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: AppColor.gray4),
        ],
      ),
    );
  }
}
