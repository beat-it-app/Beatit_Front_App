import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class ServiceConsentPopup extends StatelessWidget {
  /// 일반 텍스트 content
  final String? content;

  /// 운영진 변경 팝업처럼 이미지, RichText 등 커스텀 UI가 필요할 때 사용
  final Widget? contentWidget;

  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  final String confirmText;
  final String cancelText;

  const ServiceConsentPopup({
    super.key,
    this.content,
    this.contentWidget,
    this.onConfirm,
    this.onCancel,
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
    String confirmText = '확인',
    String cancelText = '취소',
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return ServiceConsentPopup(
          content: content,
          contentWidget: contentWidget,
          onConfirm: onConfirm,
          onCancel: onCancel,
          confirmText: confirmText,
          cancelText: cancelText,
        );
      },
    );
  }

  void _handleConfirm(BuildContext context) {
    Navigator.of(context).pop(true);
    onConfirm?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 310,
        height: 450,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x16,
            AppSpacing.x40,
            AppSpacing.x20,
            AppSpacing.x16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: FontStyles.bold22.copyWith(color: context.grays.black),
                  children: [
                    TextSpan(text: '서비스 이용약관'),
                    TextSpan(
                      text: ' (필수)',
                      style: FontStyles.bold22.copyWith(
                        color: context.brands.beatOrange1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.x20),
              SizedBox(
                height: 270,
                width: double.infinity,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(right: AppSpacing.x8),
                    child: const _ServiceTermsContent(),
                  ),
                ),
              ),

              const Spacer(),

              AppButton(
                onPressed: () => _handleConfirm(context),
                variant: ButtonVariant.primary,
                text: confirmText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceTermsContent extends StatelessWidget {
  const _ServiceTermsContent();

  @override
  Widget build(BuildContext context) {
    final textStyle = FontStyles.med12.copyWith(
      color: context.grays.gray4,
      height: 1.8,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' •  제 1조 (목적)', style: textStyle),
        const SizedBox(height: AppSpacing.x4),
        Text(
          '본 약관은 Beat It(이하 “빗잇”)이 제공하는 앱 서비스 및 관련 제반 서비스의 이용과 관련하여, 서비스 내에서 업로드, 다운로드, 공유되는 모든 정보 및 콘텐츠(텍스트, 그래픽, 사진 등)에 대한 접근 및 이용에 관한 사항을 규정함을 목적으로 합니다.',
          style: textStyle,
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(' •  제 2조 (회원가입 및 계정 관리)', style: textStyle),
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.x20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'a.  이용자는 회사가 정한 양식에 따라 회원정보를 기입함으로써 회원가입을 신청합니다.',
                style: textStyle,
              ),
              Text(
                'b.  회원은 본인의 아이디와 비밀번호를 관리할 책임이 있으며, 타인의 정보를 도용하여 가입한 경우 서비스 이용이 제한될 수 있습니다.',
                style: textStyle,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(' •  제 3조 (콘텐츠의 이용 및 책임)', style: textStyle),
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.x20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'a.  회원이 빗잇에 업로드한 콘텐츠의 저작권은 해당 회원에게 귀속됩니다.',
                style: textStyle,
              ),
              Text(
                'b.  회원은 타인의 저작권을 침해하는 콘텐츠를 업로드해서는 안 되며, 이로 인해 발생하는 법적 책임은 회원 본인에게 있습니다.',
                style: textStyle,
              ),
              Text(
                'c.  빗잇은 서비스의 운영, 개선 및 홍보에 필요한 범위 내에서 회원의 콘텐츠를 복제, 수정, 전시할 수 있습니다.',
                style: textStyle,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(' •  제 4조 (이용의 제한 및 종료)', style: textStyle),
        const SizedBox(height: AppSpacing.x4),
        Text(
          '본 약관에 동의하지 않는 경우 빗잇 서비스 및 콘텐츠 이용이 불가능하며, 회원이 약관을 위반할 경우 회사는 계정을 정지하거나 서비스 이용을 제한할 수 있습니다.',
          style: textStyle,
        ),
      ],
    );
  }
}
