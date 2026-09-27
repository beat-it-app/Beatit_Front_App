import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_upload_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';

class PostCreatePage extends ConsumerStatefulWidget {
  const PostCreatePage({super.key});

  @override
  ConsumerState<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends ConsumerState<PostCreatePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _musicController = TextEditingController();
  final _fileController = TextEditingController();
  final List<XFile> _images = [];
  bool _submitting = false;

  void _unsupported() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('공지 API는 날짜·시간·음원·파일 저장을 지원하지 않습니다.')),
    );
  }

  Future<void> _pickImages() async {
    final selected = await ImagePicker().pickMultiImage();
    if (mounted) {
      setState(() {
        _images
          ..clear()
          ..addAll(selected);
      });
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('제목과 내용을 입력해주세요.')));
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref
          .read(postApiProvider)
          .createNotice(
            title: title,
            content: content,
            imagePaths: _images.map((image) => image.path).toList(),
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _titleController,
      _contentController,
      _dateController,
      _startController,
      _endController,
      _musicController,
      _fileController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.closeOnly(
        onClosePressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x4,
            horizontal: AppSpacing.x16,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: '공지 제목',
                        requiredMark: true,
                        hintText: '제목',
                        controller: _titleController,
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '내용',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      AppTextArea(
                        hintText: '공지 글을 작성해주세요.',
                        controller: _contentController,
                        maxLength: 500,
                        fieldHeight: 200,
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(text: '사진 등록', color: colors.onSurface),
                      const SizedBox(height: AppSpacing.x8),
                      AppUploadButton(
                        onPressed: _pickImages,
                        text: _images.isEmpty
                            ? '사진 등록하기'
                            : '사진 ${_images.length}장 선택됨',
                      ),

                      const SizedBox(height: AppSpacing.x16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),

              AppButton(
                text: '생성하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.black,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 34.0,
        width: 34.0,
        decoration: ShapeDecoration(
          color: context.grays.gray8,
          shape: OvalBorder(),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/cal/plus.svg',
            width: 24.0,
            height: 24.0,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel({
    required this.text,
    required this.color,
    this.requiredColor = Colors.transparent,
  });

  final String text;
  final Color color;
  final Color requiredColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: color),
          children: [
            TextSpan(text: text),
            if (requiredColor != null)
              TextSpan(
                text: ' *',
                style: TextStyle(color: requiredColor),
              ),
          ],
        ),
      ),
    );
  }
}
