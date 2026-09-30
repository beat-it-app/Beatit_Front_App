import 'dart:async';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/cloud/model/cloud_models.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_list_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_mutation_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_audio_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_image_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_link_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_other_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_video_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_appbar.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_preview_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class CloudPreviewHostPage extends ConsumerStatefulWidget {
  const CloudPreviewHostPage({
    super.key,
    required this.folderName,
    required this.items,
    required this.initialItemId,
    this.folderId,
  });

  final String folderName;
  final int? folderId;
  final List<CloudItem> items;
  final int initialItemId;

  @override
  ConsumerState<CloudPreviewHostPage> createState() =>
      _CloudPreviewHostPageState();
}

class _CloudPreviewHostPageState extends ConsumerState<CloudPreviewHostPage> {
  late int _currentItemId;

  @override
  void initState() {
    super.initState();
    _currentItemId = widget.initialItemId;
  }

  CloudItem? get _currentItem {
    for (final item in widget.items) {
      if (item.itemId == _currentItemId) {
        return item;
      }
    }
    return null;
  }

  void _selectFile(CloudFilePreviewItem file) {
    final itemId = file.itemId;
    if (itemId == null || itemId == _currentItemId) return;
    setState(() => _currentItemId = itemId);
  }

  Future<void> _deleteItem(CloudFilePreviewItem file) async {
    final itemId = file.itemId;
    if (itemId == null) return;

    final confirmed = await AppPopup.show(
      context,
      title: '삭제하시겠습니까?',
      content: '삭제한 파일 또는 링크는 복구할 수 없습니다.',
      buttonNum: ButtonNum.two,
      warningType: WarningType.triangle,
      confirmText: '삭제',
      cancelText: '취소',
    );
    if (!mounted || confirmed != true) return;

    final success = await ref.read(cloudMutationProvider.notifier).deleteItems(
      itemIds: [itemId],
      currentFolderId: widget.folderId,
    );
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      return;
    }

