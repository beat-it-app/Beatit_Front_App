import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/utils/app_date_time_formatter.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_message_models.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_room_models.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_room_provider.dart';
import 'package:beatit_front_app/src/domain/chat/view/chat_image_preview_page.dart';
import 'package:beatit_front_app/src/domain/chat/widget/chat_attachment_message_card.dart';
import 'package:beatit_front_app/src/domain/chat/widget/chat_message_composer.dart';
import 'package:beatit_front_app/src/domain/chat/widget/chat_message_item.dart';
import 'package:beatit_front_app/src/domain/chat/widget/chat_pending_attachment_item.dart';
import 'package:beatit_front_app/src/domain/chat/widget/chat_room_app_bar.dart';
import 'package:beatit_front_app/src/domain/chat/widget/chat_room_name_popup.dart';
import 'package:beatit_front_app/src/domain/chat/widget/group_chat_profile.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_download_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_audio_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_other_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_video_preview.dart';
import 'package:beatit_front_app/src/domain/etc/model/team_member_search_result.dart';

class RoomChatPage extends ConsumerStatefulWidget {
  const RoomChatPage({
    super.key,
    this.chatId,
    required this.initialRoomName,
    required this.initialParticipantCount,
    this.initialProfileImageUrls = const <String>[],
    this.draftMembers = const <TeamMemberSearchResult>[],
  });

  final int? chatId;
  final String initialRoomName;
  final int initialParticipantCount;
  final List<String> initialProfileImageUrls;
  final List<TeamMemberSearchResult> draftMembers;

  bool get isDraft => chatId == null;

  @override
  ConsumerState<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends ConsumerState<RoomChatPage> {
  static const int _maxAttachmentBytes = 50 * 1024 * 1024;

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isProgrammaticScroll = false;
  final ImagePicker _imagePicker = ImagePicker();

  bool _isLoadingOlderPage = false;
  int? _autoFillRequestedPage;
  bool _isDownloadingChatAttachment = false;
  ChatMessage? _latestUnseenMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _messageFocusNode.addListener(_handleComposerFocusChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isDraft) {
        ref
            .read(chatRoomProvider.notifier)
            .initializeDraft(
              roomName: widget.initialRoomName,
              participantCount: widget.initialParticipantCount,
              profileImageUrls: widget.initialProfileImageUrls,
            );
        return;
      }

      ref
          .read(chatRoomProvider.notifier)
          .loadExistingRoom(
            chatId: widget.chatId!,
            initialRoomName: widget.initialRoomName,
            initialParticipantCount: widget.initialParticipantCount,
            initialProfileImageUrls: widget.initialProfileImageUrls,
          );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _messageFocusNode.removeListener(_handleComposerFocusChanged);
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    if (_isProgrammaticScroll) return;
    if (_latestUnseenMessage != null && _isNearBottom()) {
      setState(() => _latestUnseenMessage = null);
    }

    // Reversed list: position 0 is the newest message, maxScrollExtent is
    // the oldest currently loaded message. No offset restoration is needed
    // when an older page is appended to the *top* of the rendered list.
    final position = _scrollController.position;
    if (position.maxScrollExtent > 0 &&
        position.pixels >= position.maxScrollExtent - 80) {
      _loadOlderMessages();
    }
  }

