import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const double _chatAppBarActionWidth = 60.0;
const double _chatAppBarActionHeight = 48.0;

class ChatRoomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatRoomAppBar({
    super.key,
    required this.roomName,
    required this.participantCount,
    required this.onBackPressed,
    required this.moreMenuItems,
    this.moreMenuAlignment = AppDropdownAlignment.right,
    this.moreMenuWidth = 170.0,
    this.moreMenuItemHeight = 44.0,
    this.moreMenuOffset = const Offset(-16, 40),
    this.toolbarHeight = 64.0,
  });

  final String roomName;
  final int participantCount;
  final VoidCallback onBackPressed;
  final List<AppDropdownItem> moreMenuItems;
  final AppDropdownAlignment moreMenuAlignment;
  final double moreMenuWidth;
  final double moreMenuItemHeight;
  final Offset moreMenuOffset;
  final double toolbarHeight;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final showParticipantCount = participantCount > 2;

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      toolbarHeight: toolbarHeight,
      leadingWidth: _chatAppBarActionWidth,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: colors.onSurface,
      leading: _ChatAppBarIconButton(
        icon: 'assets/icons/appbar/back.svg',
        semanticLabel: '뒤로가기',
        onPressed: onBackPressed,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              roomName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontStyles.semi20.copyWith(color: context.grays.black),
            ),
          ),
          if (showParticipantCount) ...[
            const SizedBox(width: 4),
            Text(
              '$participantCount',
              style: FontStyles.semi20.copyWith(color: context.grays.gray4),
            ),
          ],
        ],
      ),
      actions: [
        AppDropdownList(
          items: moreMenuItems,
          width: moreMenuWidth,
          anchorWidth: _chatAppBarActionWidth,
          itemHeight: moreMenuItemHeight,
          alignment: moreMenuAlignment,
          alignmentOffset: moreMenuOffset,
          triggerBuilder: (context, controller) {
            return _ChatAppBarIconButton(
              icon: 'assets/icons/appbar/menu.svg',
              semanticLabel: '더보기 메뉴',
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                  return;
                }
                controller.open();
              },
            );
          },
        ),
      ],
    );
  }
}

class _ChatAppBarIconButton extends StatefulWidget {
  const _ChatAppBarIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  final String icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  State<_ChatAppBarIconButton> createState() => _ChatAppBarIconButtonState();
}

class _ChatAppBarIconButtonState extends State<_ChatAppBarIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: SizedBox(
          width: _chatAppBarActionWidth,
          height: _chatAppBarActionHeight,
          child: Center(
            child: AnimatedScale(
              scale: _pressed ? 0.86 : 1.0,
              duration: Duration(milliseconds: _pressed ? 200 : 400),
              curve: Curves.easeOutCubic,
              child: SvgPicture.asset(
                widget.icon,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  context.grays.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
