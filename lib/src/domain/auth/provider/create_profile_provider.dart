import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:beatit_front_app/src/domain/auth/api/auth_api.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_api_provider.dart';

final profileCreateProvider =
    NotifierProvider.autoDispose<ProfileCreateNotifier, ProfileCreateState>(
      ProfileCreateNotifier.new,
    );

sealed class ProfileImageSelection {
  const ProfileImageSelection();
}

class DefaultProfileSelection extends ProfileImageSelection {
  const DefaultProfileSelection(this.defaultImageId);

  final int defaultImageId;
}

class CustomProfileSelection extends ProfileImageSelection {
  const CustomProfileSelection(this.image);

  final XFile image;
}

class ProfileCreateState {
  const ProfileCreateState({
    this.selectedImage,
    this.isSubmitting = false,
    this.error,
  });

  final ProfileImageSelection? selectedImage;
  final bool isSubmitting;
  final String? error;

  bool get canSubmit {
    return selectedImage != null && !isSubmitting;
  }

  ProfileCreateState copyWith({
    ProfileImageSelection? selectedImage,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
  }) {
    return ProfileCreateState(
      selectedImage: selectedImage ?? this.selectedImage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class ProfileCreateNotifier extends Notifier<ProfileCreateState> {
  @override
  ProfileCreateState build() {
    return const ProfileCreateState();
  }

  void selectDefaultProfile(int defaultImageId) {
    state = state.copyWith(
      selectedImage: DefaultProfileSelection(defaultImageId),
      clearError: true,
    );
  }

  void selectCustomProfile(XFile image) {
    state = state.copyWith(
      selectedImage: CustomProfileSelection(image),
      clearError: true,
    );
  }

  Future<bool> createProfile({required String name}) async {
    final selection = state.selectedImage;

    if (selection == null) {
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final authApi = ref.read(authApiProvider);

      switch (selection) {
        case DefaultProfileSelection():
          await authApi.createProfile(
            name: name,
            defaultImageId: selection.defaultImageId,
          );

        case CustomProfileSelection():
          await authApi.createProfile(
            name: name,
            profileImage: selection.image,
          );
      }

      state = state.copyWith(isSubmitting: false);

      return true;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        error: _getErrorMessage(error),
      );

      return false;
    }
  }

  String _getErrorMessage(Object error) {
    if (error is AuthApiException) {
      return error.message;
    }

    return '프로필 생성 중 오류가 발생했습니다.';
  }
}
