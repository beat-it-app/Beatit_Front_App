import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/domain/post/widget/post_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum PollOptionType { text, date, music, place }

extension PollOptionTypeX on PollOptionType {
  String get label => switch (this) {
    PollOptionType.text => '텍스트',
    PollOptionType.date => '날짜',
    PollOptionType.music => '음악',
    PollOptionType.place => '장소',
  };

  String get hintText => switch (this) {
    PollOptionType.text => '보기를 입력하세요.',
    PollOptionType.date => '날짜를 선택하세요.',
    PollOptionType.music => '음원을 선택하세요.',
    PollOptionType.place => '장소를 선택하세요.',
  };

  String? get trailingIconPath => switch (this) {
    PollOptionType.text => null,
    PollOptionType.date => 'assets/icons/post/calendar.svg',
    PollOptionType.music => 'assets/icons/post/music_symbol.svg',
    PollOptionType.place => 'assets/icons/post/search.svg',
  };
}

class PollOptionValue {
  const PollOptionValue({required this.id, required this.value});

  final int id;
  final String value;
}

typedef PollOptionsChanged =
    void Function(PollOptionType type, List<PollOptionValue> options);

/// 투표 생성 화면의 "투표란" 전체를 담당하는 feature 전용 위젯.
///
/// - 투표 타입 선택
/// - 항목 추가/삭제
/// - 드래그 순서 변경
/// - 타입별 trailing 아이콘 표시
/// 를 한 곳에서 관리한다.
class PollAddBox extends StatefulWidget {
  const PollAddBox({
    super.key,
    this.initialOptionCount = 3,
    this.onChanged,
    this.onDatePressed,
    this.onMusicPressed,
    this.onPlacePressed,
  });

  final int initialOptionCount;
  final PollOptionsChanged? onChanged;

  /// 실제 날짜 선택 BottomSheet/DatePicker 연결 지점.
  final ValueChanged<int>? onDatePressed;

  /// 실제 음원 선택 화면 연결 지점.
  final ValueChanged<int>? onMusicPressed;

  /// 실제 장소 선택 화면 연결 지점.
  final ValueChanged<int>? onPlacePressed;

  @override
  State<PollAddBox> createState() => _PollAddBoxState();
}

class _PollAddBoxState extends State<PollAddBox> {
  PollOptionType _selectedType = PollOptionType.text;

  final List<_PollOptionDraft> _items = [];
  int _nextId = 0;

  @override
  void initState() {
    super.initState();

    final count = widget.initialOptionCount < 0 ? 0 : widget.initialOptionCount;

    for (var i = 0; i < count; i++) {
      _items.add(_createDraft());
    }

    _notifyChanged();
  }

  @override
  void dispose() {
    for (final item in _items) {
      item.controller.dispose();
    }
    super.dispose();
  }

  _PollOptionDraft _createDraft() {
    return _PollOptionDraft(id: _nextId++, controller: TextEditingController());
  }

  void _changeType(PollOptionType type) {
    if (_selectedType == type) {
      return;
    }

    setState(() {
      _selectedType = type;
    });

    // 타입을 잘못 눌렀다가 돌아오는 경우를 고려해
    // 기존 입력값은 임의로 삭제하지 않는다.
    _notifyChanged();
  }

  void _addItem() {
    setState(() {
      _items.add(_createDraft());
    });

    _notifyChanged();
  }

  void _deleteItem(int index) {
    final removedItem = _items[index];

    setState(() {
      _items.removeAt(index);
    });

    removedItem.controller.dispose();
    _notifyChanged();
  }

  void _reorderItem(int oldIndex, int newIndex) {
    setState(() {
      final movedItem = _items.removeAt(oldIndex);
      _items.insert(newIndex, movedItem);
    });

    _notifyChanged();
  }

  void _notifyChanged() {
    widget.onChanged?.call(
      _selectedType,
      _items
          .map(
            (item) => PollOptionValue(id: item.id, value: item.controller.text),
          )
          .toList(growable: false),
    );
  }

