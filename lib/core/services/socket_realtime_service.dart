import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../network/api_base.dart';

/// Events emitted by the backend RealtimeGateway
class RealtimeEvents {
  static const String notificationNew = 'notification:new';
  static const String unreadCount = 'notification:unread_count';
  static const String medicationReminder = 'medication:reminder';
  static const String relationshipUpdate = 'relationship:update';
}

/// Manages the Socket.IO connection with the backend /realtime namespace.
/// - Connects with JWT token for auth
/// - Auto-reconnects on disconnect
/// - Exposes streams for each event type
class SocketRealtimeService {
  io.Socket? _socket;
  String? _currentToken;

  // Stream controllers
  final _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _unreadCountController = StreamController<int>.broadcast();
  final _reminderController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _relationshipController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Public streams
  Stream<Map<String, dynamic>> get onNotification =>
      _notificationController.stream;
  Stream<int> get onUnreadCount => _unreadCountController.stream;
  Stream<Map<String, dynamic>> get onReminder => _reminderController.stream;
  Stream<Map<String, dynamic>> get onRelationshipUpdate =>
      _relationshipController.stream;

  bool get isConnected => _socket?.connected ?? false;

  String _normalizeSocketUrl(String rawUrl) {
    final uri = Uri.parse(rawUrl);
    if (!uri.hasScheme || uri.host.isEmpty) return rawUrl;

    final port = uri.hasPort
        ? uri.port
        : switch (uri.scheme) {
            'https' || 'wss' => 443,
            'http' || 'ws' => 80,
            _ => 0,
          };

    if (port == 0) return rawUrl;

    final scheme = uri.scheme == 'wss'
        ? 'https'
        : uri.scheme == 'ws'
        ? 'http'
        : uri.scheme;

    return uri.replace(scheme: scheme, port: port).toString();
  }

  /// Connect to the WebSocket server with a JWT access token.
  void connect(String accessToken) {
    final socketUrl = _normalizeSocketUrl(ApiSocket.urlNotifications);
    if (socketUrl.isEmpty) {
      debugPrint(
        '[SocketRealtimeService] SOCKET_URL_NOTIFICATIONS not set in .env',
      );
      return;
    }

    // Skip duplicate connect for the same token while still connected/connecting.
    if (_socket != null && _currentToken == accessToken) {
      debugPrint(
        '[SocketRealtimeService] Skip connect: already using this token',
      );
      return;
    }

    debugPrint('[SocketRealtimeService] Connecting to: $socketUrl');

    // Disconnect any existing socket before creating a new one
    disconnect();
    _currentToken = accessToken;

    _socket = io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableForceNew()
          .disableAutoConnect()
          .setQuery({'token': accessToken})
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(3000)
          .setReconnectionDelayMax(30000)
          .setRandomizationFactor(0.5)
          .setTimeout(20000)
          .build(),
    );

    _socket!
      ..onConnect((_) {
        debugPrint('[SocketRealtimeService] ✅ Connected');
      })
      ..onDisconnect((_) {
        debugPrint('[SocketRealtimeService] ❌ Disconnected');
      })
      ..onConnectError((err) {
        debugPrint('[SocketRealtimeService] Connect error: $err');
        // Stop spamming the server when the handshake keeps being rejected
        // (e.g. HTTP 400 because of bad token / wrong namespace).
        final errStr = err?.toString() ?? '';
        if (errStr.contains('status code: 400') ||
            errStr.contains('status code: 401') ||
            errStr.contains('status code: 403')) {
          debugPrint(
            '[SocketRealtimeService] Auth/handshake rejected, stop reconnecting.',
          );
          _socket?.disconnect();
        }
      })
      ..on(RealtimeEvents.notificationNew, (data) {
        debugPrint('[SocketRealtimeService] notification:new received');
        if (data is Map<String, dynamic>) {
          _notificationController.add(data);
        }
      })
      ..on(RealtimeEvents.unreadCount, (data) {
        if (data is Map<String, dynamic>) {
          final count = data['unreadCount'];
          if (count is int) _unreadCountController.add(count);
        }
      })
      ..on(RealtimeEvents.medicationReminder, (data) {
        if (data is Map<String, dynamic>) {
          _reminderController.add(data);
        }
      })
      ..on(RealtimeEvents.relationshipUpdate, (data) {
        debugPrint('[SocketRealtimeService] relationship:update received');
        if (data is Map<String, dynamic>) {
          _relationshipController.add(data);
        }
      });

    _socket!.connect();
  }

  /// Disconnect and clean up the socket.
  void disconnect() {
    _socket?.dispose();
    _socket = null;
    _currentToken = null;
    debugPrint('[SocketRealtimeService] Disconnected & disposed');
  }

  /// Tear down everything — call on app logout.
  void dispose() {
    disconnect();
    _notificationController.close();
    _unreadCountController.close();
    _reminderController.close();
    _relationshipController.close();
  }
}
