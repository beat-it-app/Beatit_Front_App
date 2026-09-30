import 'package:beatit_front_app/src/domain/cloud/api/cloud_api.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_api_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cloudMutationProvider =
    NotifierProvider<CloudMutationNotifier, CloudMutationState>(
      CloudMutationNotifier.new,
    );

class CloudMutationState {
  const CloudMutationState({
    this.isCreatingFolder = false,
    this.isRenamingFolder = false,
    this.isDeleting = false,
    this.isUploading = false,
    this.isCreatingLink = false,
    this.errorMessage,
  });

  final bool isCreatingFolder;
  final bool isRenamingFolder;
  final bool isDeleting;
  final bool isUploading;
  final bool isCreatingLink;
  final String? errorMessage;

  bool get isLoading =>
      isCreatingFolder ||
      isRenamingFolder ||
      isDeleting ||
      isUploading ||
      isCreatingLink;

  CloudMutationState copyWith({
    bool? isCreatingFolder,
    bool? isRenamingFolder,
    bool? isDeleting,
    bool? isUploading,
    bool? isCreatingLink,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CloudMutationState(
      isCreatingFolder: isCreatingFolder ?? this.isCreatingFolder,
      isRenamingFolder: isRenamingFolder ?? this.isRenamingFolder,
      isDeleting: isDeleting ?? this.isDeleting,
      isUploading: isUploading ?? this.isUploading,
      isCreatingLink: isCreatingLink ?? this.isCreatingLink,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class CloudMutationNotifier extends Notifier<CloudMutationState> {
  @override
  CloudMutationState build() => const CloudMutationState();

  Future<bool> createFolder({required String folderName}) async {
    final trimmed = folderName.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(errorMessage: '폴더 이름을 입력해주세요.');
      return false;
    }

    state = state.copyWith(isCreatingFolder: true, clearError: true);
    try {
      await ref.read(cloudApiProvider).createFolder(folderName: trimmed);
      ref.invalidate(cloudListProvider(null));
      state = state.copyWith(isCreatingFolder: false, clearError: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isCreatingFolder: false,
        errorMessage: _message(error),
      );
      return false;
    }
  }

  Future<bool> renameFolder({
    required int folderId,
    required String folderName,
  }) async {
    final trimmed = folderName.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(errorMessage: '폴더 이름을 입력해주세요.');
      return false;
    }

    state = state.copyWith(isRenamingFolder: true, clearError: true);
    try {
      await ref.read(cloudApiProvider).renameFolder(
        folderId: folderId,
        folderName: trimmed,
      );
      ref.invalidate(cloudListProvider(null));
      ref.invalidate(cloudListProvider(folderId));
      state = state.copyWith(isRenamingFolder: false, clearError: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isRenamingFolder: false,
        errorMessage: _message(error),
      );
      return false;
    }
  }

  Future<bool> deleteFolder({required int folderId}) async {
    state = state.copyWith(isDeleting: true, clearError: true);
    try {
      await ref.read(cloudApiProvider).deleteFolder(folderId: folderId);
      ref.invalidate(cloudListProvider(null));
      ref.invalidate(cloudListProvider(folderId));
      state = state.copyWith(isDeleting: false, clearError: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isDeleting: false,
        errorMessage: _message(error),
      );
      return false;
    }
  }

  Future<bool> deleteItems({
    required List<int> itemIds,
    int? currentFolderId,
  }) async {
    if (itemIds.isEmpty) {
      return true;
    }

    state = state.copyWith(isDeleting: true, clearError: true);
    try {
      await ref.read(cloudApiProvider).deleteItems(itemIds: itemIds);
      ref.invalidate(cloudListProvider(currentFolderId));
      if (currentFolderId != null) {
        ref.invalidate(cloudListProvider(null));
      }
      state = state.copyWith(isDeleting: false, clearError: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isDeleting: false,
        errorMessage: _message(error),
      );
      return false;
    }
  }

  Future<bool> uploadFile({
    int? folderId,
    required String filePath,
    required String fileName,
    required int fileSize,
  }) async {
    state = state.copyWith(isUploading: true, clearError: true);
    try {
      await ref.read(cloudApiProvider).uploadFile(
        folderId: folderId,
        filePath: filePath,
        fileName: fileName,
        fileSize: fileSize,
      );
      ref.invalidate(cloudListProvider(folderId));
      if (folderId != null) {
        ref.invalidate(cloudListProvider(null));
      }
      state = state.copyWith(isUploading: false, clearError: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isUploading: false,
        errorMessage: _message(error),
      );
      return false;
    }
  }

  Future<bool> createLink({
    int? folderId,
    required String itemName,
    required String linkUrl,
  }) async {
    state = state.copyWith(isCreatingLink: true, clearError: true);
    try {
      await ref.read(cloudApiProvider).createLink(
        folderId: folderId,
        itemName: itemName,
        linkUrl: linkUrl,
      );
      ref.invalidate(cloudListProvider(folderId));
      if (folderId != null) {
        ref.invalidate(cloudListProvider(null));
      }
      state = state.copyWith(isCreatingLink: false, clearError: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isCreatingLink: false,
        errorMessage: _message(error),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  String _message(Object error) {
    if (error is CloudApiException) {
      return error.message;
    }
    return '요청 처리 중 오류가 발생했습니다.';
  }
}
