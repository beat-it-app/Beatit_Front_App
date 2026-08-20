import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ButtonNum { one, two }

enum WarningType { none, circle, triangle }

enum ContentType { none, small, large }

enum ButtonSymmetric { horizontal, vertical }

class AppPopup extends StatelessWidget {
  final String title;

  /// 일반 텍스트 content
  final String? content;

  /// 운영진 변경 팝업처럼 이미지, RichText 등 커스텀 UI가 필요할 때 사용
  final Widget? contentWidget;

  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  final ButtonNum buttonNum;
  final ButtonSymmetric buttonSymmetric;
  final WarningType warningType;
  final ContentType contentType;

  final String confirmText;
  final String cancelText;

  const AppPopup({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.onConfirm,
    this.onCancel,
    this.buttonNum = ButtonNum.one,
    this.buttonSymmetric = ButtonSymmetric.horizontal,
    this.warningType = WarningType.none,
    this.contentType = ContentType.small,
    this.confirmText = '확인',
    this.cancelText = '취소',
  });

  /// 호출부에서 showDialog를 매번 직접 쓰기 싫을 때 사용하는 helper.
  ///
  /// 확인 버튼을 누르면 true,
  /// 취소 버튼을 누르면 false,
  /// 바깥 영역 터치 또는 뒤로가기로 닫히면 null을 반환한다.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? content,
    Widget? contentWidget,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    ButtonNum buttonNum = ButtonNum.one,
    ButtonSymmetric buttonSymmetric = ButtonSymmetric.horizontal,
    WarningType warningType = WarningType.none,
    ContentType contentType = ContentType.small,
    String confirmText = '확인',
    String cancelText = '취소',
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return AppPopup(
          title: title,
          content: content,
          contentWidget: contentWidget,
          onConfirm: onConfirm,
          onCancel: onCancel,
          buttonNum: buttonNum,
          buttonSymmetric: buttonSymmetric,
          warningType: warningType,
          contentType: contentType,
          confirmText: confirmText,
          cancelText: cancelText,
        );
      },
    );
  }

  bool get _hasContent {
    if (contentWidget != null) {
      return true;
    }

    if (contentType == ContentType.none) {
      return false;
    }

    return content?.trim().isNotEmpty ?? false;
  }

  void _handleConfirm(BuildContext context) {
    Navigator.of(context).pop(true);
    onConfirm?.call();
  }

  void _handleCancel(BuildContext context) {
    Navigator.of(context).pop(false);
    onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 310,
          maxHeight: screenHeight * 0.82,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x16,
            AppSpacing.x30,
            AppSpacing.x16,
            AppSpacing.x16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (warningType != WarningType.none) ...[
                _PopupWarningIcon(warningType: warningType),
                const SizedBox(height: AppSpacing.x20),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x16),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: FontStyles.bold22.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              if (_hasContent) ...[
                const SizedBox(height: AppSpacing.x20),
                Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    child: _PopupContent(
                      content: content,
                      contentWidget: contentWidget,
                      contentType: contentType,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.x30),

              _PopupButtons(
                buttonNum: buttonNum,
                buttonSymmetric: buttonSymmetric,
                confirmText: confirmText,
                cancelText: cancelText,
                onConfirm: () => _handleConfirm(context),
                onCancel: () => _handleCancel(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopupWarningIcon extends StatelessWidget {
  final WarningType warningType;

  const _PopupWarningIcon({required this.warningType});

  String? get _assetPath {
    switch (warningType) {
      case WarningType.none:
        return null;
      case WarningType.circle:
        return 'assets/icons/popup/circle_warning.svg';
      case WarningType.triangle:
        return 'assets/icons/popup/triangle_warning.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = _assetPath;

    if (assetPath == null) {
      return const SizedBox.shrink();
    }

    return Center(child: SvgPicture.asset(assetPath, width: 60, height: 60));
  }
}

class _PopupContent extends StatelessWidget {
  final String? content;
  final Widget? contentWidget;
  final ContentType contentType;

  const _PopupContent({
    this.content,
    this.contentWidget,
    required this.contentType,
  });

  TextStyle _textStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (contentType) {
      case ContentType.none:
      case ContentType.small:
        return FontStyles.semi16.copyWith(color: colorScheme.onSurfaceVariant);

      case ContentType.large:
        return FontStyles.semi20.copyWith(color: colorScheme.onSurface);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (contentWidget != null) {
      return contentWidget!;
    }

    return Text(
      content ?? '',
      textAlign: TextAlign.center,
      style: _textStyle(context),
    );
  }
}

class _PopupButtons extends StatelessWidget {
  final ButtonNum buttonNum;
  final ButtonSymmetric buttonSymmetric;

  final String confirmText;
  final String cancelText;

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _PopupButtons({
    required this.buttonNum,
    required this.buttonSymmetric,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (buttonNum == ButtonNum.one) {
      return AppButton(
        onPressed: onConfirm,
        variant: ButtonVariant.primary,
        text: confirmText,
      );
    }

    if (buttonSymmetric == ButtonSymmetric.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            onPressed: onConfirm,
            variant: ButtonVariant.primary,
            text: confirmText,
          ),
          const SizedBox(height: AppSpacing.x8),
          AppButton(
            onPressed: onCancel,
            variant: ButtonVariant.white,
            text: cancelText,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: AppButton(
            onPressed: onCancel,
            variant: ButtonVariant.gray,
            text: cancelText,
          ),
        ),
        const SizedBox(width: AppSpacing.x8),
        Expanded(
          child: AppButton(
            onPressed: onConfirm,
            variant: ButtonVariant.primary,
            text: confirmText,
          ),
        ),
      ],
    );
  }
}
