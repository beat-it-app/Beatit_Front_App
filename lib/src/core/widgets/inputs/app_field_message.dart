import 'package:flutter/material.dart';

import '../../theme/app_fonts.dart';
import '../../theme/app_spacing.dart';

/// 입력창과 관련된 안내/오류 문구를 페이지 레이아웃에서 표시할 때 사용함.
class AppFieldMessage extends StatelessWidget {
  const AppFieldMessage({
    super.key,
    required this.text,
    this.isError = false,
    this.color,
    this.icon,
  });

  final String text;
  final bool isError;
  final Color? color;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textColor = isError
        ? colors.error
        : color ?? colors.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: AppSpacing.x4),
        ],
        Expanded(
          child: Text(
            text,
            style: FontStyles.reg12.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}
