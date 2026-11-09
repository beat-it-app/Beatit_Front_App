import 'dart:math' as math;

import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';
import 'package:flutter/material.dart';

/// 한 팀당 PNG 한 장. 곡 수만큼 이미지 높이를 늘려 목록 전체를 출력한다.
/// (스크롤 가능한 ListView가 아니므로 스크롤에 가려진 곡도 잘리지 않는다.)
class PerformanceSetlistExport extends StatelessWidget {
  const PerformanceSetlistExport({
    super.key,
    required this.team,
  });

  final PerformanceSetlistTeam team;

  static const double imageWidth = 360;
  static const double _rowHeight = 58;

  double get imageHeight =>
      math.max(800, 280 + team.musics.length * _rowHeight).toDouble();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: ColoredBox(
        color: AppColor.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              const SizedBox(height: 88),
              Text(
                'SET LIST',
                style: FontStyles.med12.copyWith(color: AppColor.white),
              ),
              const SizedBox(height: 29),
              Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: '*',
                      style: FontStyles.semi14.copyWith(
                        color: AppColor.beatOrange1,
                      ),
                    ),
                    TextSpan(text: team.teamName),
                  ]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.semi14.copyWith(color: AppColor.white),
                ),
              ),
              const SizedBox(height: 16),
              if (team.musics.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    '등록된 곡이 없습니다.',
                    style: FontStyles.reg14.copyWith(color: AppColor.gray5),
                  ),
                ),
              for (var i = 0; i < team.musics.length; i++)
                _ExportSongRow(number: i + 1, song: team.musics[i]),
              const Spacer(),
              Text(
                'Beat It!',
                style: FontStyles.bold18.copyWith(
                  color: AppColor.beatOrange1,
                ),
              ),
              const SizedBox(height: 36),
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
    return SizedBox(
      height: PerformanceSetlistExport._rowHeight,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '$number',
                    textAlign: TextAlign.left,
                    style: FontStyles.reg14.copyWith(color: AppColor.white),
                  ),
                ),
                Container(
                  height: 22,
                  width: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.beatOrange1,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 15,
                    color: AppColor.white,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        song.musicTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyles.semi16.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        song.musicArtist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyles.reg12.copyWith(
                          color: AppColor.gray5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColor.gray4),
        ],
      ),
    );
  }
}
