/// 서버의 알림 문구는 그대로 두고, 화면에서 팀 이름 접두어만 숨긴다.
/// 사용자 입력(투표명, 공지 제목, 메시지) 안의 동일한 문자열은 수정하지 않는다.
String withoutTeamPrefix(String value, String? teamName) {
  final name = teamName?.trim();
  if (name == null || name.isEmpty) return value;

  final bracketPrefix = '[$name]';
  if (value.startsWith(bracketPrefix)) {
    return value.substring(bracketPrefix.length).trimLeft();
  }

  // 채팅 알림은 '[팀명 / 채팅방명]'에서 팀명만 제거한다.
  final chatPrefix = '[$name / ';
  if (value.startsWith(chatPrefix)) {
    return '[${value.substring(chatPrefix.length)}';
  }

  final titlePrefix = '$name ';
  if (value.startsWith(titlePrefix)) {
    return value.substring(titlePrefix.length);
  }
  return value;
}

/// 앱 알림 목록의 제목은 서버 title 대신 알림 type으로 정한다.
/// 백엔드 NotificationType의 표시 이름과 같게 유지하며, 목록에 없는 type은 null을 반환한다.
const _alarmTitleByType = <String, String>{
  'MEMBER_JOIN': '멤버 가입',
  'MEMBER_LEAVE': '멤버 탈퇴',
  'PART_ASSIGNED': '파트 배정',
  'STUDIO_REGISTERED': '합주실/연습실 등록',
  'SCHEDULE_REGISTERED': '일정 등록',
  'SCHEDULE_REMINDER': '일정 알림',
  'NOTICE_REGISTERED': '공지사항 등록',
  'POLL_CREATED': '투표 생성',
  'POLL_DEADLINE_APPROACHING': '투표 마감 전 알림',
  'POLL_REMINDER': '투표 미참여 리마인드',
  'POLL_COMPLETED': '투표 완료',
  'MEETIT_CREATED': '밋잇 생성',
  'MEETIT_REMINDER': '밋잇 미참여 리마인드',
  'MEETIT_COMPLETED': '밋잇 참여 완료',
  'COMMENT_CREATED': '새로운 댓글',
  'COMMENT_MENTIONED': '댓글 멘션',
  'CHAT_MESSAGE': '채팅',
};

String? alarmTitleForType(String type) =>
    _alarmTitleByType[type.trim().toUpperCase()];
