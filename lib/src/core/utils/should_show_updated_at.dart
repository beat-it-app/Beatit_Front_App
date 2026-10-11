/// 생성 시각과 수정 시각의 차이가 60초를 초과한 경우에만 수정일을 표시한다.
///
/// 생성 직후 서버에서 자동 설정한 updatedAt의 오차뿐 아니라,
/// 실제 수정이 60초 이내에 이루어진 경우도 수정일 표기에서 제외한다.
bool shouldShowUpdatedAt(DateTime createdAt, DateTime updatedAt) {
  return updatedAt.difference(createdAt) > const Duration(seconds: 60);
}