import 'dart:async';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../constants/baseUrl.dart';

class WebSocketChat {
  static const int MAX_RECONNECT_ATTEMPTS = 5;
  static const int RECONNECT_INTERVAL = 3000;
  static const int MESSAGE_TIMEOUT = 30000;

  StompClient? _stompClient;
  final _messageQueue = <Map<String, dynamic>>[];
  Timer? _reconnectTimer;
  final _subscriptions = <String>[];
  final _pendingMessages = <String>{};

  // Stream controller để phát tín hiệu connection status
  final _connectionStatusController = StreamController<String>.broadcast();
  Stream<String> get connectionStatus => _connectionStatusController.stream;

  // Stream controller để nhận messages
  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messages => _messageController.stream;

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer YOUR_JWT_TOKEN',
  };

  void initializeWebSocket() {
    if (_stompClient?.connected ?? false) return;
    print("URL : " + websocketUrl);

    _stompClient = StompClient(
      config: StompConfig(
        url: '$websocketUrl/socket-service/ws',
        onConnect: _onConnect,
        onDisconnect: _onDisconnect,
        onStompError: _onStompError,
        onWebSocketError: _onWebSocketError,
        reconnectDelay: const Duration(seconds: 5000),
        heartbeatIncoming: const Duration(seconds: 4000),
        heartbeatOutgoing: const Duration(seconds: 4000),
      ),
    );

    _stompClient?.activate();
  }

  void _onConnect(StompFrame frame) {
    print('WebSocket Connected');
    _connectionStatusController.add('connected');
    _subscribeToTopics();
    _processMessageQueue();
  }

  void _onDisconnect(StompFrame frame) {
    print('WebSocket Disconnected');
    _connectionStatusController.add('disconnected');
    _handleReconnect();
  }

  void _onStompError(StompFrame frame) {
    print('STOMP error: ${frame.body}');
    _connectionStatusController.add('error');
  }

  void _onWebSocketError(dynamic error) {
    print('WebSocket error: $error');
    _connectionStatusController.add('error');
  }

  void _subscribeToTopics() {
    if (!(_stompClient?.connected ?? false)) return;

    // Subscribe to public channel
    _stompClient?.subscribe(
      destination: '/server/public',
      callback: (frame) {
        print('Public message received: ${frame.body}');
      },
    );

    // Subscribe to data channel
    _stompClient?.subscribe(
      destination: '/server/sendData',
      callback: (frame) {
        try {
          final messageId = frame.headers['message-id'];
          final parsedResponse = jsonDecode(frame.body ?? '');
          final answer = parsedResponse['answer']['fullAnswer'];

          if (messageId != null && _pendingMessages.contains(messageId)) {
            _pendingMessages.remove(messageId);
          }

          _messageController.add(answer);
        } catch (e) {
          print('Error processing message: $e');
        }
      },
    );
  }

  void _handleReconnect() {
    int reconnectAttempts = 0;

    void attemptReconnect() {
      if (reconnectAttempts >= MAX_RECONNECT_ATTEMPTS) {
        print('Max reconnection attempts reached');
        _connectionStatusController.add('failed');
        return;
      }

      reconnectAttempts++;
      print('Reconnection attempt $reconnectAttempts');
      initializeWebSocket();
    }

    _reconnectTimer = Timer(
      Duration(milliseconds: RECONNECT_INTERVAL),
      attemptReconnect,
    );
  }

  void _processMessageQueue() {
    if (!(_stompClient?.connected ?? false)) return;

    while (_messageQueue.isNotEmpty) {
      final message = _messageQueue.removeAt(0);
      _sendMessageToServer(message['content'], message['messageId']);
    }
  }

  void _sendMessageToServer(String content, String messageId) {
    if (!(_stompClient?.connected ?? false)) {
      _messageQueue.add({'content': content, 'messageId': messageId});
      initializeWebSocket();
      return;
    }

    try {
      final headers = {
        'message-id': messageId,
        'content-type': 'application/json',
      };

      _stompClient?.send(
        destination: '/web/sendMessage',
        body: jsonEncode({'content': content, 'messageId': messageId}),
        headers: headers,
      );

      // Set timeout for message
      Timer(Duration(milliseconds: MESSAGE_TIMEOUT), () {
        if (_pendingMessages.contains(messageId)) {
          _pendingMessages.remove(messageId);
          print('Message $messageId timed out');
        }
      });
    } catch (e) {
      print('Error sending message: $e');
      _messageQueue.add({'content': content, 'messageId': messageId});
    }
  }

  String sendMessage(String content) {
    if (content.trim().isEmpty) return '';

    final messageId = Uuid().v4();
    _pendingMessages.add(messageId);

    _sendMessageToServer(content.trim(), messageId);

    return messageId;
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _stompClient?.deactivate();
    _connectionStatusController.close();
    _messageController.close();
  }
}
