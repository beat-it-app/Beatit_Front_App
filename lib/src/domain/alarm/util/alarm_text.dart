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
