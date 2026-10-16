/// 화면에 표시할 알림 정보. 실제 API DTO 변환은 알림 API 연동 단계에서 추가한다.
class AlarmNotification {
  const AlarmNotification({
    required this.id,
    required this.teamId,
    required this.teamName,
    required this.title,
    required this.content,
    required this.createdAt,
    this.directTo,
    this.targetId,
    this.isRead = false,
  });

  final int id;
  final int teamId;
  final String teamName;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? directTo;
  final int? targetId;
  final bool isRead;

  AlarmNotification copyWith({bool? isRead}) => AlarmNotification(
    id: id,
    teamId: teamId,
    teamName: teamName,
    title: title,
    content: content,
    createdAt: createdAt,
    directTo: directTo,
    targetId: targetId,
    isRead: isRead ?? this.isRead,
  );
}
