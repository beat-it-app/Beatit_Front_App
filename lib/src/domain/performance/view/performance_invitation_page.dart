// lib/src/domain/performance/view/performance_invitation_page.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/domain/performance/api/performance_api.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';
import 'package:beatit_front_app/src/domain/team/provider/current_team_provider.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
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
    this.initialDraft,
  });

  final PerformanceInformation step1;
  final List detailImages;
  final String detailDescription;
  final bool hasNoDetails;

  final PerformanceDetailModel? editTarget;
  final List retainDetailFileIds;
  final List deleteDetailFileIds;
  final bool deletePosterImage;
  final Map? initialDraft;

  @override
  ConsumerState createState() => _PerformanceInvitationPageState();
}

class _PerformanceInvitationPageState
    extends ConsumerState<PerformanceInvitationPage> {
  static const int _maxGroupNameLength = 15;
  static const int _maxMusicDescriptionLength = 50;

  final _teamName = TextEditingController();
  final _description = TextEditingController();

  bool _enableSetlist = true;
  int _selectedTeamIndex = 0;
  int? _pendingDeleteTeamIndex;
  final List _teams = [];
  bool _isLoading = false;
  bool _isPrefillingInvitation = false;
  String? _prefillError;

  bool get _isEditMode => widget.editTarget != null;

  bool get _isFormValid =>
      _teamName.text.trim().isNotEmpty && _description.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _teamName.addListener(_onFieldChanged);
    _description.addListener(_onFieldChanged);

    if (widget.initialDraft != null) {
      _restoreDraft(widget.initialDraft!);
    } else if (_isEditMode) {
      _isPrefillingInvitation = true;
      Future.microtask(_loadInvitationForEdit);
    } else {
      final myTeamName = ref.read(currentTeamProvider).value?.teamName ?? '';
      _teamName.text = myTeamName;
      _teams.add(_TeamGroup()..addMusic());
    }
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  void _unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_pendingDeleteTeamIndex != null && mounted) {
      setState(() => _pendingDeleteTeamIndex = null);
    }
  }

  void _restoreDraft(Map draft) {
    _teamName.text = draft['teamName'] as String? ?? '';
    _description.text = draft['description'] as String? ?? '';
    _enableSetlist = draft['enableSetlist'] as bool? ?? true;
    _selectedTeamIndex = draft['selectedTeamIndex'] as int? ?? 0;

    final savedTeams = draft['teams'] as List? ?? [];
    for (final t in savedTeams) {
      final map = t as Map;
      final group = _TeamGroup(initialName: map['name'] as String? ?? '');
      final musics = map['musics'] as List? ?? [];
      for (final m in musics) {
        final mMap = m as Map;
        final entry = _MusicEntry();
        entry.musicTitle.text = mMap['title'] as String? ?? '';
        entry.musicArtist.text = mMap['artist'] as String? ?? '';
        entry.description.text = mMap['description'] as String? ?? '';
        entry.musicPreviewUrl = mMap['previewUrl'] as String?;
        entry.musicImageUrl = mMap['imageUrl'] as String?;
        group.musics.add(entry);
      }
      if (group.musics.isEmpty) group.addMusic();
      _teams.add(group);
    }

    if (_teams.isEmpty) {
      _teams.add(_TeamGroup()..addMusic());
    }
    if (_selectedTeamIndex >= _teams.length) {
      _selectedTeamIndex = _teams.length - 1;
    }
  }

  void _handleBackWithDraft() {
    _unfocusAll();
    final draft = {
      'teamName': _teamName.text,
      'description': _description.text,
      'enableSetlist': _enableSetlist,
      'selectedTeamIndex': _selectedTeamIndex,
      'teams': _teams.map((item) {
        final t = item as _TeamGroup;
        return {
          'name': t.nameController.text,
          'musics': t.musics.map((mItem) {
            final m = mItem as _MusicEntry;
            return {
              'title': m.musicTitle.text,
              'artist': m.musicArtist.text,
              'description': m.description.text,
              'previewUrl': m.musicPreviewUrl,
              'imageUrl': m.musicImageUrl,
            };
          }).toList(),
        };
      }).toList(),
    };

    Navigator.of(context).pop(draft);
  }

  Future _loadInvitationForEdit() async {
    setState(() {
      _isPrefillingInvitation = true;
      _prefillError = null;
    });
    try {
      final response = await ref
          .read(performanceApiProvider)
          .getPerformanceInvitation(widget.editTarget!.performancePublicId);
      if (!mounted) return;
      setState(() {
        _prefillInvitationData(response.toInvitationCard());
        _isPrefillingInvitation = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _prefillError = '저장된 셋리스트를 불러오지 못했습니다.';
        _isPrefillingInvitation = false;
      });
    }
  }

  void _prefillInvitationData(PerformanceInvitationCard? savedCard) {
    final detail = widget.editTarget!.toDetailData();
    final myTeamName = ref.read(currentTeamProvider).value?.teamName ?? '';
    _enableSetlist = savedCard?.setlist.isNotEmpty ?? false;
    _teamName.text = savedCard?.performanceTeam.isNotEmpty == true
        ? savedCard!.performanceTeam
        : myTeamName;
    _description.text = savedCard?.description.isNotEmpty == true
        ? savedCard!.description
        : detail.introduction;

    if (savedCard != null && savedCard.setlist.isNotEmpty) {
      for (final savedTeam in savedCard.setlist) {
        final group = _TeamGroup(initialName: savedTeam.teamName);
        for (final song in savedTeam.musics) {
          final item = _MusicEntry();
          item.musicTitle.text = song.musicTitle;
          item.musicArtist.text = song.musicArtist;
          item.description.text = song.description;
          item.musicPreviewUrl = song.musicPreviewUrl;
          item.musicImageUrl = song.musicImageUrl;
          group.musics.add(item);
        }
        if (group.musics.isEmpty) group.addMusic();
        _teams.add(group);
      }
    }
    if (_teams.isEmpty) {
      _teams.add(_TeamGroup()..addMusic());
    }
  }

  void _addTeam() {
    _unfocusAll();
    setState(() {
      _pendingDeleteTeamIndex = null;
      final newTeam = _TeamGroup();
      newTeam.addMusic();
      _teams.add(newTeam);
      _selectedTeamIndex = _teams.length - 1;
    });
  }

  void _onTeamChipTap(int idx) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      // 이미 삭제 대기 상태인 칩을 한 번 더 누르면 삭제 (1개만 남았을 때는 삭제 불가)
      if (_pendingDeleteTeamIndex == idx && _teams.length > 1) {
        final removed = _teams.removeAt(idx) as _TeamGroup;
        removed.dispose();
        _pendingDeleteTeamIndex = null;
        if (_selectedTeamIndex >= _teams.length) {
          _selectedTeamIndex = _teams.length - 1;
        }
        return;
      }

      // 현재 선택된 칩을 다시 누르면 삭제 대기 상태로 전환 (2개 이상일 때만)
      if (_selectedTeamIndex == idx && _teams.length > 1) {
        _pendingDeleteTeamIndex = idx;
      } else {
        _selectedTeamIndex = idx;
        _pendingDeleteTeamIndex = null;
      }
    });
  }

  @override
  void dispose() {
    _teamName.removeListener(_onFieldChanged);
    _description.removeListener(_onFieldChanged);
    _teamName.dispose();
    _description.dispose();
    for (final item in _teams) {
      (item as _TeamGroup).dispose();
    }
    super.dispose();
  }

  Future _handleCloseConfirmation() async {
    _unfocusAll();
    final confirmed = await AppPopup.show(
      context,
      title: '작성을 중단하시겠습니까?',
      content: '중단 시, 작성된 내용은\n저장되지 않습니다.',
      warningType: WarningType.circle,
      buttonNum: ButtonNum.two,
      confirmText: '나가기',
      cancelText: '계속 작성',
    );

    if (!mounted) return;
    _unfocusAll();

    if (confirmed == true) {
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 3);
    }
  }

  Future _selectMusic(_MusicEntry music) async {
    _unfocusAll();
    final selected = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const MusicSearchPage(returnOnSelect: true),
      ),
    );

    if (!mounted) return;
    _unfocusAll();

    if (selected is MusicSearchResult) {
      setState(() {
        music.musicTitle.text = selected.title;
        music.musicArtist.text = selected.artist;
        music.musicPreviewUrl = selected.previewUrl;
        music.musicImageUrl = selected.imageUrl;
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

  List _buildPriceList() {
    return widget.step1.ticketTypes.map((type) {
      final priceStr = widget.step1.ticketPrices[type] ?? '0';

      String priceType;
      switch (type) {
        case PerformanceTicketType.advance:
          priceType = 'ADVANCE';
          break;
        case PerformanceTicketType.onsite:
          priceType = 'ON_SITE';
          break;
        case PerformanceTicketType.general:
          priceType = 'GENERAL';
          break;
        case PerformanceTicketType.free:
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

  List _buildFormattedSetlist() {
    if (!_enableSetlist) return [];

    final List list = [];
    for (int i = 0; i < _teams.length; i++) {
      final team = _teams[i] as _TeamGroup;
      final typedName = team.nameController.text.trim();
      final teamName = typedName.isEmpty ? '그룹${i + 1}' : typedName;

      final List musics = [];
      for (final mItem in team.musics) {
        final m = mItem as _MusicEntry;
        final title = m.musicTitle.text.trim();
        final artist = m.musicArtist.text.trim();
        if (title.isNotEmpty || artist.isNotEmpty) {
          musics.add({
            'musicTitle': title.isEmpty ? '미정' : title,
            'musicArtist': artist.isEmpty ? '미정' : artist,
            'description': m.description.text.trim(),
            if (m.musicPreviewUrl?.trim().isNotEmpty ?? false)
              'musicPreviewUrl': m.musicPreviewUrl!.trim(),
            if (m.musicImageUrl?.trim().isNotEmpty ?? false)
              'musicImageUrl': m.musicImageUrl!.trim(),
          });
        }
      }

      if (musics.isNotEmpty) {
        list.add({'teamName': teamName, 'musics': musics});
      }
    }
    return list;
  }

  Future _submit() async {
    _unfocusAll();

    if (!_isFormValid) {
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
        if (resData is Map) {
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

  Future _createPerformance(Dio dio) async {
    final formattedSetlist = _buildFormattedSetlist();

    final Map requestMap = {
      'title': widget.step1.title,
      'description': widget.step1.introduction,
      'performanceDateTime': _formatOffsetDateTime(widget.step1.startsAt),
      'locationId': widget.step1.location.locationId,
      'placeName':
          widget.step1.location.locationName ??
          widget.step1.location.roadAddress ??
          '',
      'prices': _buildPriceList(),
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
        'performanceCreateRequest',
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

    for (final img in widget.detailImages) {
      final image = img as XFile;
      formData.files.add(
        MapEntry(
          'detailImages',
          await MultipartFile.fromFile(image.path, filename: image.name),
        ),
      );
    }

    await dio.post('/performances', data: formData);
  }

  Future _updatePerformance(Dio dio) async {
    final publicId = widget.editTarget!.performancePublicId;
    final formattedSetlist = _buildFormattedSetlist();

    final Map requestMap = {
      'title': widget.step1.title,
      'description': widget.step1.introduction,
      'performanceDateTime': _formatOffsetDateTime(widget.step1.startsAt),
      'locationId': widget.step1.location.locationId,
      'placeName':
          widget.step1.location.locationName ??
          widget.step1.location.roadAddress ??
          widget.editTarget!.placeName,
      'prices': _buildPriceList(),
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

    for (final img in widget.detailImages) {
      final image = img as XFile;
      formData.files.add(
        MapEntry(
          'detailImages',
          await MultipartFile.fromFile(image.path, filename: image.name),
        ),
      );
    }

    await dio.patch('/performances/$publicId', data: formData);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditMode && (_isPrefillingInvitation || _prefillError != null)) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          _handleBackWithDraft();
        },
        child: Scaffold(
          backgroundColor: context.grays.white,
          appBar: AppTopAppBar.backClose(
            onBackPressed: _handleBackWithDraft,
            onClosePressed: _handleCloseConfirmation,
          ),
          body: Center(
            child: _isPrefillingInvitation
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_prefillError!, textAlign: TextAlign.center),
                      const SizedBox(height: AppSpacing.x16),
                      TextButton(
                        onPressed: _loadInvitationForEdit,
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
          ),
        ),
      );
    }

    final currentTeam = _teams.isNotEmpty && _selectedTeamIndex < _teams.length
        ? _teams[_selectedTeamIndex] as _TeamGroup
        : null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBackWithDraft();
      },
      child: GestureDetector(
        onTap: _unfocusAll,
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: context.grays.white,
          appBar: AppTopAppBar.backClose(
            onBackPressed: _handleBackWithDraft,
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
                        _buildReadOnlyStep1Field(
                          context,
                          label: '공연 이름',
                          requiredMark: true,
                          value: widget.step1.title,
                        ),
                        const SizedBox(height: AppSpacing.x20),
                        AppTextField(
                          label: '공연 팀',
                          requiredMark: true,
                          controller: _teamName,
                          hintText: '공연에 참여하는 팀 이름을 작성해주세요.',
                        ),
                        const SizedBox(height: AppSpacing.x20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildReadOnlyStep1Field(
                                context,
                                label: '공연 날짜',
                                requiredMark: true,
                                value:
                                    '${widget.step1.startsAt.year}. ${widget.step1.startsAt.month.toString().padLeft(2, '0')}. ${widget.step1.startsAt.day.toString().padLeft(2, '0')}.',
                                suffixAsset:
                                    'assets/icons/performance/calendar.svg',
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x12),
                            Expanded(
                              child: _buildReadOnlyStep1Field(
                                context,
                                label: '공연 시간',
                                requiredMark: true,
                                value:
                                    '${widget.step1.startsAt.hour.toString().padLeft(2, '0')}:${widget.step1.startsAt.minute.toString().padLeft(2, '0')}',
                                suffixAsset:
                                    'assets/icons/performance/clock.svg',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x20),
                        _buildReadOnlyStep1Field(
                          context,
                          label: '공연 장소',
                          requiredMark: true,
                          value:
                              widget.step1.location.locationName ??
                              widget.step1.location.roadAddress ??
                              '',
                        ),
                        const SizedBox(height: AppSpacing.x20),
                        AppTextArea(
                          label: '상세 소개',
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
                              activeTrackColor: context.brands.beatOrange1,
                              onChanged: (val) {
                                _unfocusAll();
                                setState(() => _enableSetlist = val);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        Text(
                          '셋리스트는 모바일 초대장을 통해서만 볼 수 있습니다.\n팀 태그를 드래그해서 팀 순서를 변경할 수 있습니다.',
                          style: FontStyles.semi12.copyWith(
                            color: context.grays.gray5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x16),
                        if (_enableSetlist && currentTeam != null) ...[
                          SizedBox(
                            height: 38,
                            child: Row(
                              children: [
                                Flexible(
                                  child: ReorderableListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    buildDefaultDragHandles: false,
                                    proxyDecorator: (child, index, animation) {
                                      return Material(
                                        color: Colors.transparent,
                                        child: child,
                                      );
                                    },
                                    itemCount: _teams.length,
                                    onReorder: (oldIndex, newIndex) {
                                      _unfocusAll();
                                      setState(() {
                                        if (oldIndex < newIndex) newIndex -= 1;
                                        final selectedTeam =
                                            _teams[_selectedTeamIndex];
                                        final moved = _teams.removeAt(oldIndex);
                                        _teams.insert(newIndex, moved);
                                        _selectedTeamIndex = _teams.indexOf(
                                          selectedTeam,
                                        );
                                        _pendingDeleteTeamIndex = null;
                                      });
                                    },
                                    itemBuilder: (context, idx) {
                                      final team = _teams[idx] as _TeamGroup;
                                      final isSelected =
                                          idx == _selectedTeamIndex;
                                      final isPendingDelete =
                                          _pendingDeleteTeamIndex == idx &&
                                          _teams.length > 1;
                                      final typedName = team.nameController.text
                                          .trim();
                                      final chipLabel = typedName.isNotEmpty
                                          ? typedName
                                          : '그룹${idx + 1}';

                                      return ReorderableDragStartListener(
                                        key: ValueKey(team),
                                        index: idx,
                                        child: GestureDetector(
                                          onTap: () => _onTeamChipTap(idx),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: isSelected
                                                    ? context.grays.gray1
                                                    : context.grays.gray5,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 18,
                                                          vertical: 8,
                                                        ),
                                                    color: isSelected
                                                        ? context.grays.gray1
                                                        : Colors.white,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      chipLabel,
                                                      style: FontStyles.med14
                                                          .copyWith(
                                                            color: isSelected
                                                                ? Colors.white
                                                                : context
                                                                      .grays
                                                                      .black,
                                                          ),
                                                    ),
                                                  ),
                                                  if (isPendingDelete) ...[
                                                    Positioned.fill(
                                                      child: ColoredBox(
                                                        color:
                                                            const Color(
                                                              0xFF292929,
                                                            ).withValues(
                                                              alpha: 0.76,
                                                            ),
                                                      ),
                                                    ),
                                                    SvgPicture.asset(
                                                      'assets/icons/performance/trash.svg',
                                                      width: 18,
                                                      height: 18,
                                                      colorFilter:
                                                          const ColorFilter.mode(
                                                            Colors.white,
                                                            BlendMode.srcIn,
                                                          ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
                                    alignment: Alignment.center,
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
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: TextField(
                                    controller: currentTeam.nameController,
                                    maxLength: _maxGroupNameLength,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                        _maxGroupNameLength,
                                      ),
                                    ],
                                    onChanged: (_) => setState(() {}),
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      counterText: '',
                                      hintText: '그룹${_selectedTeamIndex + 1}',
                                      hintStyle: FontStyles.reg16.copyWith(
                                        color: context.grays.gray5,
                                      ),
                                      border: InputBorder.none,
                                      filled: false,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                    _unfocusAll();
                                    setState(() {
                                      if (oldIndex < newIndex) newIndex -= 1;
                                      final item = currentTeam.musics.removeAt(
                                        oldIndex,
                                      );
                                      currentTeam.musics.insert(newIndex, item);
                                    });
                                  },
                                  itemBuilder: (context, mIdx) {
                                    final music =
                                        currentTeam.musics[mIdx] as _MusicEntry;
                                    return _buildMusicEntryCard(
                                      key: ValueKey(music),
                                      music: music,
                                      index: mIdx,
                                      onSelectMusic: () => _selectMusic(music),
                                      onDelete: () {
                                        _unfocusAll();
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
                                      _unfocusAll();
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
                      onPressed: (_isLoading || !_isFormValid) ? null : _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyStep1Field(
    BuildContext context, {
    required String label,
    required String value,
    bool requiredMark = false,
    String? suffixAsset,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: label),
              if (requiredMark)
                TextSpan(
                  text: ' *',
                  style: FontStyles.med15.copyWith(
                    color: context.brands.beatOrange1,
                  ),
                ),
            ],
          ),
          style: FontStyles.med15.copyWith(color: context.grays.gray4),
        ),
        const SizedBox(height: AppSpacing.x8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: context.grays.gray8,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.reg17.copyWith(color: context.grays.gray4),
                ),
              ),
              if (suffixAsset != null) ...[
                const SizedBox(width: 8),
                SvgPicture.asset(
                  suffixAsset,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    context.grays.gray5,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
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
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/performance/move.svg',
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        context.grays.gray4,
                        BlendMode.srcIn,
                      ),
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
                      borderRadius: BorderRadius.circular(5),
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
                                          style: FontStyles.med18.copyWith(
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
                              'assets/icons/performance/music.svg',
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                context.grays.gray5,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
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
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: music.description,
                    maxLines: null,
                    minLines: 1,
                    inputFormatters: [
                      _MaxLengthNotifyFormatter(
                        maxLength: _maxMusicDescriptionLength,
                        onExceededChanged: (exceeded) {
                          if (music.isDescriptionExceeded != exceeded) {
                            setState(() {
                              music.isDescriptionExceeded = exceeded;
                            });
                          }
                        },
                      ),
                    ],
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
                    onChanged: (val) {
                      setState(() {
                        if (val.length < _maxMusicDescriptionLength) {
                          music.isDescriptionExceeded = false;
                        }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _DeleteCircleButton(
                onTap: () {
                  _unfocusAll();
                  setState(() {
                    music.description.clear();
                    music.isDescriptionExceeded = false;
                  });
                },
              ),
            ],
          ),
          if (music.isDescriptionExceeded) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                '설명은 최대 50자까지 입력할 수 있습니다.',
                style: FontStyles.reg12.copyWith(color: context.colors.error),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MaxLengthNotifyFormatter extends TextInputFormatter {
  _MaxLengthNotifyFormatter({
    required this.maxLength,
    required this.onExceededChanged,
  });

  final int maxLength;
  final ValueChanged<bool> onExceededChanged;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.characters.length > maxLength) {
      onExceededChanged(true);
      final truncated = newValue.text.characters.take(maxLength).toString();
      return TextEditingValue(
        text: truncated,
        selection: TextSelection.collapsed(offset: truncated.length),
      );
    }
    onExceededChanged(false);
    return newValue;
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
      child: SvgPicture.asset(
        'assets/icons/performance/delete.svg',
        width: 24,
        height: 24,
      ),
    );
  }
}

class _TeamGroup {
  _TeamGroup({String initialName = ''}) {
    nameController = TextEditingController(text: initialName);
  }

  late final TextEditingController nameController;
  final List musics = [];

  void addMusic() {
    musics.add(_MusicEntry());
  }

  void removeMusic(int index) {
    if (musics.length <= 1) {
      (musics[0] as _MusicEntry).clear();
      return;
    }
    final removed = musics.removeAt(index) as _MusicEntry;
    removed.dispose();
  }

  void dispose() {
    nameController.dispose();
    for (final m in musics) {
      (m as _MusicEntry).dispose();
    }
  }
}

class _MusicEntry {
  final musicTitle = TextEditingController();
  final musicArtist = TextEditingController();
  final description = TextEditingController();
  bool isDescriptionExceeded = false;
  String? musicPreviewUrl;
  String? musicImageUrl;

  void clear() {
    musicTitle.clear();
    musicArtist.clear();
    description.clear();
    isDescriptionExceeded = false;
    musicPreviewUrl = null;
    musicImageUrl = null;
  }

  void dispose() {
    musicTitle.dispose();
    musicArtist.dispose();
    description.dispose();
  }
}
