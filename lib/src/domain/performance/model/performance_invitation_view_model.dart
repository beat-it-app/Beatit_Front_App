/// GET /performances/{publicId}/invitation 응답.
/// 일반 공연 상세 응답에는 invitationCard/setlist 필드가 포함되지 않는다.
class PerformanceInvitationResponse {
  const PerformanceInvitationResponse({
    required this.title,
    required this.performanceDateTime,
    required this.performanceTeam,
    required this.placeName,
    required this.invitationDescription,
    required this.setlist,
  });

  final String title;
  final DateTime? performanceDateTime;
  final String performanceTeam;
  final String placeName;
  final String invitationDescription;
  final List<PerformanceSetlistTeam> setlist;

  factory PerformanceInvitationResponse.fromJson(Map<String, dynamic> json) {
    final rawSetlist = json['setlist'];
    return PerformanceInvitationResponse(
      title: json['title']?.toString() ?? '',
      performanceDateTime: json['performanceDateTime'] == null
          ? null
          : DateTime.tryParse(json['performanceDateTime'].toString())?.toLocal(),
      performanceTeam: json['performanceTeam']?.toString() ?? '',
      placeName: json['placeName']?.toString() ?? '',
      invitationDescription: json['invitationDescription']?.toString() ?? '',
      setlist: rawSetlist is List
          ? rawSetlist
              .whereType<Map>()
              .map((team) => PerformanceSetlistTeam.fromJson(
                    Map<String, dynamic>.from(team),
                  ))
              .toList(growable: false)
          : const [],
    );
  }

  PerformanceInvitationCard toInvitationCard() => PerformanceInvitationCard(
        performanceTeam: performanceTeam,
        description: invitationDescription,
        setlist: setlist,
      );
}

/// 공연 생성/수정 요청의 `invitationCard` 구조를 조회 UI에서도 사용한다.
/// 조회 API에 이 필드가 없다면 빈 곡 목록으로 처리한다.
class PerformanceInvitationCard {
  const PerformanceInvitationCard({
    required this.performanceTeam,
    required this.description,
    required this.setlist,
  });

  final String performanceTeam;
  final String description;
  final List<PerformanceSetlistTeam> setlist;

  factory PerformanceInvitationCard.fromJson(Map<String, dynamic> json) {
    final rawTeams = json['setlist'];
    return PerformanceInvitationCard(
      performanceTeam: json['performanceTeam']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      setlist: rawTeams is List
          ? rawTeams
              .whereType<Map>()
              .map((raw) => PerformanceSetlistTeam.fromJson(
                    Map<String, dynamic>.from(raw),
                  ))
              .toList(growable: false)
          : const [],
    );
  }
}

class PerformanceSetlistTeam {
  const PerformanceSetlistTeam({required this.teamName, required this.musics});

  final String teamName;
  final List<PerformanceSetlistSong> musics;

  factory PerformanceSetlistTeam.fromJson(Map<String, dynamic> json) {
    final rawSongs = json['musics'];
    return PerformanceSetlistTeam(
      teamName: json['teamName']?.toString() ?? '',
      musics: rawSongs is List
          ? rawSongs
              .whereType<Map>()
              .map((raw) => PerformanceSetlistSong.fromJson(
                    Map<String, dynamic>.from(raw),
                  ))
              .toList(growable: false)
          : const [],
    );
  }
}

class PerformanceSetlistSong {
  const PerformanceSetlistSong({
    required this.musicTitle,
    required this.musicArtist,
    required this.description,
    this.musicPreviewUrl,
    this.musicImageUrl,
  });

  final String musicTitle;
  final String musicArtist;
  final String description;
  final String? musicPreviewUrl;
  final String? musicImageUrl;

  factory PerformanceSetlistSong.fromJson(Map<String, dynamic> json) {
    return PerformanceSetlistSong(
      musicTitle: json['musicTitle']?.toString() ?? '',
      musicArtist: json['musicArtist']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      musicPreviewUrl: (json['musicPreviewUrl'] ?? json['previewUrl'])?.toString(),
      musicImageUrl: (json['musicImageUrl'] ?? json['imageUrl'])?.toString(),
    );
  }
}
