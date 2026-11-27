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

final cloudFileDetailProvider = FutureProvider.family<CloudFileDetail, int>(
  (ref, itemId) async {
    final response = await ref.watch(cloudApiProvider).getFileDetail(
      itemId: itemId,
    );
    return response.data;
  },
);

/// 파일 검색 전용 가벼운 인덱스. 기존 목록 API가 폴더 단위이므로 하위 폴더도 순회합니다.
/// 같은 폴더는 한 번만 호출하며 Riverpod FutureProvider 캐시를 재사용합니다.
class CloudSearchEntry {
  const CloudSearchEntry({
    required this.item,
    required this.folderId,
    required this.folderName,
    required this.siblings,
  });

  final CloudItem item;
  final int? folderId;
  final String folderName;
  final List<CloudItem> siblings;
}

final cloudSearchEntriesProvider = FutureProvider<List<CloudSearchEntry>>((ref) async {
  final api = ref.watch(cloudApiProvider);
  final root = await ref.watch(cloudListProvider(null).future);
  final queue = <({int? folderId, CloudListData data})>[
    (folderId: null, data: root),
  ];
  final visited = <int>{};
  final entries = <CloudSearchEntry>[];

  for (var index = 0; index < queue.length; index++) {
    final current = queue[index];
    final siblings = current.data.items;
    final folderName = current.data.currentFolderName ?? '팀 클라우드';
    for (final item in siblings) {
      entries.add(CloudSearchEntry(
        item: item,
        folderId: current.folderId,
        folderName: folderName,
        siblings: siblings,
      ));
    }
    for (final folder in current.data.folders) {
      if (!visited.add(folder.folderId)) continue;
      final response = await api.getCloudList(folderId: folder.folderId);
      queue.add((folderId: folder.folderId, data: response.data));
    }
  }
  return entries;
});
