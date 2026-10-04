import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
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

  bool _isLoadingOlderWithOffset = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);

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
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients ||
        _scrollController.position.pixels > 80) {
      return;
    }
    _loadOlderMessagesPreservingOffset();
  }

  Future<void> _loadOlderMessagesPreservingOffset() async {
    final state = ref.read(chatRoomProvider);
    if (_isLoadingOlderWithOffset ||
        !state.hasNext ||
        state.isLoadingOlderMessages ||
        state.chatId == null) {
      return;
    }

    _isLoadingOlderWithOffset = true;
    final oldMaxScrollExtent = _scrollController.hasClients
        ? _scrollController.position.maxScrollExtent
        : 0.0;
    final oldOffset = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;

    await ref.read(chatRoomProvider.notifier).loadOlderMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        _isLoadingOlderWithOffset = false;
        return;
      }

      final addedExtent =
          _scrollController.position.maxScrollExtent - oldMaxScrollExtent;
      final restoredOffset = (oldOffset + addedExtent)
          .clamp(
            _scrollController.position.minScrollExtent,
            _scrollController.position.maxScrollExtent,
          )
          .toDouble();
      _scrollController.jumpTo(restoredOffset);
      _isLoadingOlderWithOffset = false;
    });
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

    _messageController.clear();
    _scrollToBottom();
  }

  Future<void> _handleFilePressed() async {
    if (!_canSendAttachment()) return;

    final pickedFiles = await FilePicker.pickFiles();
    if (!mounted || pickedFiles.isEmpty) return;

    await _sendPickedFile(pickedFiles.first, ChatMessageType.file);
  }

  Future<void> _handleMediaPressed() async {
    if (!_canSendAttachment()) return;

    final pickedFiles = await FilePicker.pickFiles();
    if (!mounted || pickedFiles.isEmpty) return;

    final file = pickedFiles.first;
    final extension = _extensionOf(file.name);
    if (!_mediaExtensions.contains(extension)) {
      await _showUploadBlockedPopup(
        '이미지/영상 메뉴에서는 이미지 또는 영상만 선택할 수 있습니다.\n음원·문서 파일은 파일 메뉴를 이용해주세요.',
      );
      return;
    }

    final messageType = _isVideoFile(file.name)
        ? ChatMessageType.video
        : ChatMessageType.image;
    await _sendPickedFile(file, messageType);
  }

  bool _canSendAttachment() {
    final state = ref.read(chatRoomProvider);
    if (state.isDraft) {
      _showMessage('첫 메시지는 텍스트로 시작해주세요.');
      return false;
    }
    return !state.isSendingMessage;
  }

  Future<void> _sendPickedFile(
    PlatformFile file,
    ChatMessageType messageType,
  ) async {
    final path = file.path;
    if (path == null || path.isEmpty) {
      _showMessage('선택한 파일을 불러올 수 없습니다.');
      return;
    }

    final extension = _extensionOf(file.name);
    if (!_allowedUploadExtensions.contains(extension)) {
      await _showUploadBlockedPopup('지원하지 않는 파일 형식입니다.');
      return;
    }

    final fileSizeBytes = await file.length() ?? 0;
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
          fileName: file.name,
          fileSizeBytes: fileSizeBytes,
        );
    _scrollToBottom();

    await uploadFuture;
    if (!mounted) return;
    _scrollToBottom();
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
        .where((message) => message.messageType == ChatMessageType.image)
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
    final extension = _extensionOf(fileName);
    final type = message.messageType == ChatMessageType.video
        ? CloudPreviewFileType.video
        : _audioExtensions.contains(extension)
        ? CloudPreviewFileType.audio
        : extension == 'pdf'
        ? CloudPreviewFileType.document
        : CloudPreviewFileType.other;
    final local = message.createdAt.toLocal();

    return CloudFilePreviewItem(
      itemId: message.messageId,
      name: fileName,
      uploadedAt:
          '${local.year}.${local.month.toString().padLeft(2, '0')}.${local.day.toString().padLeft(2, '0')}',
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
    final fileName = ChatAttachmentMessageCard.resolveFileName(message);
    final success = await ref
        .read(cloudDownloadProvider.notifier)
        .downloadFiles([
          CloudDownloadRequest(
            itemId: message.messageId,
            fileName: fileName,
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
  }

  bool _isVideoFile(String fileName) {
    return _videoExtensions.contains(_extensionOf(fileName));
  }

  String _extensionOf(String fileName) {
    final index = fileName.lastIndexOf('.');
    if (index < 0 || index == fileName.length - 1) return '';
    return fileName.substring(index + 1).toLowerCase();
  }

  static const Set<String> _videoExtensions = {
    'mp4',
    'mov',
    'avi',
  };
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });
  }

  bool _isNearBottom() {
    if (!_scrollController.hasClients) return true;
    final position = _scrollController.position;
    return position.maxScrollExtent - position.pixels <= 160;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ChatRoomState>(chatRoomProvider, (previous, next) {
      final previousCount = previous?.messages.length ?? 0;
      final receivedNewMessage =
          next.messages.length > previousCount && !next.isLoadingOlderMessages;

      if (receivedNewMessage && _isNearBottom()) {
        _scrollToBottom();
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
            Expanded(child: _buildContent(state)),
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
                enabled: !state.isBusy,
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

    return _ChatMessageList(
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
    final leadingItemCount = isLoadingOlderMessages ? 1 : 0;

    return ListView.builder(
      controller: controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x16,
        0,
        AppSpacing.x16,
        AppSpacing.x24,
      ),
      itemCount: messages.length + pendingAttachments.length + leadingItemCount,
      itemBuilder: (context, index) {
        if (isLoadingOlderMessages && index == 0) {
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

        final contentIndex = index - leadingItemCount;
        if (contentIndex >= messages.length) {
          final pending = pendingAttachments[contentIndex - messages.length];
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

        final messageIndex = contentIndex;
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
              onImagePressed: message.messageType == ChatMessageType.image
                  ? () => onImagePressed(message)
                  : null,
              onAttachmentPressed:
                  message.messageType == ChatMessageType.file ||
                      message.messageType == ChatMessageType.video
                  ? () => onAttachmentPressed(message)
                  : null,
            ),
            if (messageGap > 0) SizedBox(height: messageGap),
          ],
        );
      },
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
      child: Center(
        child: Text(
          text,
          style: FontStyles.med12.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
          GroupChatProfile(
            imageUrls: profileImageUrls,
            size: isGroup ? 96 : 88,
          ),
          const SizedBox(height: AppSpacing.x16),
          Text(
            memberNames,
            textAlign: TextAlign.center,
            style: FontStyles.med16.copyWith(color: context.grays.black),
          ),
          const SizedBox(height: AppSpacing.x30),
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
