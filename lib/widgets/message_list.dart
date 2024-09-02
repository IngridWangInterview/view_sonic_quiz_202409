import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:view_sonic_quiz_202409/providers/message_provider.dart';

class MessageList extends HookConsumerWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messagesProvider);

    return ListView.builder(
      itemCount: messages.entries
              .fold(0, (sum, entry) => sum + entry.value.messages.length) +
          messages.length,
      itemBuilder: (context, index) {
        int currentIndex = 0;
        for (final entry in messages.entries) {
          final header = entry.key;
          final userMessages = entry.value.messages;
          if (index == currentIndex) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "$header ${entry.value.isOnline ? 'online' : 'offline'}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          }
          currentIndex += 1;

          for (final message in userMessages) {
            if (index == currentIndex) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message),
              );
            }
            currentIndex += 1;
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
