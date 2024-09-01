import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:view_sonic_quiz_202409/providers/message_provider.dart';

class MessageList extends HookConsumerWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messagesProvider);

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        if (message['type'] == 'message') {
          return ExpansionTile(
            title: Text(message['name']),
            subtitle: Text(message['content'],
                maxLines: 1, overflow: TextOverflow.ellipsis),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(message['content']),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
