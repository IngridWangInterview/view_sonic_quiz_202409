import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:view_sonic_quiz_202409/config/environment.dart';
import 'package:view_sonic_quiz_202409/services/websocket_service.dart';

final webSocketServerProvider = Provider((ref) {
  final server =
      WebSocketServer(Environment.websocketIp, Environment.websocketPort);
  server.start();
  ref.onDispose(() => server.dispose());
  return server;
});
typedef UserStatusCallback = void Function(
    int onlineUsers, int totalConnections);

class MessagesNotifier extends StateNotifier<Map<String, User>> {
  MessagesNotifier(WebSocketServer server) : super({}) {
    server.messages.listen((message) {
      state = message;
    });
  }
}

final messagesProvider =
    StateNotifierProvider<MessagesNotifier, Map<String, User>>((ref) {
  final server = ref.watch(webSocketServerProvider);
  return MessagesNotifier(server);
});
