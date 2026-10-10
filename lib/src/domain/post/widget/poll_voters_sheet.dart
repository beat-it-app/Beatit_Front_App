import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/post/model/poll_voter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// TeamMemberPage의 일반 멤버 행(프로필 · 이름 · 포지션)을 차용하고
/// 역할 배지는 제외한다. 선택지별 명단은 비익명 투표에서만 노출한다.
class PollVotersSheet extends StatefulWidget {
  const PollVotersSheet({super.key, required this.loadVoters});

  final Future<List<PollVoter>> Function() loadVoters;

  @override
  State<PollVotersSheet> createState() => _PollVotersSheetState();
}

class _PollVotersSheetState extends State<PollVotersSheet> {
  late final Future<List<PollVoter>> _votersFuture;

  @override
  void initState() {
    super.initState();
    _votersFuture = widget.loadVoters();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.58,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x20),
              child: Row(
                children: [
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      '투표한 사람',
                      style: FontStyles.bold20.copyWith(
                        color: context.colors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<PollVoter>>(
                future: _votersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '투표자 명단을 불러오지 못했습니다.',
                        style: FontStyles.med14.copyWith(
                          color: context.grays.gray5,
                        ),
                      ),
                    );
                  }
                  final voters = snapshot.data ?? const <PollVoter>[];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.x20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: context.grays.gray8,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/post/people.svg',
                                width: 16,
                                height: 16,
                                colorFilter: ColorFilter.mode(
                                  context.grays.gray2,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x4),
                              Text(
                                '${voters.length}명',
                                style: FontStyles.med14.copyWith(
                                  color: context.grays.gray2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x16),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.x20,
                          ),
                          itemCount: voters.length,
                          separatorBuilder: (_, __) => Divider(
                            color: context.grays.gray6,
                            thickness: 1,
                            height: AppSpacing.x16,
                          ),
                          itemBuilder: (context, index) =>
                              _VoterRow(voter: voters[index]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoterRow extends StatelessWidget {
  const _VoterRow({required this.voter});

  final PollVoter voter;

  @override
  Widget build(BuildContext context) {
    final imageUrl = voter.profileImageUrl?.trim();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox(
              height: 56,
              width: 56,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallbackImage(),
                    )
                  : _fallbackImage(),
            ),
          ),
          const SizedBox(width: AppSpacing.x16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voter.name,
                  style: FontStyles.semi20.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  (voter.position?.trim().isNotEmpty ?? false)
                      ? voter.position!
                      : '',
                  style: FontStyles.reg16.copyWith(color: context.grays.gray5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage() =>
      Image.asset('assets/images/auth/profile_orange.png', fit: BoxFit.cover);
}
