import 'package:beatit_front_app/src/domain/cloud/provider/cloud_mutation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 클라우드 작업이 진행 중이면 안내를 띄우고 true를 돌려준다.
bool blockIfCloudMutating(BuildContext context, WidgetRef ref) {
  if (!ref.read(cloudMutationProvider).isLoading) return false;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('처리 중입니다. 잠시 후 다시 시도해주세요.')),
  );
  return true;
}
