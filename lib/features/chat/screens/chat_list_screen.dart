import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:machine_test_flutter/core/commons/global_variables/global_variables.dart';
import 'package:machine_test_flutter/features/chat/controller/chat_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/chat_model.dart';
import '../repository/chat_repository.dart';
import 'chat_message_page.dart';

class ChatUsersList extends StatefulWidget {
  @override
  State<ChatUsersList> createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  final ChatRepository repository = ChatRepository();
  final TextEditingController searchController = TextEditingController();

  List<ChatUser> allUsers = [];
  List<ChatUser> filteredUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    searchController.addListener(filterUsers);
  }

  Future<void> fetchUsers() async {
    try {
      final users = await repository.fetchContactUsers();
      setState(() {
        allUsers = users;
        filteredUsers = users;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error...: $e');
    }
  }

  void filterUsers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = allUsers
          .where((user) => user.name.toLowerCase().contains(query))
          .toList();
    });
  }

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
                    var data = ref.watch(getChatProvider);
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
                                                  userId: user.id ?? '',
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
                                        user.name ?? 'No name',
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
                          print(stackTrace);
                          print(error);
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
                  filterUsers();
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
                      "assets/icons/search-favorite.svg",
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
                  isLoading
                      ? SizedBox(
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
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return GestureDetector(
                              onTap: () {
                                print(user.userId);
                                print(user.name);
                                print("userId");
                                print(user.userId);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatMessagePage(
                                              isOnline: user.isOnline,
                                              userId: user.id ?? "",
                                              profileUrl:
                                                  user.profileImage ?? "",
                                              name: user.name,
                                            )));
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
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
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ChatUsersScreen extends ConsumerStatefulWidget {
//   const ChatUsersScreen({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<ChatUsersScreen> createState() => _ChatUsersScreenState();
// }
//
// class _ChatUsersScreenState extends ConsumerState<ChatUsersScreen> {
//   List<ChatUser> chatUsers = [];
//   bool isLoading = true;
//
//   final Dio dio = Dio();
//   final storage = const FlutterSecureStorage();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchChats();
//   }
//
//   Future<void> fetchChats() async {
//     try {
//       final token = await storage.read(key: 'access_token');
//       final response = await dio.get(
//         'https://test.myfliqapp.com/api/v1/chat/chat-messages/queries/contact-users',
//         options: Options(headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/vnd.api+json',
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final decoded = Japx.decode(
//           response.data is String
//               ? jsonDecode(response.data)
//               : response.data as Map<String, dynamic>,
//         );
//
//         final List<dynamic> data = decoded['data'];
//
//         setState(() {
//           chatUsers = data.map((e) => ChatUser.fromMap(e)).toList();
//           isLoading = false;
//         });
//       } else {
//         debugPrint("Unexpected response: ${response.statusCode}");
//         setState(() => isLoading = false);
//       }
//     } catch (e) {
//       debugPrint("Error fetching chats: $e");
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final usersAsync = ref.watch(chatUsersProvider);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat Users')),
//       body: usersAsync.when(
//         data: (users) {
//           return ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: users.length,
//             itemBuilder: (context, index) {
//               final user = users[index];
//               return Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CircleAvatar(
//                       radius: 30,
//                       backgroundImage: (user.profileImage != null &&
//                               user.profileImage!.isNotEmpty)
//                           ? NetworkImage(user.profileImage!)
//                           : const AssetImage('assets/images/default_user.png')
//                               as ImageProvider,
//                     ),
//                   ),
//                   Text(user.name),
//                 ],
//               );
//             },
//           );
//         },
//         loading: () => const Center(
//             child: CircularProgressIndicator(
//           color: Colors.red,
//         )),
//         error: (err, _) => Center(child: Text('Error: $err')),
//       ),
//     );
//   }
// }
