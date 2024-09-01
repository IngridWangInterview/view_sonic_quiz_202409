import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:view_sonic_quiz_202409/providers/message_provider.dart';

class UserStatus extends HookConsumerWidget {
  const UserStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (onlineUsers, totalConnections) = ref.watch(userStatusProvider);

    return Positioned(
      right: 16,
      bottom: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '$onlineUsers/$totalConnections',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