  void _handleComposerFocusChanged() {
    if (_messageFocusNode.hasFocus) {
      _goToLatestMessage(animated: false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messageFocusNode.hasFocus &&
        MediaQuery.viewInsetsOf(context).bottom > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _messageFocusNode.hasFocus) {
          _goToLatestMessage(animated: false);
        }
      });
    }
  }

  Future<void> _loadOlderMessages() async {
    final state = ref.read(chatRoomProvider);
    if (_isLoadingOlderPage ||
        !state.hasNext ||
        state.isLoadingOlderMessages ||
        state.isInitialLoading ||
        state.chatId == null) {
      return;
    }

    _isLoadingOlderPage = true;
    try {
      // Newer items keep their indices in the reversed list. Loading an
      // older page therefore cannot drag the user's viewport down.
      await ref.read(chatRoomProvider.notifier).loadOlderMessages();
    } finally {
      _isLoadingOlderPage = false;
    }
  }

  void _maybeLoadOlderToFill() {
    if (!mounted || !_scrollController.hasClients) return;
    final state = ref.read(chatRoomProvider);
    if (state.isInitialLoading ||
        state.isLoadingOlderMessages ||
        !state.hasNext ||
        state.chatId == null ||
        _scrollController.position.maxScrollExtent > 0 ||
        _autoFillRequestedPage == state.currentPage) {
      return;
    }

    // Even 30 very short messages may fit in the viewport. In that case
    // there is no scroll gesture to trigger pagination; load one more page.
    _autoFillRequestedPage = state.currentPage;
    _loadOlderMessages();
  }

  Future<void> _handleSend(String message) async {
    final state = ref.read(chatRoomProvider);
    final notifier = ref.read(chatRoomProvider.notifier);

    final bool success;
    if (state.isDraft) {
      final participantIds = widget.draftMembers
          .map((member) => member.userId)
          .whereType<int>()
          .toList(growable: false);

      if (participantIds.length != widget.draftMembers.length) {
        _showMessage('멤버 정보를 확인할 수 없습니다.');
        return;
      }

      success = await notifier.createRoom(
        participantIds: participantIds,
        firstMessageContent: message,
      );
    } else {
      success = await notifier.sendTextMessage(message);
    }

    if (!mounted) return;
    if (!success) {
      _showCurrentError();
      return;
    }

    // Keep focus (and the keyboard) while sending; do not erase a newer draft.
    if (_messageController.text.trim() == message) {
      _messageController.clear();
    }
    _goToLatestMessage();
  }

  Future<void> _handleFilePressed() async {
    if (!_canSendAttachment()) return;

    final pickedFiles = await FilePicker.pickFiles();
    if (!mounted || pickedFiles.isEmpty) return;

    final file = pickedFiles.first;
    final path = file.path;
    if (path == null || path.isEmpty) {
      _showMessage('선택한 파일을 불러올 수 없습니다.');
      return;
    }

    final extension = _extensionOf(file.name);
    final messageType = _imageExtensions.contains(extension)
        ? ChatMessageType.image
        : _videoExtensions.contains(extension)
        ? ChatMessageType.video
        : ChatMessageType.file;

    final fileSizeBytes = await file.length() ?? 0;
    await _sendPickedAttachment(
      path: path,
      fileName: file.name,
      fileSizeBytes: fileSizeBytes,
      messageType: messageType,
    );
  }

  Future<void> _handleMediaPressed() async {
    if (!_canSendAttachment()) return;

    final messageType = await _showMediaTypePicker();
    if (!mounted || messageType == null) return;

    final XFile? pickedMedia;
    if (messageType == ChatMessageType.video) {
      pickedMedia = await _imagePicker.pickVideo(source: ImageSource.gallery);
    } else {
      pickedMedia = await _imagePicker.pickImage(source: ImageSource.gallery);
    }

    if (!mounted || pickedMedia == null) return;

    final extension = _extensionOf(pickedMedia.name);
    if (!_mediaExtensions.contains(extension)) {
      await _showUploadBlockedPopup('지원하지 않는 이미지 또는 영상 형식입니다.');
      return;
    }

    await _sendPickedAttachment(
      path: pickedMedia.path,
      fileName: pickedMedia.name,
      fileSizeBytes: await pickedMedia.length(),
      messageType: messageType,
    );
  }

  Future<ChatMessageType?> _showMediaTypePicker() {
    return showModalBottomSheet<ChatMessageType>(
      context: context,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: Text(
                  '사진',
                  style: FontStyles.med16.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ChatMessageType.image),
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: Text(
                  '동영상',
                  style: FontStyles.med16.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ChatMessageType.video),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _canSendAttachment() {
    final state = ref.read(chatRoomProvider);
    if (state.isDraft) {
      _showMessage('첫 메시지는 텍스트로 시작해주세요.');
      return false;
    }
    return !state.isSendingMessage;
  }

  Future<void> _sendPickedAttachment({
    required String path,
    required String fileName,
    required int fileSizeBytes,
    required ChatMessageType messageType,
  }) async {
    final extension = _extensionOf(fileName);
    if (!_allowedUploadExtensions.contains(extension)) {
      await _showUploadBlockedPopup('지원하지 않는 파일 형식입니다.');
      return;
    }

    if (fileSizeBytes <= 0) {
      _showMessage('빈 파일은 전송할 수 없습니다.');
      return;
    }
    if (fileSizeBytes > _maxAttachmentBytes) {
      await _showUploadBlockedPopup('50MB를 초과하는 파일은 업로드할 수 없습니다.');
      return;
    }

    final uploadFuture = ref
        .read(chatRoomProvider.notifier)
        .sendAttachmentMessage(
          messageType: messageType,
          filePath: path,
          fileName: fileName,
          fileSizeBytes: fileSizeBytes,
        );
    _goToLatestMessage();

    await uploadFuture;
    if (!mounted) return;
    _goToLatestMessage();
  }

  Future<void> _showUploadBlockedPopup(String content) async {
    if (!mounted) return;
    await AppPopup.show(
      context,
      title: '업로드할 수 없는 파일입니다.',
      content: content,
      warningType: WarningType.triangle,
      confirmText: '확인',
    );
  }

  Future<void> _handleRenameRoom() async {
    final state = ref.read(chatRoomProvider);
    if (state.isDraft || state.chatId == null) return;

    final roomName = await showChatRoomNamePopup(
      context,
      initialName: state.roomName,
    );
    if (!mounted || roomName == null || roomName == state.roomName) return;

    final success = await ref
        .read(chatRoomProvider.notifier)
        .renameRoom(roomName);
    if (!mounted || success) return;
    _showCurrentError();
  }

  Future<void> _handleLeaveRoom() async {
    final state = ref.read(chatRoomProvider);
    if (state.isDraft || state.chatId == null) return;

    final confirmed = await AppPopup.show(
      context,
      title: '채팅방을 나가시겠습니까?',
      content: '채팅방을 나가면 대화 내용은\n복구되지 않습니다.',
      buttonNum: ButtonNum.two,
      warningType: WarningType.circle,
      confirmText: '확인',
      cancelText: '취소',
    );
    if (!mounted || confirmed != true) return;

    final success = await ref.read(chatRoomProvider.notifier).leaveRoom();
    if (!mounted) return;
    if (!success) {
      _showCurrentError();
      return;
    }

    Navigator.of(context).pop();
  }

  void _openImagePreview(ChatMessage selectedMessage) {
    final images = ref
        .read(chatRoomProvider)
        .messages
        .where((message) => _attachmentKind(message) == ChatAttachmentKind.image)
        .toList(growable: false);
    if (images.isEmpty) return;

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ChatImagePreviewPage(
          images: images,
          initialMessageId: selectedMessage.messageId,
          onDownloadPressed: _downloadChatMessage,
        ),
      ),
    );
  }

  void _openAttachmentPreview(ChatMessage message) {
    final fileName = ChatAttachmentMessageCard.resolveFileName(message);
    final kind = ChatAttachmentMessageCard.kindFor(
      messageType: message.messageType,
      fileName: fileName,
      mimeType: message.attachmentMimeType,
    );

    if (kind == ChatAttachmentKind.image) {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => ChatImagePreviewPage(
            images: [message],
            initialMessageId: message.messageId,
            onDownloadPressed: _downloadChatMessage,
          ),
        ),
      );
      return;
    }

    final previewItem = _toCloudPreviewItem(message);
    final preview = switch (previewItem.type) {
      CloudPreviewFileType.audio => CloudAudioPreview(
        files: [previewItem],
        canManage: false,
        onDownloadPressed: (_) => _downloadChatMessage(message),
      ),
      CloudPreviewFileType.video => CloudVideoPreview(
        files: [previewItem],
        canManage: false,
        onDownloadPressed: (_) => _downloadChatMessage(message),
      ),
      CloudPreviewFileType.document => CloudFilePreview(
        files: [previewItem],
        canManage: false,
        onDownloadPressed: (_) => _downloadChatMessage(message),
      ),
      _ => CloudOtherFilePreview(
        files: [previewItem],
        canManage: false,
        onDownloadPressed: (_) => _downloadChatMessage(message),
      ),
    };

    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => preview));
  }

  CloudFilePreviewItem _toCloudPreviewItem(ChatMessage message) {
    final fileName = ChatAttachmentMessageCard.resolveFileName(message);
    final kind = ChatAttachmentMessageCard.kindFor(
      messageType: message.messageType,
      fileName: fileName,
      mimeType: message.attachmentMimeType,
    );
    final type = switch (kind) {
      ChatAttachmentKind.audio => CloudPreviewFileType.audio,
      ChatAttachmentKind.video => CloudPreviewFileType.video,
      ChatAttachmentKind.document => CloudPreviewFileType.document,
      _ => CloudPreviewFileType.other,
    };
    return CloudFilePreviewItem(
      itemId: message.messageId,
      name: fileName,
      uploadedAt: AppDateTimeFormatter.formatDate(message.createdAt),
      uploaderName: message.senderName,
      type: type,
      iconPath: ChatAttachmentMessageCard.iconPathFor(message),
      previewUri: Uri.tryParse(message.content),
      sizeLabel: ChatAttachmentMessageCard.formatFileSize(
        message.attachmentSizeBytes,
      ),
      mimeType: message.attachmentMimeType,
    );
  }

  Future<void> _downloadChatMessage(ChatMessage message) async {
    // Repeated taps must not turn a successful in-flight download into a
    // misleading failure snackbar (downloadFiles returns false when busy).
    if (_isDownloadingChatAttachment) return;
    if (ref.read(cloudDownloadProvider).isDownloading) {
      _showMessage('다른 파일을 다운로드하고 있습니다.');
      return;
    }

    _isDownloadingChatAttachment = true;
    try {
      final success = await ref
          .read(cloudDownloadProvider.notifier)
          .downloadFiles([
            CloudDownloadRequest(
              itemId: message.messageId,
              fileName: ChatAttachmentMessageCard.resolveFileName(message),
              fileUrl: message.content,
              mimeType: message.attachmentMimeType,
            ),
          ]);
      if (!mounted) return;

      final downloadState = ref.read(cloudDownloadProvider);
      _showMessage(
        success
            ? 'Downloads 폴더에 저장했습니다.'
            : downloadState.errorMessage ?? '파일 다운로드에 실패했습니다.',
      );
    } catch (error) {
      if (mounted) _showMessage('파일 다운로드 중 오류가 발생했습니다.');
    } finally {
      _isDownloadingChatAttachment = false;
    }
  }

  String _extensionOf(String fileName) {
    final index = fileName.lastIndexOf('.');
    if (index < 0 || index == fileName.length - 1) return '';
    return fileName.substring(index + 1).toLowerCase();
  }

  static const Set<String> _videoExtensions = {'mp4', 'mov', 'avi'};
  static const Set<String> _imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'heic',
  };
  static const Set<String> _mediaExtensions = {
    ..._imageExtensions,
    ..._videoExtensions,
  };
  static const Set<String> _audioExtensions = {
    'mp3',
    'wav',
    'm4a',
    'aac',
    'flac',
    'ogg',
  };
  static const Set<String> _allowedUploadExtensions = {
    ..._imageExtensions,
    ..._audioExtensions,
    ..._videoExtensions,
    'pdf',
    'zip',
    'hwp',
    'docx',
  };

  void _showCurrentError() {
    final errorMessage = ref.read(chatRoomProvider).errorMessage;
    if (errorMessage != null) _showMessage(errorMessage);
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  ChatAttachmentKind _attachmentKind(ChatMessage message) {
    return ChatAttachmentMessageCard.kindFor(
      messageType: message.messageType,
      fileName: ChatAttachmentMessageCard.resolveFileName(message),
      mimeType: message.attachmentMimeType,
    );
  }

  void _goToLatestMessage({bool animated = true}) {
    if (_latestUnseenMessage != null) {
      setState(() => _latestUnseenMessage = null);
    }
    if (!_scrollController.hasClients) return;

    // In a reversed list, 0 is the latest edge from the very first frame.
    // No end-of-list measurement, repeated jump, or post-frame polling.
    if (!animated) {
      _isProgrammaticScroll = true;
      _scrollController.jumpTo(0);
      _isProgrammaticScroll = false;
      return;
    }
    _isProgrammaticScroll = true;
    _scrollController
        .animateTo(
          0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        )
        .whenComplete(() {
          if (mounted) _isProgrammaticScroll = false;
        });
  }

  bool _isNearBottom() {
    if (!_scrollController.hasClients) return true;
    return _scrollController.position.pixels <= 160;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ChatRoomState>(chatRoomProvider, (previous, next) {
      // Reset the pagination autofill gate when a different room is opened.
      if (previous?.chatId != next.chatId ||
          (next.isInitialLoading && previous?.isInitialLoading == false)) {
        _autoFillRequestedPage = null;
        _latestUnseenMessage = null;
      }

      // The first page already appears at offset 0; no initial scroll call.
      // If the loaded page does not fill the screen, fetch older pages until
      // the room becomes scrollable or the server reports hasNext=false.
      if (!next.isInitialLoading && next.hasNext &&
          (previous?.isInitialLoading == true ||
              previous?.currentPage != next.currentPage)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _maybeLoadOlderToFill();
        });
      }

      final previousLatest = previous?.messages.isNotEmpty == true
          ? previous!.messages.last.messageId
          : null;
      final latest = next.messages.isNotEmpty ? next.messages.last : null;
      final receivedNewMessage =
          latest != null &&
          !next.isInitialLoading &&
          !next.isLoadingOlderMessages &&
          previousLatest != null &&
          latest.messageId > previousLatest;

      if (receivedNewMessage) {
        if (_isNearBottom()) {
          _goToLatestMessage(animated: false);
        } else {
          setState(() => _latestUnseenMessage = latest);
        }
      }
    });

    final state = ref.watch(chatRoomProvider);
    final roomName = _resolvedRoomName(state);
    final participantCount = _resolvedParticipantCount(state);
    final menuEnabled = !state.isDraft && state.chatId != null;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: ChatRoomAppBar(
        roomName: roomName,
        participantCount: participantCount,
        onBackPressed: () => Navigator.of(context).maybePop(),
        moreMenuOffset: const Offset(-16, 40),
        moreMenuItems: [
          AppDropdownItem(
            label: '이름 수정하기',
            enabled: menuEnabled,
            onPressed: _handleRenameRoom,
          ),
          AppDropdownItem(
            label: '채팅방 나가기',
            enabled: menuEnabled,
            onPressed: _handleLeaveRoom,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: _buildContent(state)),
                  if (_latestUnseenMessage != null)
                    Positioned(
                      left: AppSpacing.x16,
                      right: AppSpacing.x16,
                      bottom: AppSpacing.x12,
                      child: _ChatNewMessageBanner(
                        message: _latestUnseenMessage!,
                        onPressed: _goToLatestMessage,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x8,
                AppSpacing.x8,
                AppSpacing.x16,
                AppSpacing.x12,
              ),
              child: ChatMessageComposer(
                controller: _messageController,
                focusNode: _messageFocusNode,
                hintText: '대화 시작하기',
                // Keep the input focused while async send state changes.
                canSend: !state.isBusy,
                onSend: _handleSend,
                onFilePressed: _handleFilePressed,
                onMediaPressed: _handleMediaPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ChatRoomState state) {
    if (state.isInitialLoading && state.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null &&
        state.messages.isEmpty &&
        !state.isDraft) {
      return _RoomError(
        message: state.errorMessage!,
        onRetry: () => _retryCurrentRoom(state),
      );
    }

    if (state.messages.isEmpty && state.pendingAttachments.isEmpty) {
      return _EmptyRoomContent(
        roomType: state.roomType,
        roomName: state.roomName,
        profileImageUrls: state.profileImageUrls,
        draftMembers: widget.draftMembers,
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // A gesture must take precedence over a tap-to-latest animation.
        if (notification is ScrollStartNotification &&
            notification.dragDetails != null) {
          _isProgrammaticScroll = false;
        }
        return false;
      },
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical &&
              notification.metrics.maxScrollExtent <= 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _maybeLoadOlderToFill();
            });
          }
          return false;
        },
        child: _ChatMessageList(
          controller: _scrollController,
          messages: state.messages,
          pendingAttachments: state.pendingAttachments,
          isLoadingOlderMessages: state.isLoadingOlderMessages,
          onImagePressed: _openImagePreview,
          onAttachmentPressed: _openAttachmentPreview,
          onRetryPending: (localId) {
            ref.read(chatRoomProvider.notifier).retryAttachment(localId);
          },
          onDeletePending: (localId) {
            ref.read(chatRoomProvider.notifier).removePendingAttachment(localId);
          },
        ),
      ),
    );
  }

  void _retryCurrentRoom(ChatRoomState state) {
    final chatId = state.chatId ?? widget.chatId;
    if (chatId == null) return;

    ref
        .read(chatRoomProvider.notifier)
        .loadExistingRoom(
          chatId: chatId,
          initialRoomName: state.roomName.isEmpty
              ? widget.initialRoomName
              : state.roomName,
          initialParticipantCount: state.participantCount == 0
              ? widget.initialParticipantCount
              : state.participantCount,
          initialProfileImageUrls: state.profileImageUrls.isEmpty
              ? widget.initialProfileImageUrls
              : state.profileImageUrls,
        );
  }

  String _resolvedRoomName(ChatRoomState state) {
    return state.roomName.isEmpty ? widget.initialRoomName : state.roomName;
  }

  int _resolvedParticipantCount(ChatRoomState state) {
    return state.participantCount == 0
        ? widget.initialParticipantCount
        : state.participantCount;
  }
}

