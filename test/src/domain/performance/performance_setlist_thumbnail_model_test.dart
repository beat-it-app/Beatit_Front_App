import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PerformanceSetlistSong thumbnail metadata', () {
    test('모바일 초대장 API의 musicImageUrl/musicPreviewUrl을 복원한다', () {
      final response = PerformanceInvitationResponse.fromJson({
        'title': '연합공연',
        'performanceTeam': 'ABC',
        'performanceDateTime': '2026-11-10T18:00:00+09:00',
        'placeName': '공연장',
        'invitationDescription': '소개글',
        'setlist': [
          {
            'teamName': 'ABC',
            'musics': [
              {
                'musicTitle': '테스트 곡',
                'musicArtist': '테스트 가수',
                'description': '곡 설명',
                'musicImageUrl': 'https://example.com/cover.jpg',
                'musicPreviewUrl': 'https://example.com/preview.m4a',
              }
            ]
          }
        ]
      });

      expect(response.setlist.single.musics.single.musicImageUrl,
          'https://example.com/cover.jpg');
      expect(response.setlist.single.musics.single.musicPreviewUrl,
          'https://example.com/preview.m4a');
      expect(response.toInvitationCard().setlist.single.musics.single.musicTitle,
          '테스트 곡');
    });

    test('기존 저장 데이터의 imageUrl/previewUrl 별칭도 지원한다', () {
      final song = PerformanceSetlistSong.fromJson({
        'musicTitle': '테스트 곡',
        'musicArtist': '가수',
        'imageUrl': 'https://example.com/legacy.jpg',
        'previewUrl': 'https://example.com/legacy.m4a',
      });

      expect(song.musicImageUrl, 'https://example.com/legacy.jpg');
      expect(song.musicPreviewUrl, 'https://example.com/legacy.m4a');
      expect(song.description, '');
    });

    test('이미지 URL이 없는 기존 곡은 null로 유지한다', () {
      final song = PerformanceSetlistSong.fromJson({
        'musicTitle': '기존 곡',
        'musicArtist': '가수',
      });

      expect(song.musicImageUrl, isNull);
      expect(song.musicPreviewUrl, isNull);
    });
  });
}