  void _handleTrailingPressed(int index) {
    switch (_selectedType) {
      case PollOptionType.text:
        return;
      case PollOptionType.date:
        widget.onDatePressed?.call(index);
        return;
      case PollOptionType.music:
        widget.onMusicPressed?.call(index);
        return;
      case PollOptionType.place:
        widget.onPlacePressed?.call(index);
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x16),
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
        child: Column(
          children: [
            _PollTypeSelector(
              selectedType: _selectedType,
              onChanged: _changeType,
            ),
            const SizedBox(height: AppSpacing.x12),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: _items.length,
              onReorderItem: _reorderItem,
              proxyDecorator: (child, index, animation) {
                return Material(type: MaterialType.transparency, child: child);
              },
              itemBuilder: (context, index) {
                final item = _items[index];

                return Padding(
                  key: ValueKey<int>(item.id),
                  padding: EdgeInsets.only(
                    bottom: index == _items.length - 1 ? 0 : AppSpacing.x8,
                  ),
                  child: _PollOptionRow(
                    index: index,
                    type: _selectedType,
                    controller: item.controller,
                    onChanged: (_) => _notifyChanged(),
                    onDelete: () => _deleteItem(index),
                    onTrailingPressed: () => _handleTrailingPressed(index),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.x20),
            _PollAddButton(onPressed: _addItem),
          ],
        ),
      ),
    );
  }
}

class _PollTypeSelector extends StatelessWidget {
  const _PollTypeSelector({
    required this.selectedType,
    required this.onChanged,
  });

  final PollOptionType selectedType;
  final ValueChanged<PollOptionType> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: AppSpacing.x8,
        runSpacing: AppSpacing.x8,
        children: PollOptionType.values
            .map((type) {
              final isSelected = selectedType == type;

              return Semantics(
                button: true,
                selected: isSelected,
                label: '${type.label} 투표 항목',
                child: InkWell(
                  onTap: () => onChanged(type),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x10,
                      vertical: AppSpacing.x4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.primary.withValues(alpha: 0.12)
                          : colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: isSelected
                            ? colors.primary
                            : context.grays.gray5,
                      ),
                    ),
                    child: Text(
                      type.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? colors.primary
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class _PollOptionRow extends StatelessWidget {
  const _PollOptionRow({
    required this.index,
    required this.type,
    required this.controller,
    required this.onChanged,
    required this.onDelete,
    required this.onTrailingPressed,
  });

  final int index;
  final PollOptionType type;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onDelete;
  final VoidCallback onTrailingPressed;

  @override
  Widget build(BuildContext context) {
    final trailingIconPath = type.trailingIconPath;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ReorderableDragStartListener(
          index: index,
          child: Semantics(
            label: '${index + 1}번째 투표 항목 순서 변경',
            child: const SizedBox(
              width: 24,
              height: 44,
              child: Center(child: _DragDots()),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: PostTextField(
            hintText: type.hintText,
            controller: controller,
            onChanged: onChanged,
            height: 45,
            suffixIconPath: trailingIconPath,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        _PollDeleteButton(
          semanticLabel: '${index + 1}번째 투표 항목 삭제',
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class _DragDots extends StatelessWidget {
  const _DragDots();

  @override
  Widget build(BuildContext context) {
    final dotColor = context.grays.gray5;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.x4),
      width: 45.0,
      decoration: BoxDecoration(
        color: context.grays.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Center(child: SvgPicture.asset('assets/icons/post/move.svg')),
    );
  }
}

class _DragDot extends StatelessWidget {
  const _DragDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const SizedBox(width: 3, height: 3),
    );
  }
}

class _PollTrailingButton extends StatelessWidget {
  const _PollTrailingButton({
    required this.semanticLabel,
    required this.iconPath,
    required this.onPressed,
  });

  final String semanticLabel;
  final String iconPath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                context.grays.gray4,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PollDeleteButton extends StatelessWidget {
  const _PollDeleteButton({
    required this.semanticLabel,
    required this.onPressed,
  });

  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox(
          width: 24,
          height: 44,
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/post/delete.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                context.grays.gray6,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PollAddButton extends StatelessWidget {
  const _PollAddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '투표 항목 추가',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          width: 34,
          height: 34,
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: const CircleBorder(),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/post/plus.svg',
              colorFilter: ColorFilter.mode(
                context.grays.gray6,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PollOptionDraft {
  const _PollOptionDraft({required this.id, required this.controller});

  final int id;
  final TextEditingController controller;
}