class _ChatNewMessageBanner extends StatelessWidget {
  const _ChatNewMessageBanner({
    required this.message,
    required this.onPressed,
  });

  final ChatMessage message;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final kind = ChatAttachmentMessageCard.kindFor(
      messageType: message.messageType,
      fileName: ChatAttachmentMessageCard.resolveFileName(message),
      mimeType: message.attachmentMimeType,
    );
    final preview = switch (kind) {
      ChatAttachmentKind.video => '동영상을 보냈습니다.',
      ChatAttachmentKind.image => '사진을 보냈습니다.',
      ChatAttachmentKind.audio => '음성 파일을 보냈습니다.',
      ChatAttachmentKind.document || ChatAttachmentKind.file =>
        '파일을 보냈습니다.',
    };
    final text = message.messageType == ChatMessageType.text ||
            message.messageType == ChatMessageType.unknown ||
            message.messageType == ChatMessageType.system
        ? message.content
        : preview;

    final profileUrl = message.profileImageUrl;

    return Material(
      color: context.grays.white.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x12,
            AppSpacing.x8,
            AppSpacing.x8,
            AppSpacing.x8,
          ),
          child: Row(
            children: [
              GroupChatProfile(
                imageUrls: profileUrl != null && profileUrl.trim().isNotEmpty
                    ? <String>[profileUrl]
                    : const <String>[],
                size: 36,
              ),
              const SizedBox(width: AppSpacing.x8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.isMine ? '나' : message.senderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.semi14.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                    Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.med14.copyWith(
                        color: context.grays.gray2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x12),
              CircleAvatar(
                backgroundColor: context.brands.beatOrange1,
                child: Icon(
                  Icons.arrow_downward_rounded,
                  color: context.grays.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatMessageList extends StatelessWidget {
  const _ChatMessageList({
    required this.controller,
    required this.messages,
    required this.pendingAttachments,
    required this.isLoadingOlderMessages,
    required this.onImagePressed,
    required this.onAttachmentPressed,
    required this.onRetryPending,
    required this.onDeletePending,
  });

  final ScrollController controller;
  final List<ChatMessage> messages;
  final List<ChatPendingAttachment> pendingAttachments;
  final bool isLoadingOlderMessages;
  final ValueChanged<ChatMessage> onImagePressed;
  final ValueChanged<ChatMessage> onAttachmentPressed;
  final ValueChanged<String> onRetryPending;
  final ValueChanged<String> onDeletePending;

  @override
  Widget build(BuildContext context) {
    final contentCount = messages.length + pendingAttachments.length;

    // Index 0 is the newest item, rendered at the bottom when scrollable.
    // shrinkWrap + Align keeps short conversations at the top. Only the
    // initial 30-item page needs shrinkWrap; for additional loaded pages,
    // use a normal lazy viewport to avoid repeated size calculations.
    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        controller: controller,
        reverse: true,
        shrinkWrap: contentCount <= 30,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x16,
          0,
          AppSpacing.x16,
          AppSpacing.x10,
        ),
        itemCount: contentCount + (isLoadingOlderMessages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == contentCount) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.x12),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          if (index < pendingAttachments.length) {
            final pending = pendingAttachments[
                pendingAttachments.length - index - 1];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x16),
              child: ChatPendingAttachmentItem(
                key: ValueKey(pending.localId),
                attachment: pending,
                onRetry: () => onRetryPending(pending.localId),
                onDelete: () => onDeletePending(pending.localId),
              ),
            );
          }

          final messageIndex =
              messages.length - 1 - (index - pendingAttachments.length);
          final message = messages[messageIndex];
          final previousMessage = messageIndex > 0
              ? messages[messageIndex - 1]
              : null;
          final nextMessage = messageIndex < messages.length - 1
              ? messages[messageIndex + 1]
              : null;
          final showDateLabel =
              previousMessage == null ||
              !_isSameDate(previousMessage.createdAt, message.createdAt);
          final isGroupStart =
              previousMessage == null ||
              !_isSameMessageGroup(previousMessage, message);
          final isGroupEnd =
              nextMessage == null || !_isSameMessageGroup(message, nextMessage);
          final isLastMessage =
              messageIndex == messages.length - 1 && pendingAttachments.isEmpty;

          final messageGap = isLastMessage
              ? 0.0
              : isGroupEnd
              ? AppSpacing.x16
              : AppSpacing.x4;

          return Column(
            children: [
              if (showDateLabel) ...[
                _ChatSectionLabel(text: _formatDate(message.createdAt)),
                const SizedBox(height: AppSpacing.x8),
              ],
              ChatMessageItem(
                key: ValueKey(message.messageId),
                message: message,
                showProfile: isGroupStart,
                showSenderName: isGroupStart,
                showTime: isGroupEnd,
                onImagePressed: _kindOf(message) == ChatAttachmentKind.image
                    ? () => onImagePressed(message)
                    : null,
                onAttachmentPressed:
                    _kindOf(message) != ChatAttachmentKind.image &&
                            message.messageType != ChatMessageType.text &&
                            message.messageType != ChatMessageType.system
                        ? () => onAttachmentPressed(message)
                        : null,
              ),
              if (messageGap > 0) SizedBox(height: messageGap),
            ],
          );
        },
      ),
    );
  }

  static ChatAttachmentKind _kindOf(ChatMessage message) {
    return ChatAttachmentMessageCard.kindFor(
      messageType: message.messageType,
      fileName: ChatAttachmentMessageCard.resolveFileName(message),
      mimeType: message.attachmentMimeType,
    );
  }

  static bool _isSameMessageGroup(ChatMessage a, ChatMessage b) {
    if (a.messageType == ChatMessageType.system ||
        b.messageType == ChatMessageType.system) {
      return false;
    }
    if (a.senderId != b.senderId) return false;

    final first = a.createdAt.toLocal();
    final second = b.createdAt.toLocal();
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day &&
        first.hour == second.hour &&
        first.minute == second.minute;
  }

  static bool _isSameDate(DateTime a, DateTime b) {
    final first = a.toLocal();
    final second = b.toLocal();
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  static String _formatDate(DateTime value) {
    final local = value.toLocal();
    const weekdays = <String>['월', '화', '수', '목', '금', '토', '일'];
    return '${local.year}년 ${local.month}월 ${local.day}일 ${weekdays[local.weekday - 1]}요일';
  }
}

