import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nikosafe/utils/token_manager.dart';

class ServiceWebSocketService {
  static final ServiceWebSocketService _instance = ServiceWebSocketService._internal();
  factory ServiceWebSocketService() => _instance;
  ServiceWebSocketService._internal();

  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
  StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  bool _isConnected = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  bool get isConnected => _isConnected;

  Future<void> connect(int providerId) async {
    if (_isConnected) {
      if (kDebugMode) print('Service WebSocket already connected');
      return;
    }

    try {
      final token = await TokenManager.getAccessToken();
      if (token == null) throw Exception('No access token');

      final wsUrl = '${AppUrl.ws_base_url}/ws/provider-chat/?token=$token';
      if (kDebugMode) print('🔌 Connecting to Service WebSocket: $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      await _channel!.ready;

      _isConnected = true;
      _reconnectAttempts = 0;

      if (kDebugMode) print('✅ Service WebSocket connected');

      _channel!.stream.listen(
            (data) {
          if (kDebugMode) print('📩 Service WS Received: $data');
          try {
            final message = jsonDecode(data);
            _messageController.add(message);
          } catch (e) {
            if (kDebugMode) print('❌ Parse error: $e');
          }
        },
        onError: (error) {
          if (kDebugMode) print('❌ Service WS error: $error');
          _handleDisconnection();
        },
        onDone: () {
          if (kDebugMode) print('🔌 Service WS closed');
          _handleDisconnection();
        },
        cancelOnError: false,
      );
    } catch (e) {
      if (kDebugMode) print('❌ Service WS connection failed: $e');
      _isConnected = false;
      _handleDisconnection();
      rethrow;
    }
  }

  void _handleDisconnection() {
    _isConnected = false;

    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      final delay = Duration(seconds: _reconnectAttempts * 2);

      if (kDebugMode) print('⏳ Reconnecting in ${delay.inSeconds}s');

      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(delay, () {
        _messageController.add({'type': 'connection_lost'});
      });
    } else {
      if (kDebugMode) print('❌ Max reconnection attempts reached');
      _messageController.add({'type': 'connection_failed'});
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (!_isConnected || _channel == null) {
      throw Exception('Service WebSocket not connected');
    }

    try {
      final jsonMessage = jsonEncode(message);
      if (kDebugMode) print('📤 Service WS Sending: $jsonMessage');
      _channel!.sink.add(jsonMessage);
    } catch (e) {
      if (kDebugMode) print('❌ Send error: $e');
      rethrow;
    }
  }

  void disconnect() {
    if (kDebugMode) print('🔌 Disconnecting Service WebSocket');
    _reconnectTimer?.cancel();
    _reconnectAttempts = _maxReconnectAttempts;
    _channel?.sink.close();
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}