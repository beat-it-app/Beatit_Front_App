import 'dart:async';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_link_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

Future<LinkCreateBottomsheetResult?> showLinkCreateBottomsheet({
  required BuildContext context,
  String? initialTitle,
  String? initialUrl,
}) {
  return showModalBottomSheet<LinkCreateBottomsheetResult>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.grays.white.withValues(alpha: 0.0),
    barrierColor: context.grays.black.withValues(alpha: 0.6),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.84,
        child: LinkCreateBottomsheet(
          initialTitle: initialTitle,
          initialUrl: initialUrl,
        ),
      );
    },
  );
}

class LinkCreateBottomsheetResult {
  const LinkCreateBottomsheetResult({required this.title, required this.url});

  final String title;
  final String url;
}

class LinkCreateBottomsheet extends StatefulWidget {
  const LinkCreateBottomsheet({
    super.key,
    this.initialTitle,
    this.initialUrl,
  });

  final String? initialTitle;
  final String? initialUrl;

  @override
  State<LinkCreateBottomsheet> createState() => _LinkCreateBottomsheetState();
}

class _LinkCreateBottomsheetState extends State<LinkCreateBottomsheet> {
  late final TextEditingController _titleController = TextEditingController(
    text: widget.initialTitle ?? '',
  );
  late final TextEditingController _urlController = TextEditingController(
    text: widget.initialUrl ?? '',
  );

  Metadata? _metadata;
  int _requestId = 0;
  bool _isLoadingPreview = false;

  bool get _canConfirm => _parsedUrl != null;

  Uri? get _parsedUrl {
    final raw = _urlController.text.trim();
    if (raw.isEmpty) return null;

    final uri = Uri.tryParse(raw);
    if (uri == null) return null;
    if (uri.scheme != 'http' && uri.scheme != 'https') return null;
    return uri;
  }

  @override
  void initState() {
    super.initState();
    _urlController.addListener(_handleUrlChanged);
    if (_urlController.text.trim().isNotEmpty) {
      unawaited(_loadMetadata());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.removeListener(_handleUrlChanged);
    _urlController.dispose();
    super.dispose();
  }

  void _handleUrlChanged() {
    setState(() {});
    unawaited(_loadMetadata());
  }

  Future<void> _loadMetadata() async {
    final requestId = ++_requestId;
    final uri = _parsedUrl;

    if (uri == null) {
      if (!mounted) return;
      setState(() {
        _metadata = null;
        _isLoadingPreview = false;
      });
      return;
    }

    setState(() {
      _isLoadingPreview = true;
    });

    try {
      final metadata = await MetadataFetch.extract(uri.toString());
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _metadata = metadata;
        _isLoadingPreview = false;
      });
    } catch (_) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _metadata = null;
        _isLoadingPreview = false;
      });
    }
  }

  Uri? _metadataImageUri() {
    final baseUri = _parsedUrl;
    final image = _metadata?.image?.trim();
    if (image == null || image.isEmpty) return null;

    final parsed = Uri.tryParse(image);
    if (parsed == null) return null;
    if (parsed.hasScheme) return parsed;
    return baseUri?.resolve(image);
  }

  String _domainLabel() {
    final uri = _parsedUrl;
    if (uri == null) {
      return '';
    }

    var host = uri.host.trim();
    if (host.startsWith('www.')) {
      host = host.substring(4);
    }
    return host.isEmpty ? uri.toString() : host;
  }

  String _resolvedTitle() {
    final inputTitle = _titleController.text.trim();
    if (inputTitle.isNotEmpty) {
      return inputTitle;
    }

    final metadataTitle = _metadata?.title?.trim();
    if (metadataTitle != null && metadataTitle.isNotEmpty) {
      return metadataTitle;
    }

    final domain = _domainLabel();
    return domain.isNotEmpty ? domain : '링크';
  }

  void _submit() {
    final uri = _parsedUrl;
    if (uri == null) {
      return;
    }

    Navigator.of(context).pop(
      LinkCreateBottomsheetResult(
        title: _resolvedTitle(),
        url: uri.toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.grays.white,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.x20,
          AppSpacing.x30,
          AppSpacing.x20,
          AppSpacing.x20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '링크 등록하기',
              textAlign: TextAlign.center,
              style: FontStyles.bold26.copyWith(color: context.grays.black),
            ),
            const SizedBox(height: AppSpacing.x24),
            AppTextField(
              label: '제목',
              hintText: '링크 제목',
              controller: _titleController,
              onChanged: (_) {
                setState(() {});
              },
            ),
            const SizedBox(height: AppSpacing.x16),
            AppTextField(
              label: '링크',
              hintText: '링크 붙여넣기',
              controller: _urlController,
              onChanged: (_) {},
              suffixIcon: _urlController.text.trim().isEmpty
                  ? null
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _urlController.clear();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.x12),
                        child: Icon(
                          Icons.cancel_rounded,
                          size: 18,
                          color: context.grays.gray5,
                        ),
                      ),
                    ),
            ),
            if (_parsedUrl != null) ...[
              const SizedBox(height: AppSpacing.x16),
              if (_isLoadingPreview)
                Container(
                  height: 160,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.grays.gray8,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const CircularProgressIndicator(),
                )
              else
                CloudLinkPreviewCard(
                  title: _resolvedTitle(),
                  domain: _domainLabel(),
                  imageUri: _metadataImageUri(),
                ),
            ],
            const SizedBox(height: AppSpacing.x24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: '취소',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    variant: ButtonVariant.gray,
                  ),
                ),
                const SizedBox(width: AppSpacing.x8),
                Expanded(
                  child: AppButton(
                    text: '확인',
                    onPressed: _submit,
                    variant: ButtonVariant.primary,
                    isDisabled: !_canConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
