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
    required this.folderName,
    required this.files,
    required this.onDeletePressed,
    required this.onMovePressed,
    required this.onDownloadPressed,
    required this.onOpenExternalPressed,
    this.canManage = true,
    this.initialIndex = 0,
    this.requestHeaders,
    this.onFileSelected,
  });

  final String folderName;
  final List<CloudFilePreviewItem> files;
  final int initialIndex;
  final Map<String, String>? requestHeaders;
  final ValueChanged<CloudFilePreviewItem> onDeletePressed;
  final ValueChanged<CloudFilePreviewItem> onMovePressed;
  final ValueChanged<CloudFilePreviewItem> onDownloadPressed;
  final ValueChanged<CloudFilePreviewItem> onOpenExternalPressed;
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

    final image = uri.scheme == 'file'
        ? Image.file(
            File.fromUri(uri),
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
      minScale: 0.5,
      maxScale: 5.0,
      child: Center(child: image),
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
            TextButton(
              onPressed: () => widget.onOpenExternalPressed(_currentFile),
              child: const Text('외부 앱에서 열기'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: CloudFileAppbar(
        titleText: _currentFile.name,
        onLeadingPressed: _showFileList,
        onTitlePressed: _showFileList,
      ),
      body: CloudPreviewBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            Positioned(
              left: AppSpacing.x16,
              bottom: AppSpacing.x16 + MediaQuery.paddingOf(context).bottom,
              child: CloudSelectionFloatingBar(
                isEnabled: true,
                showDelete: widget.canManage,
                showMove: widget.canManage,
                onDeletePressed: () => widget.onDeletePressed(_currentFile),
                onMovePressed: () => widget.onMovePressed(_currentFile),
                onDownloadPressed: () => widget.onDownloadPressed(_currentFile),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
