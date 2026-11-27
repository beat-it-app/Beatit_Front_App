import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';

void showTeamInviteDialog({
  required BuildContext context,
  required String teamName,
  required String inviteCode,
}) {
  final inviteMessage =
      '''
[BEAT IT] $teamName 팀에서 함께하기 위해 초대를 보냈어요.
앱 설치 후 팀 전용 초대코드를 입력해 가입을 완료해 주세요!

🔑 팀 초대코드: $inviteCode

📲 앱 다운로드
• Android: https://play.google.com
• iOS: https://apps.apple.com/...
'''
          .trim();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 팝업 타이틀
              Text(
                '팀 초대 메시지',
                style: FontStyles.bold22.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 20),
              Text(
                '아래 내용을 복사해 친구에게 보내세요!',
                style: FontStyles.semi16.copyWith(color: context.grays.gray4),
              ),
              const SizedBox(height: 18),

              // 초대 메시지 박스
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.grays.gray8,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[BEAT IT] $teamName 팀에서 함께하기 위해 초대를 보냈어요.\n앱 설치 후 팀 전용 초대코드를 입력해 가입을 완료해 주세요!',
                      style: FontStyles.reg14.copyWith(
                        color: context.colors.onSurface,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: FontStyles.reg14.copyWith(
                          color: context.colors.onSurface,
                        ),
                        children: [
                          const TextSpan(text: '🔑 팀 초대코드: '),
                          TextSpan(
                            text: inviteCode,
                            style: FontStyles.bold14.copyWith(
                              color: context.colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '📲 앱 다운로드\n• Android: https://play.google.com\n• iOS: https://apps.apple.com/...',
                      style: FontStyles.reg14.copyWith(
                        color: context.colors.onSurface,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // 1. 메시지 복사 버튼 (전체 복사)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.grays.gray1,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: inviteMessage));
                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('초대 메시지가 복사되었습니다.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: context.colors.surface,
                  ),
                  label: Text(
                    '메시지 복사',
                    style: FontStyles.semi16.copyWith(
                      color: context.colors.surface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 2. 닫기 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: context.grays.gray8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    '닫기',
                    style: FontStyles.semi16.copyWith(
                      color: context.grays.gray4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
