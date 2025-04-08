// class ChatMessage {
//   final int id;
//   final int senderId;
//   final int receiverId;
//   final String message;
//   final DateTime sentAt;
//
//   ChatMessage({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.message,
//     required this.sentAt,
//   });
//
//   factory ChatMessage.fromMap(Map<String, dynamic> map) {
//     final attributes = map['attributes'];
//     return ChatMessage(
//       id: int.parse(map['id']),
//       senderId: attributes['sender_id'],
//       receiverId: attributes['receiver_id'],
//       message: attributes['message'] ?? '',
//       sentAt: DateTime.parse(attributes['sent_at']),
//     );
//   }
// }

class ChatMessage {
  final String id;
  final String message;
  final int senderId;
  final int receiverId;
  final DateTime sentAt;
  final String? mediaUrl;

  ChatMessage({
    required this.id,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    this.mediaUrl,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> json) {
    final attributes =
        json.containsKey('attributes') ? json['attributes'] : json;
    return ChatMessage(
      id: json['id'] ?? '',
      message: attributes['message'] ?? '',
      senderId: attributes['sender_id'] ?? 0,
      receiverId: attributes['receiver_id'] ?? 0,
      sentAt: DateTime.tryParse(attributes['sent_at'] ?? '') ?? DateTime.now(),
      mediaUrl: attributes['media_url'],
    );
  }
}
