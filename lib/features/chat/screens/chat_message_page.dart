import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:machine_test_flutter/features/chat/controller/chat_controller.dart';

import '../../../core/commons/global_variables/global_variables.dart';
import '../../../models/chat_message_model.dart';

class ChatMessagePage extends StatefulWidget {
  final String profileUrl;
  final String name;
  final String userId;
  final bool isOnline;
  const ChatMessagePage(
      {super.key,
      required this.name,
      required this.profileUrl,
      required this.isOnline,
      required this.userId});

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  List<ChatMessage> messages = [];
  bool isLoading = true;
  final Dio dio = Dio();
  final storage = const FlutterSecureStorage();
  final TextEditingController messageController = TextEditingController();
  String? currentUserId;

  Future<void> loadUserId() async {
    final id = await storage.read(key: 'user_id');
    setState(() {
      print("id");
      print(id.runtimeType);
      print(id);
      currentUserId = id;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserId(); // load the id
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xffF5F5F5),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.profileUrl)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                Text(widget.isOnline == true ? "Online" : "Offline",
                    style: TextStyle(
                        fontSize: 12,
                        color: widget.isOnline == true
                            ? Colors.green
                            : Colors.red)),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Consumer(builder: (context, ref, child) {
                print(widget.userId);
                print(currentUserId);
                print(ref.watch(userIdProvider));
                print("ref.watch(userIdProvider)");
                Map<String, dynamic> map = {
                  'rid': int.tryParse(widget.userId.toString()) ?? "",
                  'sid': currentUserId
                };
                var data = ref.watch(getMessageProvider(jsonEncode(map)));
                return data.when(
                  data: (data) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final msg = data[index];

                        print(msg.senderId.runtimeType);
                        final isMe = msg.senderId ==
                            int.tryParse(
                                currentUserId.toString()); // Your userId

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.pinkAccent
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.message,
                                  style: TextStyle(
                                      color:
                                          isMe ? Colors.white : Colors.black),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('h:mm a').format(msg.sentAt),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color:
                                        isMe ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    print(error.toString());
                    print(stackTrace);
                    return Text(error.toString());
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                );
              }),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.045, vertical: height * 0.01),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.withOpacity(0.1),
                        filled: true,
                        suffixIcon: Image.asset("assets/icons/send.png"),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Type something...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
