// class ChatUser {
//   final String id;
//   final String name;
//   final String? imageUrl;
//
//   ChatUser({
//     required this.id,
//     required this.name,
//     this.imageUrl,
//   });
//
//   factory ChatUser.fromMap(Map<String, dynamic> json) {
//     final attributes = json['attributes'] ?? {};
//     return ChatUser(
//       id: json['id'],
//       name: attributes['name'] ?? 'No Name',
//       imageUrl: attributes['square100_profile_photo_url'],
//     );
//   }
// }
class ChatUser {
  final String id;
  final int userId;
  final String name;
  final bool isOnline;
  final String? profileImage;
  final String? email;
  final String? username;
  final String? phone;
  final String? gender;
  final String? country;
  final String? dob;
  final int? age;
  final DateTime? messageReceive;

  ChatUser(
      {required this.id,
      required this.userId,
      required this.name,
      required this.isOnline,
      this.profileImage,
      this.email,
      this.username,
      this.phone,
      this.gender,
      this.country,
      this.dob,
      this.age,
      this.messageReceive});

  factory ChatUser.fromMap(Map<String, dynamic> json) {
    final attributes =
        json.containsKey('attributes') ? json['attributes'] : json;

    return ChatUser(
      id: json['id'] ?? '',
      userId: attributes['auth_user_id'] ?? 0,
      name: attributes['name'] ?? 'Unknown',
      isOnline: attributes['is_online'] ?? false,
      profileImage: attributes['square100_profile_photo_url'],
      email: attributes['email'],
      username: attributes['username'],
      phone: attributes['phone'],
      gender: attributes['gender'],
      country: attributes['country_name'],
      dob: attributes['date_of_birth'],
      age: attributes['age'],
      messageReceive: DateTime.tryParse(
              attributes['message_received_from_partner_at'] ?? '') ??
          DateTime.now(),
    );
  }
}
