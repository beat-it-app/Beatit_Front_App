import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/model/cloud_models.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_list_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_mutation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudMovePage extends ConsumerStatefulWidget {
  const CloudMovePage({
    super.key,
    required this.itemIds,
    required this.currentFolderName,
    this.currentFolderId,
    this.displayName,
  });

  final List<int> itemIds;
  final int? currentFolderId;
  final String currentFolderName;
  final String? displayName;

  @override
  ConsumerState<CloudMovePage> createState() => _CloudMovePageState();
}

class _CloudMovePageState extends ConsumerState<CloudMovePage> {
  static const int _rootTargetValue = -1;
  int? _selectedTargetValue;

  int? get _targetFolderId => _selectedTargetValue == _rootTargetValue
      ? null
      : _selectedTargetValue;

  bool get _canConfirm {
    final selected = _selectedTargetValue;
    if (selected == null) return false;
    if (selected == _rootTargetValue) return widget.currentFolderId != null;
    return selected != widget.currentFolderId;
  }

  Future<void> _confirmMove() async {
    if (!_canConfirm) return;

    final success = await ref.read(cloudMutationProvider.notifier).moveItems(
      itemIds: widget.itemIds,
      currentFolderId: widget.currentFolderId,
      targetFolderId: _targetFolderId,
    );
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      return;
    }

    final message =
        ref.read(cloudMutationProvider).errorMessage ?? '파일 이동에 실패했습니다.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final root = ref.watch(cloudListProvider(null));
    final mutation = ref.watch(cloudMutationProvider);

    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.grays.white,
        leadingWidth: 60,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(false),
          icon: SvgPicture.asset(
            'assets/icons/appbar/back.svg',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              context.grays.black,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: Text(
          '파일 이동하기',
          style: FontStyles.semi18.copyWith(color: context.grays.black),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (mutation.isMoving)
                  const LinearProgressIndicator(minHeight: 2),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x16,
                    AppSpacing.x24,
                    AppSpacing.x16,
                    AppSpacing.x16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemIds.length == 1 &&
                                widget.displayName?.trim().isNotEmpty == true
                            ? '${widget.displayName!.trim()} 이동'
                            : widget.itemIds.length == 1
                            ? '파일 이동'
                            : '${widget.itemIds.length}개 파일 이동',
                        style: FontStyles.bold34.copyWith(
                          color: context.grays.black,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      Text(
                        '현재 위치: ${widget.currentFolderName}',
                        style: FontStyles.med12.copyWith(
                          color: context.grays.gray5,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: root.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, _) => Center(
                      child: TextButton(
                        onPressed: () => ref.invalidate(cloudListProvider(null)),
                        child: const Text('폴더 목록 다시 불러오기'),
                      ),
                    ),
                    data: (data) => _buildTargets(data.folders),
                  ),
                ),
              ],
            ),
            Positioned(
              right: AppSpacing.x16,
              bottom: AppSpacing.x16,
              child: _MoveConfirmButton(
                enabled: _canConfirm && !mutation.isMoving,
                onPressed: _confirmMove,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargets(List<CloudFolder> folders) {
    final targets = <_MoveTarget>[
      const _MoveTarget(
        value: _rootTargetValue,
        label: '팀 클라우드',
        itemCount: null,
      ),
      ...folders.map(
        (folder) => _MoveTarget(
          value: folder.folderId,
          label: folder.folderName,
          itemCount: folder.itemCount,
        ),
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: targets.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 1,
        indent: AppSpacing.x16,
        endIndent: AppSpacing.x16,
        color: context.grays.gray7,
      ),
      itemBuilder: (context, index) {
        final target = targets[index];
        final isCurrent = target.value == _rootTargetValue
            ? widget.currentFolderId == null
            : target.value == widget.currentFolderId;
        final isSelected = target.value == _selectedTargetValue;

        return InkWell(
          onTap: isCurrent
              ? null
              : () => setState(() => _selectedTargetValue = target.value),
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
            color: isSelected
                ? context.brands.beatOrange6.withValues(alpha: 0.55)
                : context.grays.white.withValues(alpha: 0.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/cloud/folder.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    isCurrent
                        ? context.grays.gray6
                        : isSelected
                        ? context.brands.beatOrange1
                        : context.grays.gray3,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSpacing.x16),
                Expanded(
                  child: Text(
                    target.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontStyles.med16.copyWith(
                      color: isCurrent
                          ? context.grays.gray5
                          : context.grays.black,
                    ),
                  ),
                ),
                if (target.itemCount != null) ...[
                  Text(
                    '${target.itemCount}',
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                ],
                if (isCurrent)
                  Text(
                    '현재',
                    style: FontStyles.med12.copyWith(
                      color: context.grays.gray5,
                    ),
                  )
                else
                  SvgPicture.asset(
                    'assets/icons/cloud/back.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      context.grays.gray6,
                      BlendMode.srcIn,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MoveTarget {
  const _MoveTarget({
    required this.value,
    required this.label,
    required this.itemCount,
  });

  final int value;
  final String label;
  final int? itemCount;
}

class _MoveConfirmButton extends StatelessWidget {
  const _MoveConfirmButton({
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: '선택한 위치로 이동',
      child: Material(
        color: enabled ? context.brands.beatOrange1 : context.grays.gray6,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            width: 58,
            height: 58,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/check/check.svg',
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(
                  context.grays.white,
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
