import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/chat_message_model.dart';
import '../../../models/chat_model.dart';
import '../repository/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

final getMessageProvider =
    FutureProvider.autoDispose.family<List<ChatMessage>, String>((ref, items) {
  return ref
      .watch(chatControllerProvider.notifier)
      .getChatMessages(items: items);
});
final getChatProvider =
    FutureProvider.autoDispose.family<List<ChatUser>, String>((ref, search) {
  return ref
      .watch(chatControllerProvider.notifier)
      .getChatUsers(search: search);
});
final chatControllerProvider =
    NotifierProvider<ChatController, bool>(() => ChatController());

class ChatController extends Notifier<bool> {
  ChatRepository get _chatRepository => ref.read(chatRepositoryProvider);

  @override
  bool build() {
    return false;
  }

  Future<List<ChatMessage>> getChatMessages({required String items}) {
    Map<String, dynamic> data = jsonDecode(items);

    return _chatRepository.fetchChatMessages(
        receiverId: int.tryParse(data['rid'].toString()) ?? 0,
        senderId: int.tryParse(data['sid'].toString()) ?? 0);
  }

  Future<List<ChatUser>> getChatUsers({required String search}) {
    return _chatRepository.fetchContactUsers(search: search);
  }
}
