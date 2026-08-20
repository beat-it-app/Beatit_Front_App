import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/toggles/app_toggle.dart';
import 'package:beatit_front_app/src/domain/post/widget/poll_add_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PollCreatePage extends StatefulWidget {
  const PollCreatePage({super.key});

  @override
  State<PollCreatePage> createState() => _PollCreatePageState();
}

class _PollCreatePageState extends State<PollCreatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  final Set<String> _voteSelectedOptions = {};
  final List<String> _voteOptions = ['익명 투표', '중복 투표'];

  PollOptionType _pollOptionType = PollOptionType.text;
  List<PollOptionValue> _pollOptions = const [];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  void _handlePollOptionsChanged(
    PollOptionType type,
    List<PollOptionValue> options,
  ) {
    _pollOptionType = type;
    _pollOptions = options;
  }

  void _handleDatePressed(int index) {
    debugPrint('$index 번째 날짜 선택 버튼 클릭');
    // TODO: DatePicker/BottomSheet 연결 후 해당 항목의 값을 반영한다.
  }

  void _handleMusicPressed(int index) {
    debugPrint('$index 번째 음원 선택 버튼 클릭');
    // TODO: 음원 선택 화면/BottomSheet 연결.
  }

  void _handlePlacePressed(int index) {
    debugPrint('$index 번째 장소 선택 버튼 클릭');
    // TODO: 장소 검색 화면/BottomSheet 연결.
  }

  void _submitPoll() {
    debugPrint('투표 제목: ${_titleController.text}');
    debugPrint('투표 내용: ${_contentController.text}');
    debugPrint('투표 타입: ${_pollOptionType.name}');
    debugPrint(
      '투표 항목: ${_pollOptions.map((option) => option.value).toList()}',
    );
    debugPrint('마감 시간: ${_deadlineController.text}');
    debugPrint('투표 옵션: $_voteSelectedOptions');

    // TODO: 투표 생성 API 연결.
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
                      const SizedBox(height: AppSpacing.x20),
                      AppTextField(
                        label: '투표 제목',
                        requiredMark: true,
                        hintText: '제목',
                        controller: _titleController,
                        onChanged: (_) {},
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '내용',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      AppTextArea(
                        hintText: '투표 내용을 작성해주세요.',
                        controller: _contentController,
                        maxLength: 500,
                        fieldHeight: 200,
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '투표란',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      PollAddBox(
                        onChanged: _handlePollOptionsChanged,
                        onDatePressed: _handleDatePressed,
                        onMusicPressed: _handleMusicPressed,
                        onPlacePressed: _handlePlacePressed,
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '투표 마감 시간 설정',
                        color: colors.onSurface,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      AppTextField(
                        hintText: '투표 마감 시간을 설정하세요.',
                        controller: _deadlineController,
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/post/clock.svg',
                        ),
                        onChanged: (_) {},
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '투표 옵션',
                        color: colors.onSurface,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      Wrap(
                        spacing: AppSpacing.x8,
                        runSpacing: AppSpacing.x8,
                        alignment: WrapAlignment.start,
                        children: _voteOptions.map((option) {
                          return AppToggle(
                            text: option,
                            isSelected: _voteSelectedOptions.contains(option),
                            onChanged: (bool isSelected) {
                              setState(() {
                                if (isSelected) {
                                  _voteSelectedOptions.add(option);
                                } else {
                                  _voteSelectedOptions.remove(option);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppSpacing.x16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              AppButton(
                text: '등록하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.black,
                onPressed: _submitPoll,
              ),
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
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: color),
          children: [
            TextSpan(text: text),
            if (requiredColor != null)
              TextSpan(
                text: ' *',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: requiredColor,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