    final message =
        ref.read(cloudMutationProvider).errorMessage ?? '삭제 중 오류가 발생했습니다.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showMoveNotice(CloudFilePreviewItem _) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('파일 이동은 다음 연동 범위에서 연결합니다.')),
    );
  }

  Future<void> _openExternally(CloudFilePreviewItem file) async {
    var uri = file.previewUri;

    if (uri == null && file.type != CloudPreviewFileType.link) {
      final itemId = file.itemId;
      if (itemId == null) {
        _showOpenError();
        return;
      }
      try {
        final detail = await ref.read(
          cloudFileDetailProvider(itemId).future,
        );
        uri = Uri.tryParse(detail.fileUrl);
      } catch (_) {
        uri = null;
      }
    }

    if (!mounted) return;

    if (uri == null) {
      _showOpenError();
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && mounted) {
        _showOpenError();
      }
    } catch (_) {
      if (mounted) {
        _showOpenError();
      }
    }
  }

  void _showOpenError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('파일을 열 수 없습니다. 다시 시도해주세요.')),
    );
  }

  CloudFilePreviewItem _toPreviewItem(
    CloudItem item, {
    Uri? resolvedUri,
  }) {
    final type = _previewTypeOf(item);
    final linkUri = item.linkUrl == null ? null : Uri.tryParse(item.linkUrl!);

    return CloudFilePreviewItem(
      itemId: item.itemId,
      name: item.itemName,
      uploadedAt: _formatDate(item.createdAt),
      uploaderName: item.uploaderName,
      type: type,
      iconPath: type.cloudItemType.iconPath,
      previewUri: resolvedUri ?? linkUri,
      sizeLabel: _formatFileSize(item.fileSize),
      mimeType: item.mimeType,
    );
  }

  List<CloudFilePreviewItem> _previewItems({
    required CloudItem currentItem,
    required Uri currentUri,
  }) {
    return widget.items
        .map(
          (item) => _toPreviewItem(
            item,
            resolvedUri: item.itemId == currentItem.itemId ? currentUri : null,
          ),
        )
        .toList(growable: false);
  }

  CloudPreviewFileType _previewTypeOf(CloudItem item) {
    if (item.linkUrl?.trim().isNotEmpty == true) {
      return CloudPreviewFileType.link;
    }

    final mime = (item.mimeType ?? '').toLowerCase();
    final extension = _extensionOf(item.itemName);

    if (mime.startsWith('image/') ||
        const {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'}.contains(extension)) {
      return CloudPreviewFileType.image;
    }

    if (mime.startsWith('audio/') ||
        const {'mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac'}.contains(extension)) {
      return CloudPreviewFileType.audio;
    }

    if (mime.startsWith('video/') ||
        const {'mp4', 'mov', 'avi'}.contains(extension)) {
      return CloudPreviewFileType.video;
    }

    if (mime == 'application/pdf' || extension == 'pdf') {
      return CloudPreviewFileType.document;
    }

    return CloudPreviewFileType.other;
  }

  String _extensionOf(String fileName) {
    final index = fileName.lastIndexOf('.');
    if (index < 0 || index == fileName.length - 1) return '';
    return fileName.substring(index + 1).toLowerCase();
  }

  String? _formatFileSize(int? bytes) {
    if (bytes == null) return null;
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    }
    return '${bytes}B';
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.year}. ${local.month.toString().padLeft(2, '0')}. ${local.day.toString().padLeft(2, '0')}';
  }

  Widget _buildResolvedPreview({
    required CloudItem currentItem,
    required Uri currentUri,
  }) {
    final files = _previewItems(
      currentItem: currentItem,
      currentUri: currentUri,
    );
    final resolvedIndex = files.indexWhere(
      (file) => file.itemId == currentItem.itemId,
    );
    final initialIndex = resolvedIndex < 0 ? 0 : resolvedIndex;
    final type = _previewTypeOf(currentItem);

    void deletePressed(CloudFilePreviewItem file) {
      unawaited(_deleteItem(file));
    }

    void downloadPressed(CloudFilePreviewItem file) {
      unawaited(_openExternally(file));
    }

    return switch (type) {
      CloudPreviewFileType.audio => CloudAudioPreview(
        key: ValueKey('audio-${currentItem.itemId}'),
        folderName: widget.folderName,
        files: files,
        initialIndex: initialIndex,
        onDeletePressed: deletePressed,
        onMovePressed: _showMoveNotice,
        onDownloadPressed: downloadPressed,
        onFileSelected: _selectFile,
      ),
      CloudPreviewFileType.video => CloudVideoPreview(
        key: ValueKey('video-${currentItem.itemId}'),
        folderName: widget.folderName,
        files: files,
        initialIndex: initialIndex,
        onDeletePressed: deletePressed,
        onMovePressed: _showMoveNotice,
        onDownloadPressed: downloadPressed,
        onFileSelected: _selectFile,
      ),
      CloudPreviewFileType.document => CloudFilePreview(
        key: ValueKey('pdf-${currentItem.itemId}'),
        folderName: widget.folderName,
        files: files,
        initialIndex: initialIndex,
        onDeletePressed: deletePressed,
        onMovePressed: _showMoveNotice,
        onDownloadPressed: downloadPressed,
        onFileSelected: _selectFile,
      ),
      CloudPreviewFileType.image => CloudImagePreview(
        key: ValueKey('image-${currentItem.itemId}'),
        folderName: widget.folderName,
        files: files,
        initialIndex: initialIndex,
        onDeletePressed: deletePressed,
        onMovePressed: _showMoveNotice,
        onDownloadPressed: downloadPressed,
        onOpenExternalPressed: downloadPressed,
        onFileSelected: _selectFile,
      ),
      CloudPreviewFileType.other => CloudOtherFilePreview(
        key: ValueKey('other-${currentItem.itemId}'),
        folderName: widget.folderName,
        files: files,
        initialIndex: initialIndex,
        onDeletePressed: deletePressed,
        onMovePressed: _showMoveNotice,
        onDownloadPressed: downloadPressed,
        onOpenExternalPressed: downloadPressed,
        onFileSelected: _selectFile,
      ),
      CloudPreviewFileType.link => CloudLinkPreview(
        key: ValueKey('link-${currentItem.itemId}'),
        folderName: widget.folderName,
        files: files,
        initialIndex: initialIndex,
        onDeletePressed: deletePressed,
        onMovePressed: _showMoveNotice,
        onFileSelected: _selectFile,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _currentItem;
    if (currentItem == null) {
      return _CloudPreviewLoadError(
        title: '파일을 찾을 수 없습니다.',
        onRetry: () => Navigator.of(context).pop(),
        retryLabel: '돌아가기',
      );
    }

    if (_previewTypeOf(currentItem) == CloudPreviewFileType.link) {
      final linkUri = Uri.tryParse(currentItem.linkUrl ?? '');
      if (linkUri == null) {
        return _CloudPreviewLoadError(
          title: '링크 주소를 확인할 수 없습니다.',
          onRetry: () => Navigator.of(context).pop(),
          retryLabel: '돌아가기',
        );
      }
      return _buildResolvedPreview(
        currentItem: currentItem,
        currentUri: linkUri,
      );
    }

    final detail = ref.watch(cloudFileDetailProvider(currentItem.itemId));

    return detail.when(
      loading: () => _CloudPreviewLoading(title: currentItem.itemName),
      error: (error, _) => _CloudPreviewLoadError(
        title: error.toString(),
        onRetry: () => ref.invalidate(
          cloudFileDetailProvider(currentItem.itemId),
        ),
      ),
      data: (data) {
        final uri = Uri.tryParse(data.fileUrl);
        if (uri == null) {
          return _CloudPreviewLoadError(
            title: '파일 URL을 확인할 수 없습니다.',
            onRetry: () => ref.invalidate(
              cloudFileDetailProvider(currentItem.itemId),
            ),
          );
        }
        return _buildResolvedPreview(
          currentItem: currentItem,
          currentUri: uri,
        );
      },
    );
  }
}

class _CloudPreviewLoading extends StatelessWidget {
  const _CloudPreviewLoading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: CloudFileAppbar(titleText: title),
      body: const CloudPreviewBackground(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _CloudPreviewLoadError extends StatelessWidget {
  const _CloudPreviewLoadError({
    required this.title,
    required this.onRetry,
    this.retryLabel = '다시 시도',
  });

  final String title;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: const CloudFileAppbar(titleText: '파일 미리보기'),
      body: CloudPreviewBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: FontStyles.med16.copyWith(color: context.grays.gray2),
                ),
                const SizedBox(height: AppSpacing.x16),
                TextButton(onPressed: onRetry, child: Text(retryLabel)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
