import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:beatit_front_app/src/core/network/auth_token_storage.dart';

class ChatSocketApi {
  ChatSocketApi({
    required String baseUrl,
    required AuthTokenStorage tokenStorage,
  }) : _baseUri = Uri.parse(baseUrl),
       _tokenStorage = tokenStorage;

  final Uri _baseUri;
  final AuthTokenStorage _tokenStorage;

  Uri socketUriFor(int chatId) {
    final socketScheme = switch (_baseUri.scheme.toLowerCase()) {
      'https' => 'wss',
      'wss' => 'wss',
      'ws' => 'ws',
      _ => 'ws',
    };

    return _baseUri.replace(
      scheme: socketScheme,
      path: '/ws/chat/$chatId',
      query: null,
      fragment: null,
    );
  }

  Future<ChatSocketConnection> connect({required int chatId}) async {
    final socketUri = socketUriFor(chatId);
    final accessToken = await _tokenStorage.readAccessToken();
    final headers = <String, dynamic>{
      if (accessToken != null && accessToken.isNotEmpty)
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    };

    debugPrint(
      '[Chat WS] CONNECT START | chatId=$chatId | '
      'baseUrl=$_baseUri | uri=$socketUri | '
      'auth=${accessToken != null && accessToken.isNotEmpty}',
    );

    try {
      final socket = await WebSocket.connect(
        socketUri.toString(),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      socket.pingInterval = const Duration(seconds: 20);

      debugPrint(
        '[Chat WS] CONNECTED | chatId=$chatId | uri=$socketUri | '
        'readyState=${socket.readyState} | protocol=${socket.protocol}',
      );

      return ChatSocketConnection._(
        socket: socket,
        chatId: chatId,
        uri: socketUri,
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[Chat WS] CONNECT FAILED | chatId=$chatId | uri=$socketUri | '
        'error=$error',
      );
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }
}

class ChatSocketConnection {
  ChatSocketConnection._({
    required WebSocket socket,
    required this.chatId,
    required this.uri,
  }) : _socket = socket;

  final WebSocket _socket;
  final int chatId;
  final Uri uri;

  Stream<String> get messages => _socket
      .where((event) => event is String)
      .cast<String>();

  int get readyState => _socket.readyState;

  Future<void> close() async {
    if (_socket.readyState == WebSocket.closed ||
        _socket.readyState == WebSocket.closing) {
      return;
    }

    debugPrint(
      '[Chat WS] CLOSE | chatId=$chatId | uri=$uri | '
      'readyState=${_socket.readyState}',
    );

    await _socket.close(
      WebSocketStatus.normalClosure,
      'chat room closed',
    );
  }
}
