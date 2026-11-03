// lib/src/domain/performance/view/performance_invitation_page.dart

import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/etc/model/music_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/view/music_search_page.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:beatit_front_app/src/domain/performance/widget/progress_bar_widget.dart';

class PerformanceInvitationPage extends ConsumerStatefulWidget {
  const PerformanceInvitationPage({
    super.key,
    required this.step1,
    required this.detailImages,
    required this.detailDescription,
    required this.hasNoDetails,
    this.editTarget,
    this.retainDetailFileIds = const [],
    this.deleteDetailFileIds = const [],
    this.deletePosterImage = false,
  });

  final PerformanceInformation step1;
  final List<XFile> detailImages;
  final String detailDescription;
  final bool hasNoDetails;

  final PerformanceDetailModel? editTarget;
  final List<int> retainDetailFileIds;
  final List<int> deleteDetailFileIds;
  final bool deletePosterImage;

  @override
  ConsumerState<PerformanceInvitationPage> createState() =>
      _PerformanceInvitationPageState();
}

class _PerformanceInvitationPageState
    extends ConsumerState<PerformanceInvitationPage> {
  final _teamName = TextEditingController();
  final _description = TextEditingController();

  bool _enableSetlist = true;
  int _selectedTeamIndex = 0;
  final List<_TeamGroup> _teams = [];
  bool _isLoading = false;

  bool get _isEditMode => widget.editTarget != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _prefillInvitationData();
    } else {
      _teamName.text = widget.step1.hostName;
      _teams.add(_TeamGroup(name: '알사탕')..addMusic());
    }
  }

  void _prefillInvitationData() {
    final detail = widget.editTarget!.toDetailData();
    _teamName.text = detail.hostName;
    _description.text = detail.introduction;

    if (_teams.isEmpty) {
      _teams.add(_TeamGroup(name: detail.hostName)..addMusic());
    }
  }

  void _addTeam() {
    setState(() {
      final newTeam = _TeamGroup(name: '${_teams.length + 1}팀');
      newTeam.addMusic();
      _teams.add(newTeam);
      _selectedTeamIndex = _teams.length - 1;
    });
  }

  @override
  void dispose() {
    _teamName.dispose();
    _description.dispose();
    for (final t in _teams) {
      t.dispose();
    }
    super.dispose();
  }

  // 💡 X 버튼 클릭 시 작성 중단 확인 팝업 (1, 2, 3단계 3개 pop하여 시작 전으로 복귀)
  Future<void> _handleCloseConfirmation() async {
    final confirmed = await AppPopup.show(
      context,
      title: '작성을 중단하시겠습니까?',
      content: '중단 시, 작성된 내용은\n저장되지 않습니다.',
      warningType: WarningType.circle,
      buttonNum: ButtonNum.two,
      confirmText: '나가기',
      cancelText: '계속 작성',
    );

    if (confirmed == true && mounted) {
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 3);
    }
  }

  Future<void> _selectMusic(_MusicEntry music) async {
    FocusScope.of(context).unfocus();
    final selected = await Navigator.of(context).push<MusicSearchResult>(
      MaterialPageRoute(
        builder: (_) => const MusicSearchPage(returnOnSelect: true),
      ),
    );

    if (selected != null && mounted) {
      setState(() {
        music.musicTitle.text = selected.title;
        music.musicArtist.text = selected.artist;
      });
    }
  }

  String _formatOffsetDateTime(DateTime dt) {
    final offset = dt.timeZoneOffset;
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final sign = offset.isNegative ? '-' : '+';
    final offsetStr = '$sign$hours:$minutes';

    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final sec = dt.second.toString().padLeft(2, '0');

    return '$y-$m-${d}T$h:$min:$sec$offsetStr';
  }

  // 💡 티켓 목록 매핑 헬퍼 (onsite, general, advance, free 모두 정상 매핑)
  List _buildPriceList() {
    return widget.step1.ticketTypes.map((type) {
      final priceStr = widget.step1.ticketPrices[type] ?? '0';

      String priceType;
      switch (type) {
        case PerformanceTicketType.advance:
          priceType = 'ADVANCE';
          break;
        case PerformanceTicketType.onsite:
          priceType = 'ON_SITE'; // 💡 현장 예매를 정확히 ON_SITE로 매핑
          break;
        case PerformanceTicketType.general:
          priceType = 'ON_SITE'; // 일반 예매도 현장/일반 정책에 맞춰 매핑
          break;
        case PerformanceTicketType.free:
        default:
          priceType = 'FREE';
          break;
      }

      return {
        'priceType': priceType,
        'price': type == PerformanceTicketType.free
            ? 0
            : (int.tryParse(priceStr) ?? 0),
      };
    }).toList();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_teamName.text.trim().isEmpty || _description.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('필수 정보를 모두 입력해주세요.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = ref.read(dioProvider);

      if (_isEditMode) {
        await _updatePerformance(dio);
      } else {
        await _createPerformance(dio);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditMode ? '공연이 수정되었습니다.' : '공연이 등록되었습니다.')),
      );

      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 3);
    } catch (e) {
      if (!mounted) return;

      String errorMessage = e.toString();
      if (e is DioException && e.response != null) {
        debugPrint('❌ [Server Response]: ${e.response?.data}');
        final resData = e.response?.data;
        if (resData is Map<String, dynamic>) {
          errorMessage =
              resData['message']?.toString() ??
              resData['error']?.toString() ??
              resData.toString();
        } else {
          errorMessage = resData.toString();
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode ? '공연 수정 실패: $errorMessage' : '공연 등록 실패: $errorMessage',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List _buildFormattedSetlist() {
    if (!_enableSetlist) return [];

    final List list = [];
    for (final team in _teams) {
      final teamName = team.nameController.text.trim().isEmpty
          ? team.name
          : team.nameController.text.trim();

      final musics = [];
      for (final m in team.musics) {
        final title = m.musicTitle.text.trim();
        final artist = m.musicArtist.text.trim();
        if (title.isNotEmpty || artist.isNotEmpty) {
          musics.add({
            'musicTitle': title.isEmpty ? '미정' : title,
            'musicArtist': artist.isEmpty ? '미정' : artist,
            'description': m.description.text.trim(),
          });
        }
      }

      if (musics.isNotEmpty) {
        list.add({'teamName': teamName, 'musics': musics});
      }
    }
    return list;
  }

  Future<void> _updatePerformance(Dio dio) async {
    final publicId = widget.editTarget!.performancePublicId;
    final formattedSetlist = _buildFormattedSetlist();

    final retainUrls = widget.editTarget!.detailImages
        .where((e) => widget.retainDetailFileIds.contains(e.fileId))
        .map((e) => e.cdnUrl)
        .toList();

    final requestMap = <String, dynamic>{
      'title': widget.step1.title,
      'description': widget.step1.introduction,
      'performanceDateTime': _formatOffsetDateTime(widget.step1.startsAt),
      'locationId': widget.step1.location.locationId ?? 1,
      'placeName':
          widget.step1.location.locationName ??
          widget.step1.location.roadAddress ??
          widget.editTarget!.placeName,
      'prices': _buildPriceList(), // 💡 수정됨
      'bookingDeadline': widget.step1.bookingClosesAt != null
          ? _formatOffsetDateTime(widget.step1.bookingClosesAt!)
          : null,
      'bookingLink': widget.step1.bookingUrl.isNotEmpty
          ? widget.step1.bookingUrl
          : null,
      'hostName': widget.step1.hostName,
      'hostContact':
          widget.step1.hostContactType == PerformanceHostContactType.phone
          ? widget.step1.hostContact
          : null,
      'hostLink':
          widget.step1.hostContactType == PerformanceHostContactType.link
          ? widget.step1.hostContact
          : null,
      'detailInfo': widget.detailDescription,
      'invitationCard': {
        'performanceTeam': _teamName.text.trim(),
        'description': _description.text.trim(),
        'setlist': formattedSetlist,
      },
      'retainDetailFileIds': widget.retainDetailFileIds,
      'retainDetailImageUrls': retainUrls,
      'deleteDetailFileIds': widget.deleteDetailFileIds,
      'deletePosterImage': widget.deletePosterImage,
    };

    final formData = FormData();
    formData.files.add(
      MapEntry(
        'request',
        MultipartFile.fromString(
          jsonEncode(requestMap),
          contentType: DioMediaType('application', 'json'),
        ),
      ),
    );

    if (widget.step1.poster != null) {
      formData.files.add(
        MapEntry(
          'posterImage',
          await MultipartFile.fromFile(
            widget.step1.poster!.path,
            filename: widget.step1.poster!.name,
          ),
        ),
      );
    }

    for (final image in widget.detailImages) {
      formData.files.add(
        MapEntry(
          'detailImages',
          await MultipartFile.fromFile(image.path, filename: image.name),
        ),
      );
    }

    await dio.patch('/performances/$publicId', data: formData);
  }

  Future<void> _createPerformance(Dio dio) async {
    final formattedSetlist = _buildFormattedSetlist();

    final requestMap = <String, dynamic>{
      'title': widget.step1.title,
      'description': widget.step1.introduction,
      'performanceDateTime': _formatOffsetDateTime(widget.step1.startsAt),
      'locationId': widget.step1.location.locationId ?? 1,
      'placeName':
          widget.step1.location.locationName ??
          widget.step1.location.roadAddress ??
          '',
      'prices': _buildPriceList(), // 💡 수정됨
      'bookingDeadline': widget.step1.bookingClosesAt != null
          ? _formatOffsetDateTime(widget.step1.bookingClosesAt!)
          : null,
      'bookingLink': widget.step1.bookingUrl.isNotEmpty
          ? widget.step1.bookingUrl
          : null,
      'hostName': widget.step1.hostName,
      'hostContact':
          widget.step1.hostContactType == PerformanceHostContactType.phone
          ? widget.step1.hostContact
          : null,
      'hostLink':
          widget.step1.hostContactType == PerformanceHostContactType.link
          ? widget.step1.hostContact
          : null,
      'detailInfo': widget.detailDescription,
      'invitationCard': {
        'performanceTeam': _teamName.text.trim(),
        'description': _description.text.trim(),
        'setlist': formattedSetlist,
      },
    };

    final formData = FormData();
    formData.files.add(
      MapEntry(
        'request',
        MultipartFile.fromString(
          jsonEncode(requestMap),
          contentType: DioMediaType('application', 'json'),
        ),
      ),
    );

    if (widget.step1.poster != null) {
      formData.files.add(
        MapEntry(
          'posterImage',
          await MultipartFile.fromFile(
            widget.step1.poster!.path,
            filename: widget.step1.poster!.name,
          ),
        ),
      );
    }

    for (final image in widget.detailImages) {
      formData.files.add(
        MapEntry(
          'detailImages',
          await MultipartFile.fromFile(image.path, filename: image.name),
        ),
      );
    }

    await dio.post('/performances', data: formData);
  }

  @override
  Widget build(BuildContext context) {
    final currentTeam = _teams.isNotEmpty && _selectedTeamIndex < _teams.length
        ? _teams[_selectedTeamIndex]
        : null;

    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: AppTopAppBar.backClose(
        onBackPressed: () => Navigator.of(context).pop(),
        onClosePressed: _handleCloseConfirmation,
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    const PerformanceProgressBar(step: 3),
                    const SizedBox(height: AppSpacing.x20),
                    AppTextField(
                      label: '팀 이름',
                      requiredMark: true,
                      controller: _teamName,
                      hintText: '공연에 참여하는 팀 이름을 작성해주세요.',
                    ),
                    const SizedBox(height: AppSpacing.x20),
                    AppTextArea(
                      label: '초대글',
                      requiredMark: true,
                      controller: _description,
                      hintText: '공연 초대글을 작성해주세요.',
                      maxLength: 1000,
                      fieldHeight: 140,
                    ),
                    const SizedBox(height: AppSpacing.x28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '셋리스트',
                          style: FontStyles.bold20.copyWith(
                            color: context.grays.black,
                          ),
                        ),
                        CupertinoSwitch(
                          value: _enableSetlist,
                          activeColor: context.brands.beatOrange1,
                          onChanged: (val) {
                            setState(() => _enableSetlist = val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      '셋리스트는 모바일 초대장을 통해서만 볼 수 있습니다.',
                      style: FontStyles.reg14.copyWith(
                        color: context.grays.gray4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x16),

                    if (_enableSetlist && currentTeam != null) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ..._teams.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final isSelected = idx == _selectedTeamIndex;

                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedTeamIndex = idx),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF2A2A2A)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF2A2A2A)
                                          : context.grays.gray5,
                                    ),
                                  ),
                                  child: Text(
                                    '${idx + 1}팀',
                                    style: FontStyles.med14.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : context.grays.black,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            GestureDetector(
                              onTap: _addTeam,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: context.brands.beatOrange1,
                                  ),
                                ),
                                child: Text(
                                  '+ 팀 추가',
                                  style: FontStyles.med14.copyWith(
                                    color: context.brands.beatOrange1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x16),

                      Container(
                        padding: const EdgeInsets.all(AppSpacing.x16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '팀 이름',
                              style: FontStyles.med15.copyWith(
                                color: context.grays.black,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x8),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: currentTeam.nameController,
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  hintText: '팀 이름을 입력해 주세요.',
                                  hintStyle: FontStyles.reg16.copyWith(
                                    color: context.grays.gray5,
                                  ),
                                  border: InputBorder.none,
                                  filled: false,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                ),
                                style: FontStyles.med16.copyWith(
                                  color: context.grays.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x20),

                            Text(
                              '음원',
                              style: FontStyles.med15.copyWith(
                                color: context.grays.black,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x8),

                            ReorderableListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              buildDefaultDragHandles: false,
                              itemCount: currentTeam.musics.length,
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) newIndex -= 1;
                                  final item = currentTeam.musics.removeAt(
                                    oldIndex,
                                  );
                                  currentTeam.musics.insert(newIndex, item);
                                });
                              },
                              itemBuilder: (context, mIdx) {
                                final music = currentTeam.musics[mIdx];
                                return _buildMusicEntryCard(
                                  key: ValueKey(music),
                                  music: music,
                                  index: mIdx,
                                  onSelectMusic: () => _selectMusic(music),
                                  onDelete: () {
                                    setState(() {
                                      currentTeam.removeMusic(mIdx);
                                    });
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: AppSpacing.x16),

                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentTeam.addMusic();
                                  });
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: context.grays.gray4,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.x24),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.x16),
                child: AppButton(
                  text: _isLoading
                      ? '저장 중...'
                      : _isEditMode
                      ? '수정 완료'
                      : '작성 완료',
                  onPressed: _isLoading ? () {} : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMusicEntryCard({
    required Key key,
    required _MusicEntry music,
    required int index,
    required VoidCallback onSelectMusic,
    required VoidCallback onDelete,
  }) {
    final hasMusic = music.musicTitle.text.trim().isNotEmpty;

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: Container(
                  width: 44,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.drag_indicator,
                      color: context.grays.gray4,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onSelectMusic,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: hasMusic
                                ? Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          music.musicTitle.text,
                                          style: FontStyles.med15.copyWith(
                                            color: context.grays.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (music
                                          .musicArtist
                                          .text
                                          .isNotEmpty) ...[
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            music.musicArtist.text,
                                            style: FontStyles.reg14.copyWith(
                                              color: context.grays.gray4,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ],
                                  )
                                : Text(
                                    '음원을 선택하세요.',
                                    style: FontStyles.reg16.copyWith(
                                      color: context.grays.gray5,
                                    ),
                                  ),
                          ),
                        ),
                        if (!hasMusic)
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: SvgPicture.asset(
                              'assets/icons/performance/performance.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              _DeleteCircleButton(onTap: onDelete),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    controller: music.description,
                    maxLines: null,
                    minLines: 1,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      hintText: '설명을 작성해주세요.',
                      hintStyle: FontStyles.reg16.copyWith(
                        color: context.grays.gray5,
                      ),
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                    style: FontStyles.reg15.copyWith(
                      color: context.grays.black,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              _DeleteCircleButton(
                onTap: () {
                  setState(() {
                    music.description.clear();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeleteCircleButton extends StatelessWidget {
  const _DeleteCircleButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: Color(0xFFD3D3D3),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.close, size: 16, color: Colors.white),
      ),
    );
  }
}

class _TeamGroup {
  _TeamGroup({required this.name}) {
    nameController = TextEditingController(text: name);
  }

  final String name;
  late final TextEditingController nameController;
  final List<_MusicEntry> musics = [];

  void addMusic() {
    musics.add(_MusicEntry());
  }

  void removeMusic(int index) {
    if (musics.length <= 1) {
      musics[0].clear();
      return;
    }
    final removed = musics.removeAt(index);
    removed.dispose();
  }

  void dispose() {
    nameController.dispose();
    for (final m in musics) {
      m.dispose();
    }
  }
}

class _MusicEntry {
  final musicTitle = TextEditingController();
  final musicArtist = TextEditingController();
  final description = TextEditingController();

  void clear() {
    musicTitle.clear();
    musicArtist.clear();
    description.clear();
  }

  void dispose() {
    musicTitle.dispose();
    musicArtist.dispose();
    description.dispose();
  }
}
