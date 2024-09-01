import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class User {
  final String name;
  bool isOnline;

  User(this.name, {this.isOnline = true});
}

class WebSocketServer {
  final int port;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _users = <String, User>{};
  int _totalConnections = 0;

  WebSocketServer(this.port);

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  int get onlineUsers => _users.values.where((user) => user.isOnline).length;
  int get totalConnections => _totalConnections;

  Future<void> start() async {
    final handler = webSocketHandler((WebSocketChannel webSocket) {
      webSocket.stream.listen((message) {
        final data = jsonDecode(message);
        switch (data['type']) {
          case 'connect':
            _handleConnect(data['name']);
            break;
          case 'message':
            _handleMessage(data['name'], data['content']);
            break;
          case 'disconnect':
            _handleDisconnect(data['name']);
            break;
        }
      }, onDone: () {
        // Handle unexpected disconnection
        _users.entries
            .firstWhere((entry) => entry.value.isOnline)
            .value
            .isOnline = false;
        _notifyUserStatusChange();
      });
    });

    final server = await shelf_io.serve(handler, 'localhost', port);
    print('Serving at ws://${server.address.host}:${server.port}');
  }

  void _handleConnect(String name) {
    if (_users.containsKey(name)) {
      _users[name]!.isOnline = true;
    } else {
      _users[name] = User(name);
      _totalConnections++;
    }
    _notifyUserStatusChange();
  }

  void _handleMessage(String name, String content) {
    _messageController.add({
      'type': 'message',
      'name': name,
      'content': content,
    });
  }

  void _handleDisconnect(String name) {
    if (_users.containsKey(name)) {
      _users[name]!.isOnline = false;
      _notifyUserStatusChange();
    }
  }

  void _notifyUserStatusChange() {
    _messageController.add({
      'type': 'status',
      'onlineUsers': onlineUsers,
      'totalConnections': totalConnections,
    });
  }

  void dispose() {
    _messageController.close();
  }
}
