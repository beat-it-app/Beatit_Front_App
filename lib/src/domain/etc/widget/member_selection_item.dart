import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// 서버 role 값과 1:1로 대응한다.
enum MemberSelectionRole {
  leader('LEADER'),
  manager('MANAGER'),
  member('MEMBER');

  const MemberSelectionRole(this.apiValue);

  final String apiValue;

  static MemberSelectionRole fromApiValue(String value) {
    return MemberSelectionRole.values.firstWhere(
      (role) => role.apiValue == value,
      orElse: () => MemberSelectionRole.member,
    );
  }
}

class MemberSelectionItem extends StatelessWidget {
  const MemberSelectionItem({
    super.key,
    required this.name,
    required this.role,
    required this.isSelected,
    required this.onTap,
    this.profileImageUrl,
  });

  final String name;
  final MemberSelectionRole role;
  final String? profileImageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? context.grays.gray8 : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x20,
              vertical: AppSpacing.x8,
            ),
            child: Row(
              children: [
                _MemberProfileImage(profileImageUrl: profileImageUrl),
                const SizedBox(width: AppSpacing.x12),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontStyles.semi16.copyWith(
                      color: context.grays.black,
                    ),
                  ),
                ),
                if (role != MemberSelectionRole.member) ...[
                  const SizedBox(width: AppSpacing.x12),
                  _MemberRoleBadge(role: role),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberProfileImage extends StatelessWidget {
  const _MemberProfileImage({required this.profileImageUrl});

  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    const size = 40.0;

    if (profileImageUrl == null || profileImageUrl!.trim().isEmpty) {
      return _fallback(context, size);
    }

    return ClipOval(
      child: Image.network(
        profileImageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(context, size),
      ),
    );
  }

  Widget _fallback(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.grays.gray7,
      ),
      alignment: Alignment.center,
      child: Icon(Icons.person, size: 24.0, color: context.grays.gray5),
    );
  }
}

class _MemberRoleBadge extends StatelessWidget {
  const _MemberRoleBadge({required this.role});

  final MemberSelectionRole role;

  @override
  Widget build(BuildContext context) {
    final (label, backgroundColor) = switch (role) {
      MemberSelectionRole.leader => ('대표', context.grays.gray1),
      MemberSelectionRole.manager => ('운영진', context.brands.beatOrange1),
      MemberSelectionRole.member => ('', Colors.transparent),
    };

    if (label.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x8,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: FontStyles.med12.copyWith(color: context.grays.white),
      ),
    );
  }
}
