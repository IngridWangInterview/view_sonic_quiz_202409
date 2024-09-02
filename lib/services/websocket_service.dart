import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef UserStatusCallback = void Function(
    int onlineUsers, int totalConnections);

class User {
  final String name;
  bool isOnline;
  List<String> messages;

  User(this.name, {this.isOnline = true, this.messages = const []});
}

enum VcMsgType {
  connect,
  message,
  disconnect;

  static VcMsgType fromJson(String type) {
    return VcMsgType.values.firstWhere((e) => e.name == type);
  }
}

class VcMsg {
  final VcMsgType type;
  final String name;
  final String content;

  VcMsg({required this.type, required this.name, required this.content});

  factory VcMsg.fromJson(Map<String, dynamic> json) {
    return VcMsg(
        type: VcMsgType.fromJson(json['type']),
        name: json['name'],
        content: json['content']);
  }
}

class WebSocketServer {
  final String ip;
  final int port;
  final _messageController = StreamController<Map<String, User>>.broadcast();
  final _users = <String, User>{};
  int _totalConnections = 0;

  WebSocketServer(this.ip, this.port);

  Stream<Map<String, User>> get messages => _messageController.stream;

  int get onlineUsers => _users.values.where((user) => user.isOnline).length;

  int get totalConnections => _totalConnections;

  Future<void> start() async {
    final handler = webSocketHandler((WebSocketChannel webSocket) {
      webSocket.stream.listen((message) {
        print('------------message-----------, $message');

        final data = jsonDecode(message);
        final msg = VcMsg.fromJson(data);
        switch (msg.type) {
          case VcMsgType.connect:
            _handleConnect(msg.name);
            break;
          case VcMsgType.message:
            _handleMessage(msg);
            break;
          case VcMsgType.disconnect:
            _handleDisconnect(msg);
            break;
        }
      }, onDone: () {
        _users.entries
            .firstWhere((entry) => entry.value.isOnline)
            .value
            .isOnline = false;
      });
    });

    final server = await shelf_io.serve(handler, ip, port);
    print('Serving at ws://${server.address.host}:${server.port}');
  }

  void _handleConnect(String name) {
    if (_users.containsKey(name)) {
      _users[name]!.isOnline = true;
    } else {
      _users[name] = User(name);
      _totalConnections += 1;
    }
    final newUsers = Map.of(_users);
    _messageController.add(newUsers);
  }

  void _handleMessage(VcMsg msg) {
    if (_users.containsKey(msg.name)) {
      _users[msg.name]!.isOnline = true;
    } else {
      _users[msg.name] = User(msg.name);
      _totalConnections += 1;
    }

    if (_users[msg.name]!.messages.isEmpty) {
      _users[msg.name]!.messages = [msg.content];
    } else {
      _users[msg.name]!.messages.add(msg.content);
    }
    final newUsers = Map.of(_users);
    _messageController.add(newUsers);
  }

  void _handleDisconnect(VcMsg msg) {
    if (_users.containsKey(msg.name)) {
      _users[msg.name]!.isOnline = false;
      final newUsers = Map.of(_users);
      _messageController.add(newUsers);
    }
  }

  void dispose() {
    _messageController.close();
  }
}
