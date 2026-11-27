import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class PrivacyConsentPopup extends StatelessWidget {
  /// 일반 텍스트 content
  final String? content;

  /// 운영진 변경 팝업처럼 이미지, RichText 등 커스텀 UI가 필요할 때 사용
  final Widget? contentWidget;

  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  final String confirmText;
  final String cancelText;

  const PrivacyConsentPopup({
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
        return PrivacyConsentPopup(
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
            AppSpacing.x30,
            AppSpacing.x16,
            AppSpacing.x16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: FontStyles.bold22.copyWith(color: context.grays.black),
                  children: [
                    TextSpan(text: '개인정보 수집'),
                    TextSpan(text: '\n및 이용 동의'),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' •  회사는 회원가입 및 원활한 서비스 제공을 위해 아래와 같이 최소한의 개인정보를 수집합니다.',
                        style: FontStyles.med12.copyWith(
                          color: context.grays.gray4,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x10),
                      const _PrivacyTable(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x20),

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

class _PrivacyTable extends StatelessWidget {
  const _PrivacyTable();

  static const _columnGap = 12.0;
  static const _rowGap = 8.0;

  @override
  Widget build(BuildContext context) {
    final headerStyle = FontStyles.bold22.copyWith(
      fontSize: 11,
      color: context.grays.gray1,
    );
    final bodyStyle = FontStyles.med11.copyWith(
      color: context.grays.gray4,
      height: 1.25,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x12,
        vertical: AppSpacing.x10,
      ),
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          _PrivacyTableRow(
            height: 28,
            gap: _columnGap,
            values: const ['수집 항목', '수집 및 이용 목적', '보유 및 이용기간'],
            style: headerStyle,
          ),
          const SizedBox(height: _rowGap),
          _PrivacyTableRow(
            height: 48,
            gap: _columnGap,
            values: const [
              '아이디,\n비밀번호,\n이메일',
              '회원 가입 및 식별,\n계정 보호,\n고지사항 전달',
              '회원 탈퇴 시\n즉시 파기',
            ],
            style: bodyStyle,
          ),
          const SizedBox(height: _rowGap),
          _PrivacyTableRow(
            height: 48,
            gap: _columnGap,
            values: const [
              '이름(닉네임),\n프로필 사진',
              '서비스 내 프로필\n구성 및 팀원 간\n식별',
              '회원 탈퇴 시\n즉시 파기',
            ],
            style: bodyStyle,
          ),
          const SizedBox(height: _rowGap),
          _PrivacyTableRow(
            height: 48,
            gap: _columnGap,
            values: const ['서비스 이용 기록,\n접속 로그', '서비스 부정 이용\n방지 및 품질 개선', '6개월'],
            style: bodyStyle,
          ),
        ],
      ),
    );
  }
}

class _PrivacyTableRow extends StatelessWidget {
  const _PrivacyTableRow({
    required this.height,
    required this.gap,
    required this.values,
    required this.style,
  });

  final double height;
  final double gap;
  final List<String> values;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < values.length; index++) ...[
            Expanded(child: Text(values[index], style: style)),
            if (index != values.length - 1) SizedBox(width: gap),
          ],
        ],
      ),
    );
  }
}
