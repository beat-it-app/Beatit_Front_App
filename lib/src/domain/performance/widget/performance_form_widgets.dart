import 'dart:io';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/bottomsheets/app_time_bottomsheet.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_upload_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class PerformanceFormLabel extends StatelessWidget {
  const PerformanceFormLabel(this.text, {super.key, this.requiredMark = false});

  final String text;
  final bool requiredMark;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.x8),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text),
          if (requiredMark)
            TextSpan(
              text: ' *',
              style: FontStyles.semi16.copyWith(
                color: context.brands.beatOrange1,
              ),
            ),
        ],
      ),
      style: FontStyles.semi16.copyWith(color: context.grays.black),
    ),
  );
}

class PerformanceDateTimeField extends StatelessWidget {
  const PerformanceDateTimeField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onTap,
    this.errorText,
  });

  final String hintText;
  final TextEditingController controller;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) => AppTextField(
    hintText: hintText,
    controller: controller,
    readOnly: true,
    onTap: onTap,
    errorText: errorText,
    suffixIcon: SvgPicture.asset(
      'assets/icons/core/calendar.svg',
      colorFilter: ColorFilter.mode(context.grays.gray5, BlendMode.srcIn),
      width: 20,
      height: 20,
    ),
  );
}

class PerformanceDateTimePicker {
  const PerformanceDateTimePicker._();

  static Future<DateTime?> pick(
    BuildContext context, {
    required String title,
    DateTime? initial,
  }) async {
    FocusScope.of(context).unfocus();
    final date = await AppTimeBottomSheet.showDatePicker(
      context,
      title: '$title 날짜 선택',
      initialDate: initial ?? DateTime.now(),
      startYear: 2020,
      maxDate: DateTime(2035, 12, 31),
    );
    if (date == null || !context.mounted) return null;

    final time = await AppTimeBottomSheet.showTimePicker(
      context,
      title: '$title 시간 선택',
      initialTime: initial == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !context.mounted) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// Cal의 날짜 표시를 유지하고 시간만 24시간제로 표현한다.
  static String format(DateTime value) =>
      '${value.year}. ${value.month}. ${value.day}. '
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}

/// PostCreatePage의 '사진 터치 -> 삭제 오버레이 -> 삭제' 동작을 공연용으로 사용한다.
/// 위젯이 선택 상태만 가지며, 실제 파일 목록은 부모 페이지에서 관리한다.
class PerformanceImagePicker extends StatefulWidget {
  const PerformanceImagePicker({
    super.key,
    required this.images,
    required this.maxImages,
    required this.onAdd,
    required this.onRemove,
  });

  final List<XFile> images;
  final int maxImages;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  State<PerformanceImagePicker> createState() => _PerformanceImagePickerState();
}

class _PerformanceImagePickerState extends State<PerformanceImagePicker> {
  String? _pendingDeletePath;

  @override
  void didUpdateWidget(covariant PerformanceImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_pendingDeletePath != null &&
        !widget.images.any((image) => image.path == _pendingDeletePath)) {
      _pendingDeletePath = null;
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var index = 0; index < widget.images.length; index++) ...[
        _PerformanceImagePreview(
          key: ValueKey(widget.images[index].path),
          image: widget.images[index],
          pendingDelete: _pendingDeletePath == widget.images[index].path,
          onTap: () => setState(() {
            final path = widget.images[index].path;
            _pendingDeletePath = _pendingDeletePath == path ? null : path;
          }),
          onRemove: () {
            setState(() => _pendingDeletePath = null);
            widget.onRemove(index);
          },
        ),
        const SizedBox(height: AppSpacing.x8),
      ],
      if (widget.images.length < widget.maxImages)
        AppUploadButton(
          onPressed: widget.onAdd,
          text: widget.maxImages == 1 ? '사진 등록하기' : '이미지 등록하기',
        ),
    ],
  );
}

class _PerformanceImagePreview extends StatelessWidget {
  const _PerformanceImagePreview({
    super.key,
    required this.image,
    required this.pendingDelete,
    required this.onTap,
    required this.onRemove,
  });

  final XFile image;
  final bool pendingDelete;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(AppRadius.lg),
    child: Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Image.file(
            File(image.path),
            width: double.infinity,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) => Container(
              width: double.infinity,
              height: 180,
              color: context.colors.errorContainer,
              alignment: Alignment.center,
              child: Icon(
                Icons.image_not_supported_outlined,
                color: context.colors.onErrorContainer,
              ),
            ),
          ),
        ),
        if (pendingDelete) ...[
          Positioned.fill(
            child: IgnorePointer(
              child: ColoredBox(
                color: context.grays.white.withValues(alpha: 0.4),
              ),
            ),
          ),
          Semantics(
            button: true,
            label: '사진 삭제',
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.grays.gray3,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/post/waste.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    context.grays.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
