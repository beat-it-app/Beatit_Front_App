import 'package:beatit_front_app/src/domain/cloud/provider/cloud_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Team Cloud API가 작성자 ID/isMine을 내려주지 않아 UI 권한 표시에만 사용하는 임시 provider다.
/// 백엔드에 isMine 또는 uploaderId/creatorId가 추가되면 이름 비교를 제거해야 한다.
final cloudCurrentUserNameProvider = FutureProvider<String>((ref) async {
  return ref.watch(cloudApiProvider).getCurrentUserName();
});
