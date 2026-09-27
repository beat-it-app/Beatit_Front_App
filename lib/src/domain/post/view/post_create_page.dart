import 'dart:io';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_upload_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class PostCreatePage extends ConsumerStatefulWidget {
  const PostCreatePage({super.key});

  @override
  ConsumerState<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends ConsumerState<PostCreatePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final List<XFile> _images = [];

  int? _pendingDeleteImageIndex;
  bool _submitting = false;

  Future<void> _pickImages() async {
    final selected = await ImagePicker().pickMultiImage();
    if (!mounted || selected.isEmpty) return;

    setState(() {
      final existingPaths = _images.map((image) => image.path).toSet();
      for (final image in selected) {
        if (existingPaths.add(image.path)) {
          _images.add(image);
        }
      }
      _pendingDeleteImageIndex = null;
    });
  }

  void _handleImageTap(int index) {
    if (_pendingDeleteImageIndex == index) {
      setState(() {
        _images.removeAt(index);
        _pendingDeleteImageIndex = null;
      });
      return;
    }

    setState(() => _pendingDeleteImageIndex = index);
  }

  Future<void> _handleClose() async {
    final confirmed = await AppPopup.show(
      context,
      title: '작성을 중단하시겠습니까?',
      content: '중단 시, 작성된 내용은\n저장되지 않습니다.',
      buttonNum: ButtonNum.two,
      warningType: WarningType.circle,
      contentType: ContentType.small,
      confirmText: '확인',
      cancelText: '취소',
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).maybePop();
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
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.closeOnly(onClosePressed: _handleClose),
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
                        onChanged: (_) {},
                      ),
                      const SizedBox(height: AppSpacing.x20),
                      _RequiredLabel(
                        text: '내용',
                        color: colors.onSurface,
                        requiredColor: colors.error,
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
                      AppUploadButton(onPressed: _pickImages, text: '사진 등록하기'),
                      if (_images.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.x12),
                        ...List.generate(
                          _images.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == _images.length - 1
                                  ? 0
                                  : AppSpacing.x8,
                            ),
                            child: _PostImagePreview(
                              image: _images[index],
                              pendingDelete: _pendingDeleteImageIndex == index,
                              onTap: () => _handleImageTap(index),
                            ),
                          ),
                        ),
                      ],
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
                onPressed: _submitting ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostImagePreview extends StatelessWidget {
  const _PostImagePreview({
    required this.image,
    required this.pendingDelete,
    required this.onTap,
  });

  final XFile image;
  final bool pendingDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: pendingDelete ? '사진 삭제' : '사진 삭제 선택',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.file(
                File(image.path),
                width: double.infinity,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 180,
                  color: colors.errorContainer,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colors.onErrorContainer,
                  ),
                ),
              ),
              if (pendingDelete) ...[
                Positioned.fill(
                  child: ColoredBox(
                    color: context.grays.white.withValues(alpha: 0.4),
                  ),
                ),
                Container(
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
              ],
            ],
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
    this.requiredColor,
  });

  final String text;
  final Color color;
  final Color? requiredColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: FontStyles.semi16.copyWith(color: color),
          children: [
            TextSpan(text: text),
            if (requiredColor != null)
              TextSpan(
                text: ' *',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: requiredColor),
              ),
          ],
        ),
      ),
    );
  }
}
