import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/toggles/app_toggle.dart';
import 'package:beatit_front_app/src/domain/post/widget/poll_add_box.dart';
import 'package:beatit_front_app/src/domain/post/model/post_detail_models.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_api_provider.dart';
import 'package:beatit_front_app/src/domain/etc/view/music_search_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_search_page.dart';
import 'package:beatit_front_app/src/domain/etc/model/music_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PollCreatePage extends ConsumerStatefulWidget {
  const PollCreatePage({super.key});

  @override
  ConsumerState<PollCreatePage> createState() => _PollCreatePageState();
}

class _PollCreatePageState extends ConsumerState<PollCreatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  final _optionKey = GlobalKey<PollAddBoxState>();
  final Map<int, MusicSearchResult> _musicChoices = {};
  final Map<int, LocationData> _placeChoices = {};
  DateTime? _closeAt;
  bool _submitting = false;
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

  void _handlePollOptionsChanged(PollOptionType type, List<PollOptionValue> options) {
    if (type != _pollOptionType) {
      _musicChoices.clear();
      _placeChoices.clear();
    }
    _pollOptionType = type;
    _pollOptions = options;
  }

  Future<void> _handleMusicPressed(int index) async {
    final id = _pollOptions[index].id;
    final chosen = await Navigator.of(context).push<MusicSearchResult>(
      MaterialPageRoute(builder: (_) => const MusicSearchPage(returnOnSelect: true)));
    if (chosen == null || !mounted) return;
    _musicChoices[id] = chosen;
    _optionKey.currentState?.setOptionById(id, '${chosen.title} - ${chosen.artist}');
  }

  Future<void> _handlePlacePressed(int index) async {
    final id = _pollOptions[index].id;
    final chosen = await Navigator.of(context).push<LocationData>(
      MaterialPageRoute(builder: (_) => const LocationSearchPage(returnRegisteredLocationOnSelect: true)));
    if (chosen == null || !mounted) return;
    _placeChoices[id] = chosen;
    _optionKey.currentState?.setOptionById(id, chosen.locationName ?? chosen.roadAddress ?? '장소');
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final date = await showDatePicker(context: context,
      firstDate: now, lastDate: now.add(const Duration(days: 365)), initialDate: _closeAt ?? now);
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context,
      initialTime: _closeAt == null ? TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))) : TimeOfDay.fromDateTime(_closeAt!));
    if (time == null || !mounted) return;
    final deadline = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    if (!deadline.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('투표 마감 시간은 현재 시간 이후로 선택해주세요.')));
      return;
    }
    setState(() {
      _closeAt = deadline;
      _deadlineController.text = '${deadline.year}-${deadline.month.toString().padLeft(2, '0')}-${deadline.day.toString().padLeft(2, '0')} ${time.format(context)}';
    });
  }

  Future<void> _submitPoll() async {
    if (_submitting) return;
    final title = _titleController.text.trim();
    if (title.isEmpty || _pollOptions.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('제목과 투표 항목을 두 개 이상 입력해주세요.')));
      return;
    }
    if (_closeAt == null || !_closeAt!.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('투표 마감 시간은 현재 시간 이후여야 합니다.')));
      return;
    }
    final type = switch (_pollOptionType) {
      PollOptionType.music => 'MUSIC',
      PollOptionType.place => 'LOCATION',
      PollOptionType.text => 'TEXT',
    };
    final options = <PollCreateItem>[];
    for (final option in _pollOptions) {
      final text = option.value.trim();
      if (text.isEmpty || (type == 'MUSIC' && !_musicChoices.containsKey(option.id)) ||
          (type == 'LOCATION' && !_placeChoices.containsKey(option.id))) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('모든 투표 항목을 선택하거나 입력해주세요.')));
        return;
      }
      final music = _musicChoices[option.id];
      final place = _placeChoices[option.id];
      options.add(PollCreateItem(
        content: type == 'TEXT' ? text : null,
        music: type == 'MUSIC' && music != null ? PollCreateMusic(
          title: music.title, artist: music.artist, previewUrl: music.previewUrl) : null,
        location: type == 'LOCATION' ? text : null,
        locationId: type == 'LOCATION' ? place?.locationId : null,
      ));
    }
    setState(() => _submitting = true);
    try {
      await ref.read(postApiProvider).createPoll(PollCreateRequest(
        title: title, content: _contentController.text.trim(), pollType: type,
        pollList: options, allowMultipleChoice: _voteSelectedOptions.contains('중복 투표'),
        isAnonymous: _voteSelectedOptions.contains('익명 투표'),
        remindBeforeClose: false, closeAt: _closeAt,
      ));
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally { if (mounted) setState(() => _submitting = false); }
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
                        key: _optionKey,
                        onChanged: _handlePollOptionsChanged,
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
                        readOnly: true,
                        onTap: _pickDeadline,
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
