import 'package:beatit_front_app/src/domain/cloud/model/cloud_models.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cloudListProvider = FutureProvider.family<CloudListData, int?>(
  (ref, folderId) async {
    final response = await ref.watch(cloudApiProvider).getCloudList(
      folderId: folderId,
    );
    return response.data;
  },
);
