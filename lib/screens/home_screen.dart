import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/message_list.dart';
import '../widgets/user_status.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: getIpAddress(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Server IP: ${snapshot.data}');
            } else {
              return const Text('Server IP:');
            }
          },
        ),
      ),
      body: const Stack(
        children: [
          UserStatus(),
          MessageList(),
        ],
      ),
    );
  }

  Future<String> getIpAddress() async {
    for (final interface in await NetworkInterface.list()) {
      for (final address in interface.addresses) {
        if (address.type == InternetAddressType.IPv4) {
          return address.address;
        }
      }
    }
    return 'Unknown';
  }
}
