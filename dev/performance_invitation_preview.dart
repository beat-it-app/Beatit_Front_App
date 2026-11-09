// 디버그 전용 UI 확인용 진입점: flutter run -t dev/performance_invitation_preview.dart
// 이 곡들은 서버에 등록된 곡이 아닌, 저장된 JSON 구조를 재현한 샘플입니다.
import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_invite_view_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PerformanceInviteViewPage(performance: previewPerformance),
    ),
  );
}

final previewPerformance = PerformanceDetailModel.fromJson({
  'performanceId': 1,
  'performancePublicId': 'debug-preview-only',
  'teamId': 1,
  'teamName': '연합밴드',
  'title': '2026 전설·밴드 연합공연',
  'performanceDateTime': '2026-11-15T18:00:00+09:00',
  'placeName': '홍대 소형홀 B2',
  'invitationCard': {
    'performanceTeam': '알사탕, ABA, BBO',
    'description': List.filled(
      7,
      '안녕하세요! 대학생 연합 밴드 공연에 초대합니다. '
          '멋진 공연을 준비했으니 많이 찾아주세요.\n',
    ).join('\n'),
    'setlist': [
      {
        'teamName': '알사탕',
        'musics': [
          for (var i = 1; i <= 10; i++)
            {
              'musicTitle': '테스트 공연곡 $i',
              'musicArtist': 'Sample Artist',
              'description': '실제 등록 곡이 아닌 UI 스크롤 확인용 샘플입니다.',
            },
        ],
      },
      {
        'teamName': 'ABA',
        'musics': [
          {
            'musicTitle': 'Color',
            'musicArtist': 'nct wish',
            'description': '두 번째 팀 곡 소개 테스트',
          },
          {
            'musicTitle': '테스트 곡 2',
            'musicArtist': 'Sample Artist',
            'description': '다른 팀 선택 시 교체되는 곡 목록',
          },
        ],
      },
      {
        'teamName': 'BBO',
        'musics': [
          {
            'musicTitle': '테스트 곡',
            'musicArtist': 'Sample Artist',
            'description': '마지막 팀 곡 목록 표시',
          },
        ],
      },
    ],
  },
});
