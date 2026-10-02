import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/cloud_file_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_appbar.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_preview_background.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudOtherFilePreview extends StatefulWidget {
  const CloudOtherFilePreview({
    super.key,
    this.folderName = '',
    required this.files,
    this.onDeletePressed,
    this.onMovePressed,
    this.onDownloadPressed,
    this.onOpenExternalPressed,
    this.canManage = true,
    this.initialIndex = 0,
    this.onFileSelected,
  });

  final String folderName;
  final List<CloudFilePreviewItem> files;
  final int initialIndex;
  final ValueChanged<CloudFilePreviewItem>? onDeletePressed;
  final ValueChanged<CloudFilePreviewItem>? onMovePressed;
  final ValueChanged<CloudFilePreviewItem>? onDownloadPressed;
  final ValueChanged<CloudFilePreviewItem>? onOpenExternalPressed;
  final bool canManage;
  final ValueChanged<CloudFilePreviewItem>? onFileSelected;

  @override
  State<CloudOtherFilePreview> createState() => _CloudOtherFilePreviewState();
}

class _CloudOtherFilePreviewState extends State<CloudOtherFilePreview> {
  late int _currentIndex;

  CloudFilePreviewItem get _currentFile => widget.files[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Future<void> _showFileList() async {
    if (widget.files.length <= 1) return;

    final selectedIndex = await showCloudPreviewFileListBottomSheet(
      context: context,
      folderName: widget.folderName,
      itemCount: widget.files.length,
      itemBuilder: (sheetContext, index) {
        final file = widget.files[index];
        return CloudItemWidget(
          itemType: file.type.cloudItemType,
          fileName: file.name,
          fileSize: file.sizeLabel,
          uploadedAt: file.uploadedAt,
          uploaderName: file.uploaderName,
          isSelected: index == _currentIndex,
          showMoreMenu: false,
          onTap: () => Navigator.of(sheetContext).pop(index),
        );
      },
    );

    if (!mounted || selectedIndex == null || selectedIndex == _currentIndex) {
      return;
    }

    final selectedFile = widget.files[selectedIndex];
    if (selectedFile.type != CloudPreviewFileType.other ||
        selectedFile.previewUri == null) {
      widget.onFileSelected?.call(selectedFile);
      return;
    }

    setState(() => _currentIndex = selectedIndex);
  }

  String get _extension {
    final name = _currentFile.name;
    final index = name.lastIndexOf('.');
    if (index < 0 || index == name.length - 1) return 'FILE';
    return name.substring(index + 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final showDelete = widget.canManage && widget.onDeletePressed != null;
    final showMove = widget.canManage && widget.onMovePressed != null;
    final showDownload = widget.onDownloadPressed != null;
    final showActions = showDelete || showMove || showDownload;

    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: CloudFileAppbar(
        titleText: _currentFile.name,
        onLeadingPressed: widget.files.length > 1 ? _showFileList : null,
        onTitlePressed: widget.files.length > 1 ? _showFileList : null,
      ),
      body: CloudPreviewBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.x24,
                  AppSpacing.x24,
                  AppSpacing.x24,
                  showActions ? 120 : AppSpacing.x24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/cloud/file.svg',
                      width: 72,
                      height: 72,
                    ),
                    const SizedBox(height: AppSpacing.x20),
                    Text(
                      _currentFile.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: FontStyles.semi20.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x8),
                    Text(
                      '$_extension 파일${_currentFile.sizeLabel == null ? '' : ' · ${_currentFile.sizeLabel}'}',
                      style: FontStyles.med14.copyWith(
                        color: context.grays.gray4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x16),
                    Text(
                      '이 파일 형식은 앱 안에서 직접 렌더링하지 않습니다.\n설치된 외부 앱에서 파일을 열 수 있어요.',
                      textAlign: TextAlign.center,
                      style: FontStyles.med14.copyWith(
                        color: context.grays.gray4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x20),
                    if (widget.onOpenExternalPressed != null)
                      TextButton(
                        onPressed: () =>
                            widget.onOpenExternalPressed?.call(_currentFile),
                        child: const Text('외부 앱에서 열기'),
                      ),
                  ],
                ),
              ),
            ),
            if (showActions)
              Positioned(
                left: AppSpacing.x16,
                bottom: AppSpacing.x16 + MediaQuery.paddingOf(context).bottom,
                child: CloudSelectionFloatingBar(
                  isEnabled: true,
                  showDelete: showDelete,
                  showMove: showMove,
                  showDownload: showDownload,
                  onDeletePressed: () => widget.onDeletePressed?.call(_currentFile),
                  onMovePressed: () => widget.onMovePressed?.call(_currentFile),
                  onDownloadPressed: showDownload
                      ? () => widget.onDownloadPressed?.call(_currentFile)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
