import 'package:machine_test_flutter/models/chat_message_model.dart';

class ChatItem {
  final bool isDateLabel;
  final String? dateLabel;
  final ChatMessage? message;

  ChatItem.date(this.dateLabel)
      : isDateLabel = true,
        message = null;

  ChatItem.message(this.message)
      : isDateLabel = false,
        dateLabel = null;
}
