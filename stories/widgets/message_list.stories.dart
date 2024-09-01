import 'package:flutter/material.dart';
import 'package:view_sonic_quiz_202409/widgets/message_list.dart';

import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Message List',
  type: MessageList,
)
Widget messageListUseCase(BuildContext context) {
  return const MessageList();
}
