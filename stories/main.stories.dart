import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'main.stories.directories.g.dart';

void main() {
  // final mockWebSocketService = MockWebSocketService();
  // runApp(
  //   UncontrolledProviderScope(
  //     container: ProviderContainer(overrides: [
  //       webSocketServiceProvider.overrideWith((ref) => mockWebSocketService),
  //       messagesProvider
  //           .overrideWith((ref) => MockMessagesNotifier(mockWebSocketService)),
  //     ]),
  //     child: const WidgetbookApp(),
  //   ),
  // );
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      appBuilder: (context, child) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
        ),
        home: child, // should contains by the ProviderScope
        debugShowCheckedModeBanner: false,
      ),
      directories: directories,
      addons: [
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhoneSE,
            Devices.ios.iPhone12Mini,
            Devices.ios.iPhone13ProMax,
            Devices.ios.iPhone13,
            Devices.android.bigPhone,
            Devices.android.smallPhone,
          ],
          initialDevice: Devices.ios.iPhoneSE,
        ),
      ],
    );
  }
}
