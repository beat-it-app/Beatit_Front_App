import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('공연 생성과 동일한 invitationCard.setlist 형식으로 등록된 곡을 조회한다', () {
    final detail = PerformanceDetailModel.fromJson({
      'title': '공연명',
      'performanceDateTime': '2026-11-15T18:00:00+09:00',
      'invitationCard': {
        'performanceTeam': '알사탕, ABA',
        'description': '긴 공연 소개',
        'setlist': [
          {
            'teamName': '알사탕',
            'musics': [
              {
                'musicTitle': 'Color',
                'musicArtist': 'nct wish',
                'description': '첫 번째 곡 소개',
              },
              {
                'musicTitle': '두 번째 곡',
                'musicArtist': '아티스트',
                'description': '',
              },
            ],
          },
        ],
      },
    });

    expect(detail.invitationCard?.performanceTeam, '알사탕, ABA');
    expect(detail.invitationCard?.setlist.single.teamName, '알사탕');
    expect(detail.invitationCard?.setlist.single.musics.length, 2);
    expect(detail.invitationCard?.setlist.single.musics.first.musicTitle, 'Color');
  });
}
