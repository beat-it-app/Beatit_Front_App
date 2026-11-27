class MusicSearchResult {
  const MusicSearchResult({
    required this.title,
    required this.artist,
    this.previewUrl,
    this.imageUrl,
    this.duration,
  });

  final String title;
  final String artist;
  final String? previewUrl;
  final String? imageUrl;
  final String? duration;

  factory MusicSearchResult.fromJson(Map<String, dynamic> json) {
    return MusicSearchResult(
      title: json['title']?.toString() ?? '',
      artist: json['artist']?.toString() ?? '',
      previewUrl: json['previewUrl']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      duration: json['duration']?.toString(),
    );
  }
}