class _ChatSectionLabel extends StatelessWidget {
  const _ChatSectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: FontStyles.med16.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _EmptyRoomContent extends StatelessWidget {
  const _EmptyRoomContent({
    required this.roomType,
    required this.roomName,
    required this.profileImageUrls,
    required this.draftMembers,
  });

  final ChatRoomType roomType;
  final String roomName;
  final List<String> profileImageUrls;
  final List<TeamMemberSearchResult> draftMembers;

  @override
  Widget build(BuildContext context) {
    final isGroup = roomType == ChatRoomType.group;
    final memberNames = draftMembers.isEmpty
        ? roomName
        : [
            ...draftMembers.map((member) => member.userName),
            if (isGroup) '나',
          ].join(', ');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x16,
        0,
        AppSpacing.x16,
        AppSpacing.x24,
      ),
      child: Column(
        children: [
          _ChatSectionLabel(text: _formatToday()),
          const SizedBox(height: AppSpacing.x70),
          const SizedBox(height: AppSpacing.x20),
          GroupChatProfile(
            imageUrls: profileImageUrls,
            size: isGroup ? 96 : 88,
          ),
          const SizedBox(height: AppSpacing.x20),
          Text(
            memberNames,
            textAlign: TextAlign.center,
            style: FontStyles.med18.copyWith(color: context.grays.black),
          ),
          const SizedBox(height: AppSpacing.x40),
          Text(
            isGroup ? '단체 채팅 준비가 완료되었습니다.' : '채팅 기록이 없습니다.',
            textAlign: TextAlign.center,
            style: FontStyles.bold22.copyWith(color: context.grays.black),
          ),
          const SizedBox(height: AppSpacing.x8),
          Text(
            '채팅을 시작해보세요.',
            textAlign: TextAlign.center,
            style: FontStyles.med16.copyWith(color: context.grays.gray5),
          ),
        ],
      ),
    );
  }

  String _formatToday() {
    final now = DateTime.now();
    const weekdays = <String>['월', '화', '수', '목', '금', '토', '일'];
    return '${now.year}년 ${now.month}월 ${now.day}일 ${weekdays[now.weekday - 1]}요일';
  }
}

class _RoomError extends StatelessWidget {
  const _RoomError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: FontStyles.med14.copyWith(color: context.grays.gray5),
            ),
            const SizedBox(height: AppSpacing.x12),
            TextButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
