import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('모바일 초대장 응답의 팀별 셋리스트를 파싱한다', () {
    final response = PerformanceInvitationResponse.fromJson({
      'title': '공연 제목',
      'performanceDateTime': '2026-11-15T18:00:00+09:00',
      'performanceTeam': '알사탕, ABA',
      'placeName': '공연장',
      'invitationDescription': '초대글',
      'setlist': [
        {
          'teamName': '알사탕',
          'musics': [
            {
              'musicTitle': 'Color',
              'musicArtist': 'nct wish',
              'description': '첫 번째 곡',
              'musicImageUrl': 'https://example.com/cover.jpg',
            },
          ],
        },
        {
          'teamName': 'ABA',
          'musics': [
            {
              'musicTitle': '두 번째 곡',
              'musicArtist': '테스트',
            },
          ],
        },
      ],
    });

    expect(response.setlist.length, 2);
    expect(response.setlist.first.teamName, '알사탕');
    expect(response.setlist.first.musics.first.musicTitle, 'Color');
    expect(response.setlist.first.musics.first.musicImageUrl,
        'https://example.com/cover.jpg');
    expect(response.toInvitationCard().description, '초대글');
    expect(response.toInvitationCard().setlist.last.musics.length, 1);
  });

  test('셋리스트가 null인 응답은 빈 목록으로 처리한다', () {
    final response = PerformanceInvitationResponse.fromJson({
      'title': '공연',
      'performanceDateTime': '2026-11-15T18:00:00+09:00',
      'setlist': null,
    });
    expect(response.setlist, isEmpty);
    expect(response.invitationDescription, isEmpty);
  });
}
