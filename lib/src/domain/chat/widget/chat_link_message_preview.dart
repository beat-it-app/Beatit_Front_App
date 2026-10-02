import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:beatit_front_app/src/domain/cloud/widget/cloud_link_preview_card.dart';

class ChatLinkMessagePreview extends StatefulWidget {
  const ChatLinkMessagePreview({super.key, required this.uri});

  final Uri uri;

  @override
  State<ChatLinkMessagePreview> createState() => _ChatLinkMessagePreviewState();
}

class _ChatLinkMessagePreviewState extends State<ChatLinkMessagePreview> {
  Metadata? _metadata;

  @override
  void initState() {
    super.initState();
    unawaited(_loadMetadata());
  }

  Future<void> _loadMetadata() async {
    try {
      final metadata = await MetadataFetch.extract(widget.uri.toString());
      if (!mounted) return;
      setState(() => _metadata = metadata);
    } catch (_) {
      // 링크 metadata가 없어도 domain 기반 카드 자체는 표시합니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    final host = widget.uri.host.startsWith('www.')
        ? widget.uri.host.substring(4)
        : widget.uri.host;
    final title = _metadata?.title?.trim();
    final image = _metadata?.image?.trim();
    final parsedImage = image == null || image.isEmpty
        ? null
        : Uri.tryParse(image);
    final imageUri = parsedImage == null
        ? null
        : parsedImage.hasScheme
        ? parsedImage
        : widget.uri.resolveUri(parsedImage);

    return SizedBox(
      width: 280,
      child: CloudLinkPreviewCard(
        title: title == null || title.isEmpty ? host : title,
        domain: host,
        imageUri: imageUri,
        onPressed: () => launchUrl(
          widget.uri,
          mode: LaunchMode.externalApplication,
        ),
      ),
    );
  }
}
