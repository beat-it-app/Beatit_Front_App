import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/cards/app_card.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_join_provider.dart';
import 'package:beatit_front_app/src/domain/team/view/team_select_page.dart';
import 'package:beatit_front_app/src/domain/team/widget/team_join_success_popup.dart';

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
  String? _teamImageUrl;

  bool get _canSubmit {
    return inviteCodeController.text.trim().length == 6;
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
        // 💡 이미지 필드 세팅 (모델 필드명에 맞게 설정: teamImageUrl 또는 imageUrl)
        _teamImageUrl = teamData?.teamImageUrl;
        _formattedDate = teamData != null && teamData.createdAt.length >= 10
            ? teamData.createdAt.substring(0, 10).replaceAll('-', '.')
            : (teamData?.createdAt ?? '');
      });
    } else {
      final err = ref.read(teamJoinProvider).errorMessage;
      setState(() {
        _errorMessage = err ?? '존재하지 않는 코드입니다.';
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
          Navigator.of(context).pop();
        },
      );
    } else {
      final state = ref.read(teamJoinProvider);
      final statusCode = state.statusCode;
      final errorCode = state.errorCode;
      final errorMessage = state.errorMessage ?? '';
      debugPrint(
        '🚨 [가입 실패] statusCode: $statusCode, errorCode: $errorCode, message: $errorMessage',
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
    final bool hasImage =
        _teamImageUrl != null &&
        _teamImageUrl!.trim().isNotEmpty &&
        _teamImageUrl!.startsWith('http');

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
                    variant: _canSubmit
                        ? ButtonVariant.darkGray
                        : ButtonVariant.gray,
                    height: ButtonHeight.small,
                    width: ButtonWidth.medium,
                    onPressed: state.isVerifying ? null : _handleVerifyCode,
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
                    if (hasImage)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: Container(
                          height: 280,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  _teamImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(color: const Color(0xFF1C1C1E)),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.45),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(AppSpacing.x20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      style: FontStyles.bold28.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.x4),
                                    Text(
                                      '$_formattedDate 개설',
                                      style: FontStyles.med14.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
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
