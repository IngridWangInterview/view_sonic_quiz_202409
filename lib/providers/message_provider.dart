import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:view_sonic_quiz_202409/services/websocket_service.dart';

final webSocketServerProvider = Provider((ref) {
  final server = WebSocketServer(8080);
  server.start();
  ref.onDispose(() => server.dispose());
  return server;
});

class MessagesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  MessagesNotifier(WebSocketServer server) : super([]) {
    server.messages.listen((message) {
      state = [...state, message];
    });
  }
}

final messagesProvider =
    StateNotifierProvider<MessagesNotifier, List<Map<String, dynamic>>>((ref) {
  final server = ref.watch(webSocketServerProvider);
  return MessagesNotifier(server);
});

final userStatusProvider = Provider<(int, int)>((ref) {
  final messages = ref.watch(messagesProvider);
  final lastStatus = messages.lastWhere((m) => m['type'] == 'status',
      orElse: () => {'onlineUsers': 0, 'totalConnections': 0});
  return (lastStatus['onlineUsers'] ?? 0, lastStatus['totalConnections'] ?? 0);
});
