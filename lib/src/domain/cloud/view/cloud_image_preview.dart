import 'dart:io';

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

class CloudImagePreview extends StatefulWidget {
  const CloudImagePreview({
    super.key,
    this.folderName = '',
    required this.files,
    this.onDeletePressed,
    this.onMovePressed,
    this.onDownloadPressed,
    this.onOpenExternalPressed,
    this.canManage = true,
    this.initialIndex = 0,
    this.requestHeaders,
    this.onFileSelected,
  });

  final String folderName;
  final List<CloudFilePreviewItem> files;
  final int initialIndex;
  final Map<String, String>? requestHeaders;
  final ValueChanged<CloudFilePreviewItem>? onDeletePressed;
  final ValueChanged<CloudFilePreviewItem>? onMovePressed;
  final ValueChanged<CloudFilePreviewItem>? onDownloadPressed;
  final ValueChanged<CloudFilePreviewItem>? onOpenExternalPressed;
  final bool canManage;
  final ValueChanged<CloudFilePreviewItem>? onFileSelected;

  @override
  State<CloudImagePreview> createState() => _CloudImagePreviewState();
}

class _CloudImagePreviewState extends State<CloudImagePreview> {
  late int _currentIndex;
  bool _loadFailed = false;

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
    if (selectedFile.type != CloudPreviewFileType.image ||
        selectedFile.previewUri == null) {
      widget.onFileSelected?.call(selectedFile);
      return;
    }

    setState(() {
      _currentIndex = selectedIndex;
      _loadFailed = false;
    });
  }

  Widget _buildImage() {
    final uri = _currentFile.previewUri;
    if (uri == null || _loadFailed) {
      return _buildError();
    }

    // 큰 원본 이미지의 크기에 따라 레이아웃이 늘어나지 않도록
    // 실제 미리보기 영역의 너비·높이를 고정하고 contain으로 표시합니다.
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final image = uri.scheme == 'file'
            ? Image.file(
                File.fromUri(uri),
                width: width,
                height: height,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _loadFailed = true);
                  });
                  return const SizedBox.shrink();
                },
              )
            : Image.network(
                uri.toString(),
                headers: widget.requestHeaders,
                width: width,
                height: height,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const Center(child: CircularProgressIndicator()),
                errorBuilder: (_, __, ___) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _loadFailed = true);
                  });
                  return const SizedBox.shrink();
                },
              );

        return InteractiveViewer(
          // 다른 파일로 전환할 때 이전 파일의 확대 상태를 이어받지 않습니다.
          key: ValueKey('cloud-image-${_currentIndex}-${uri.toString()}'),
          minScale: 0.5,
          maxScale: 5.0,
          child: SizedBox(width: width, height: height, child: image),
        );
      },
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '이미지를 앱에서 표시할 수 없습니다.',
              textAlign: TextAlign.center,
              style: FontStyles.med16.copyWith(color: context.grays.gray2),
            ),
            const SizedBox(height: AppSpacing.x8),
            Text(
              'HEIC 등 일부 형식은 기기의 이미지 코덱에 따라 미리보기가 제한될 수 있어요.',
              textAlign: TextAlign.center,
              style: FontStyles.med14.copyWith(color: context.grays.gray4),
            ),
            const SizedBox(height: AppSpacing.x16),
            if (widget.onOpenExternalPressed != null)
              TextButton(
                onPressed: () => widget.onOpenExternalPressed?.call(_currentFile),
                child: const Text('외부 앱에서 열기'),
              ),
          ],
        ),
      ),
    );
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
            Padding(
              // 하단 작업 버튼이 세로로 긴 이미지의 끝을 가리지 않게 합니다.
              padding: EdgeInsets.only(
                bottom: showActions
                    ? 66.0 + AppSpacing.x16 +
                        MediaQuery.paddingOf(context).bottom
                    : 0,
              ),
              child: _buildImage(),
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
