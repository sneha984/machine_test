import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:machine_test_flutter/core/commons/constants/image_constants.dart';
import 'package:machine_test_flutter/features/chat/controller/chat_controller.dart';
import 'package:machine_test_flutter/models/chat_message_model.dart';

import '../../../core/commons/global_variables/global_variables.dart';
import '../../../models/chat_item.dart';

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
  final storage = const FlutterSecureStorage();
  DateTime? previousDate;

  final TextEditingController messageController = TextEditingController();
  String? currentUserId;

  Future<void> loadUserId() async {
    final id = await storage.read(key: 'user_id');
    setState(() {
      currentUserId = id;
    });
  }

  List<ChatItem> processMessages(List<ChatMessage> messages) {
    List<ChatItem> chatItems = [];
    DateTime? lastDate;

    for (var msg in messages) {
      final currentDate =
          DateTime(msg.sentAt.year, msg.sentAt.month, msg.sentAt.day);

      if (lastDate == null || currentDate != lastDate) {
        lastDate = currentDate;

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));

        String label;
        if (currentDate == today) {
          label = "Today";
        } else if (currentDate == yesterday) {
          label = "Yesterday";
        } else {
          label = DateFormat('MMM d, yyyy').format(currentDate);
        }

        chatItems.add(ChatItem.date(label));
      }

      chatItems.add(ChatItem.message(msg));
    }

    return chatItems;
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
        surfaceTintColor: Color(0xffF5F5F5),
        toolbarHeight: height * 0.08,
        backgroundColor: Color(0xffF5F5F5),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.all(width * 0.02),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: width * 0.07,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.profileUrl)),
            SizedBox(width: width * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: width * 0.05)),
                Row(
                  children: [
                    Text(widget.isOnline == true ? "Online" : "Offline",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey)),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    widget.isOnline
                        ? const Icon(Icons.circle,
                            color: Colors.green, size: 12)
                        : const Icon(Icons.circle,
                            color: Colors.grey, size: 12),
                  ],
                ),
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
                Map<String, dynamic> map = {
                  'rid': int.tryParse(widget.userId.toString()) ?? "",
                  'sid': currentUserId
                };
                var data = ref.watch(getMessageProvider(jsonEncode(map)));
                return data.when(
                  data: (data) {
                    final processedItems = processMessages(data);

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: processedItems.length,
                      itemBuilder: (context, index) {
                        final item = processedItems[index];

                        if (item.isDateLabel) {
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.dateLabel!,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          );
                        }

                        final msg = item.message!;
                        final isMe = msg.senderId ==
                            int.tryParse(currentUserId.toString());

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                    vertical: height * 0.014),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Colors.pinkAccent
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: isMe
                                        ? Radius.circular(17)
                                        : Radius.circular(0),
                                    bottomRight: isMe
                                        ? Radius.circular(0)
                                        : Radius.circular(17),
                                    topLeft: Radius.circular(17),
                                    topRight: Radius.circular(17),
                                  ),
                                ),
                                child: Text(
                                  msg.message,
                                  style: GoogleFonts.poppins(
                                      color:
                                          isMe ? Colors.white : Colors.black),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    DateFormat('h:mm a').format(msg.sentAt),
                                    style: GoogleFonts.poppins(
                                      fontSize: width * 0.026,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  if (isMe)
                                    Icon(
                                      Icons.done_all,
                                      size: width * 0.04,
                                      color: Colors.blue,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
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
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        suffixIcon: Image.asset(Constants.sendIcon),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Type something...",
                        hintStyle: GoogleFonts.poppins(fontSize: width * 0.04),
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
