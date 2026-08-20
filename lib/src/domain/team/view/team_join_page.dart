import 'package:flutter/material.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';

import '../../../core/widgets/popups/app_popup.dart';
import '../widget/team_join_success_popup.dart';

class TeamJoinPage extends StatefulWidget {
  const TeamJoinPage({super.key});

  @override
  State<TeamJoinPage> createState() => _TeamJoinPageState();
}

class _TeamJoinPageState extends State<TeamJoinPage> {
  final inviteCodeController = TextEditingController();

  String? _errorMessage;
  bool _isFound = false;

  String _teamType = '';
  String _teamName = '';
  String _formattedDate = '';

  bool get _canSubmit {
    return inviteCodeController.text.trim().isNotEmpty;
  }

  void _handleJoinTeam() {
    setState(() {
      final code = inviteCodeController.text.trim();
      if (code == 'DSBEW3') {
        _errorMessage = null;
        _isFound = true;
        _teamType = 'Band';
        _teamName = '잘 나가는 밴드';
        _formattedDate = '2026.04.26';
      } else {
        _errorMessage = '존재하지 않는 코드입니다.';
        _isFound = false;
      }
    });
  }

  @override
  void dispose() {
    inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x24,
            horizontal: AppSpacing.x16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: '팀 가입 코드',
                      hintText: '가입 코드',
                      controller: inviteCodeController,
                      onChanged: (_) {
                        setState(() {
                          if (_errorMessage != null) _errorMessage = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  AppButton(
                    text: '확인',
                    variant: ButtonVariant.black,
                    height: ButtonHeight.small,
                    width: ButtonWidth.medium,
                    onPressed: _canSubmit ? _handleJoinTeam : null,
                  ),
                ],
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 6),
                Text(
                  _errorMessage!,
                  style: FontStyles.reg12.copyWith(color: context.brands.error),
                ),
              ],

              const SizedBox(height: AppSpacing.x24),

              if (_isFound) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/team_card_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.x20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _teamType,
                            style: FontStyles.med14.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _teamName,
                            style: FontStyles.bold34.copyWith(
                              color: context.colors.onPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          Text(
                            '$_formattedDate 개설',
                            style: FontStyles.med14.copyWith(
                              color: context.grays.gray5,
                            ),
                          ),
                          const Spacer(),
                          AppButton(
                            text: '팀 가입하기',
                            variant: ButtonVariant.primary,
                            width: ButtonWidth.expand,
                            height: ButtonHeight.normal,
                            onPressed: () async {
                              final result = await AppPopup.show(
                                context,
                                title: "팀 '$_teamName'에\n가입하시겠습니까?",
                                buttonNum: ButtonNum.two,
                                buttonSymmetric: ButtonSymmetric.vertical,
                                confirmText: '예',
                                cancelText: '아니요',
                                onConfirm: () {
                                  print('팀 가입 확정!');
                                },
                                onCancel: () {
                                  print('팀 가입 취소');
                                },
                              );

                              if (result == true && context.mounted) {
                                await TeamJoinSuccessPopup.show(
                                  context,
                                  teamName: _teamName,
                                  onConfirm: () {
                                    print('팀 페이지로 이동!');
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
