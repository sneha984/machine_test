import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:machine_test_flutter/core/commons/constants/image_constants.dart';
import 'package:machine_test_flutter/core/commons/global_variables/global_variables.dart';
import 'package:machine_test_flutter/features/chat/controller/chat_controller.dart';
import 'package:shimmer/shimmer.dart';

import 'chat_message_page.dart';

class ChatUsersList extends StatefulWidget {
  const ChatUsersList({
    super.key,
  });
  @override
  State<ChatUsersList> createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          "Messages",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: height * 0.024,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: height * 0.16,
                child: Consumer(
                  builder: (context, ref, child) {
                    var data = ref.watch(getChatProvider(''));
                    return data.when(
                        data: (data) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final user = data[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChatMessagePage(
                                                  isOnline: user.isOnline,
                                                  userId: user.id,
                                                  profileUrl:
                                                      user.profileImage ?? "",
                                                  name: user.name,
                                                )));
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          radius: width * 0.08,
                                          backgroundImage: (user.profileImage !=
                                                      null &&
                                                  user.profileImage!.isNotEmpty)
                                              ? NetworkImage(user.profileImage!)
                                              : const AssetImage(
                                                      'assets/images/default_user.png')
                                                  as ImageProvider,
                                        ),
                                      ),
                                      Text(
                                        user.name.toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: height * 0.016,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        error: (error, stackTrace) {
                          return Text(error.toString());
                        },
                        loading: () => SizedBox(
                            height: height * 0.13,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: width * 0.08,
                                          backgroundColor: Colors.white,
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          width: width * 0.12,
                                          height: height * 0.014,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )));
                  },
                )),
            Padding(
              padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  searchController.text = value;
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: GoogleFonts.poppins(
                      color: Colors.grey, fontSize: width * 0.04),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: SvgPicture.asset(
                      Constants.searchIcon,
                      width: width * 0.01,
                      height: height * 0.01,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown.shade300),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chat",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: height * 0.02,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Consumer(builder: (context, ref, child) {
                    var data = ref
                        .watch(getChatProvider(searchController.text.trim()));
                    return data.when(
                      data: (data) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final user = data[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatMessagePage(
                                              isOnline: user.isOnline,
                                              userId: user.id.toString(),
                                              profileUrl:
                                                  user.profileImage ?? "",
                                              name: user.name,
                                            )));
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 2),
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: user.profileImage !=
                                                  null &&
                                              user.profileImage!.isNotEmpty
                                          ? NetworkImage(user.profileImage!)
                                          : const AssetImage(
                                                  'assets/images/default_user.png')
                                              as ImageProvider,
                                    ),
                                    title: Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF3D1C1C),
                                      ),
                                    ),
                                    trailing: Text(
                                      DateFormat('h:mm a')
                                          .format(user.messageReceive!),
                                      style: GoogleFonts.poppins(
                                        fontSize: width * 0.026,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    // trailing: user.isOnline
                                    //     ? const Icon(Icons.circle,
                                    //         color: Colors.green, size: 12)
                                    //     : const Icon(Icons.circle,
                                    //         color: Colors.grey, size: 12),
                                  ),
                                  const Divider(
                                      thickness: 0.5,
                                      indent: 20,
                                      endIndent: 16),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        return Text(error.toString());
                      },
                      loading: () {
                        return SizedBox(
                          height: height * 0.4,
                          child: ListView.builder(
                            itemCount: 3,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Container(
                                          height: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
