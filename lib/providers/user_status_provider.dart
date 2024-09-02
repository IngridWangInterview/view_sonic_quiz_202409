import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:view_sonic_quiz_202409/providers/message_provider.dart';

final userStatusProvider = Provider<(int, int)>((ref) {
  final messages = ref.watch(messagesProvider);
  final online = messages.values.where((user) => user.isOnline).length;
  final all = messages.values.toList().length;
  return (online, all);
});
