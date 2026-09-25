import 'package:beatit_front_app/src/domain/team/view/team_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/cards/app_card.dart'; // 추가된 위젯 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/popups/app_popup.dart';
import '../provider/team_join_provider.dart';
import '../widget/team_join_success_popup.dart';

class TeamJoinPage extends ConsumerStatefulWidget {
  const TeamJoinPage({super.key});

  @override
  ConsumerState<TeamJoinPage> createState() => _TeamJoinPageState();
}

class _TeamJoinPageState extends ConsumerState<TeamJoinPage> {
  final inviteCodeController = TextEditingController();

  String? _errorMessage;
  bool _isFound = false;

  String _teamPublicId = '';
  String _teamType = '';
  String _teamName = '';
  String _formattedDate = '';

  bool get _canSubmit {
    return inviteCodeController.text.trim().isNotEmpty;
  }

  Future<void> _handleVerifyCode() async {
    FocusScope.of(context).unfocus();
    final code = inviteCodeController.text.trim();

    final success = await ref
        .read(teamJoinProvider.notifier)
        .verifyInviteCode(code);

    if (!mounted) return;

    if (success) {
      final teamData = ref.read(teamJoinProvider).verifiedTeam;
      setState(() {
        _errorMessage = null;
        _isFound = true;
        _teamPublicId = teamData?.teamPublicId ?? '';
        _teamType = teamData?.teamType ?? '';
        _teamName = teamData?.teamName ?? '';
        _formattedDate = teamData != null && teamData.createdAt.length >= 10
            ? teamData.createdAt.substring(0, 10).replaceAll('-', '.')
            : (teamData?.createdAt ?? '');
      });
    } else {
      final err = ref.read(teamJoinProvider).errorMessage;
      setState(() {
        _errorMessage = '존재하지 않는 코드입니다.';
        _isFound = false;
      });
    }
  }

  Future<void> _handleJoinSubmit() async {
    final result = await AppPopup.show(
      context,
      title: "팀 '$_teamName'에\n가입하시겠습니까?",
      buttonNum: ButtonNum.two,
      buttonSymmetric: ButtonSymmetric.vertical,
      confirmText: '예',
      cancelText: '아니요',
    );

    if (result != true || !mounted) return;

    final joinSuccess = await ref
        .read(teamJoinProvider.notifier)
        .joinTeam(_teamPublicId);

    if (!mounted) return;

    if (joinSuccess) {
      await TeamJoinSuccessPopup.show(
        context,
        teamName: _teamName,
        onConfirm: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TeamDetailPage()),
            (route) => route.isFirst,
          );
        },
      );
    } else {
      final state = ref.read(teamJoinProvider);
      final statusCode = state.statusCode;
      final errorCode = state.errorCode;
      final errorMessage = state.errorMessage ?? '';
      print(
        '🚨 [가입 실패 디버깅] statusCode: $statusCode, errorCode: $errorCode, message: $errorMessage',
      );

      if (statusCode == 409 && errorCode == 'TEAM-010') {
        await AppPopup.show(
          context,
          title: '이미 가입되어 있습니다.',
          content: '팀 가입 코드를 다시 한번\n확인해주세요.',
          warningType: WarningType.circle,
          contentType: ContentType.small,
          buttonNum: ButtonNum.one,
          buttonSymmetric: ButtonSymmetric.horizontal,
          confirmText: '확인',
        );
      } else {
        final err = state.errorMessage;
        if (err != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(err)));
        }
      }
    }
  }

  @override
  void dispose() {
    inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teamJoinProvider);
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
                    text: state.isVerifying ? '확인 중' : '확인',
                    variant: ButtonVariant.black,
                    height: ButtonHeight.small,
                    width: ButtonWidth.medium,
                    onPressed: (_canSubmit && !state.isVerifying)
                        ? _handleVerifyCode
                        : null,
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
                Stack(
                  children: [
                    AppTeamCard(
                      genre: _teamType,
                      teamName: _teamName,
                      date: _formattedDate,
                      height: 280,
                    ),
                    Positioned(
                      left: AppSpacing.x20,
                      right: AppSpacing.x20,
                      bottom: AppSpacing.x20,
                      child: AppButton(
                        text: '팀 가입하기',
                        variant: ButtonVariant.primary,
                        width: ButtonWidth.expand,
                        height: ButtonHeight.normal,
                        onPressed: _handleJoinSubmit,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
