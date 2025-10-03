// Path: services/websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nikosafe/utils/token_manager.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
  StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  bool _isConnected = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  bool get isConnected => _isConnected;

  Future<void> connect(int receiverId) async {
    if (_isConnected) {
      if (kDebugMode) print('WebSocket already connected');
      return;
    }

    try {
      final token = await TokenManager.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final wsUrl = '${AppUrl.ws_base_url}/ws/chat/?token=$token';

      if (kDebugMode) print('Connecting to WebSocket: $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Wait for connection to be established
      await _channel!.ready;

      _isConnected = true;
      _reconnectAttempts = 0;

      if (kDebugMode) print('✅ WebSocket connected successfully');

      // Listen to messages
      _channel!.stream.listen(
            (data) {
          if (kDebugMode) print('📩 Received: $data');
          try {
            final message = jsonDecode(data);
            _messageController.add(message);
          } catch (e) {
            if (kDebugMode) print('Error parsing message: $e');
          }
        },
        onError: (error) {
          if (kDebugMode) print('❌ WebSocket error: $error');
          _handleDisconnection();
        },
        onDone: () {
          if (kDebugMode) print('🔌 WebSocket connection closed');
          _handleDisconnection();
        },
        cancelOnError: false,
      );

    } catch (e) {
      if (kDebugMode) print('❌ Connection failed: $e');
      _isConnected = false;
      _handleDisconnection();
      rethrow;
    }
  }

  void _handleDisconnection() {
    _isConnected = false;

    // Auto-reconnect logic
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      final delay = Duration(seconds: _reconnectAttempts * 2);

      if (kDebugMode) {
        print('⏳ Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts/$_maxReconnectAttempts)');
      }

      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(delay, () {
        if (kDebugMode) print('🔄 Attempting reconnection...');
        // You'll need to store receiverId to reconnect
        // For now, emit an event that controller can listen to
        _messageController.add({'type': 'connection_lost'});
      });
    } else {
      if (kDebugMode) print('❌ Max reconnection attempts reached');
      _messageController.add({'type': 'connection_failed'});
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (!_isConnected || _channel == null) {
      if (kDebugMode) print('❌ Cannot send: WebSocket not connected');
      throw Exception('WebSocket not connected');
    }

    try {
      final jsonMessage = jsonEncode(message);
      if (kDebugMode) print('📤 Sending: $jsonMessage');
      _channel!.sink.add(jsonMessage);
    } catch (e) {
      if (kDebugMode) print('❌ Error sending message: $e');
      rethrow;
    }
  }

  void disconnect() {
    if (kDebugMode) print('🔌 Manually disconnecting WebSocket');
    _reconnectTimer?.cancel();
    _reconnectAttempts = _maxReconnectAttempts; // Prevent auto-reconnect
    _channel?.sink.close();
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}