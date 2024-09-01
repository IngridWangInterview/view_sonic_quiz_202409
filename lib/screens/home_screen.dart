import 'package:flutter/material.dart';

import '../widgets/message_list.dart';
import '../widgets/user_status.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Hub'),
      ),
      body: const Stack(
        children: [
          MessageList(),
          UserStatus(),
        ],
      ),
    );
  }
}
