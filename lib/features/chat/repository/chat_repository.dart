// import 'dart:convert';
//
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:japx/japx.dart';
//
// class ChatRepository {
//   final storage = const FlutterSecureStorage();
//
//   Future<List<Map<String, dynamic>>> fetchContactUsers() async {
//     final token = await storage.read(key: 'accessToken');
//
//     final url = Uri.parse(
//         'https://test.myfliqapp.com/api/v1/chat/chat-messages/queries/contact-users');
//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/vnd.api+json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final decoded = Japx.decode(jsonDecode(response.body));
//       final users = List<Map<String, dynamic>>.from(decoded['data']);
//       return users;
//     } else {
//       throw Exception('Failed to load users');
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:japx/japx.dart';

import '../../../models/chat_message_model.dart';
import '../../../models/chat_model.dart';

class ChatRepository {
  final storage = const FlutterSecureStorage();

  Future<List<ChatUser>> fetchContactUsers({String search = ''}) async {
    final token = await storage.read(key: 'accessToken');
    final url = Uri.parse(
        'https://test.myfliqapp.com/api/v1/chat/chat-messages/queries/contact-users');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.api+json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = Japx.decode(jsonDecode(response.body));
      final data = decoded['data'] as List<dynamic>;

      List<ChatUser> users = data.map((e) => ChatUser.fromMap(e)).toList();

      if (search.isNotEmpty) {
        final lowerQuery = search.toLowerCase();
        users = users
            .where((user) => user.name.toLowerCase().contains(lowerQuery))
            .toList();
      }

      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<ChatMessage>> fetchChatMessages({
    required int receiverId,
    required int senderId,
  }) async {
    final token = await storage.read(key: 'accessToken');

    final url = Uri.parse(
      'https://test.myfliqapp.com/api/v1/chat/chat-messages/queries/chat-between-users/$receiverId/$senderId',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.api+json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = Japx.decode(jsonDecode(response.body));
      final data = decoded['data'] as List<dynamic>;

      final messages = data.map((e) => ChatMessage.fromMap(e)).toList();

      messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));

      return messages;
    } else {
      throw Exception('Failed to load chat messages');
    }
  }
}
