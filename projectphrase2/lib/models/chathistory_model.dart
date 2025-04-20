import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHistory {
  final String userName;
  final String userId;
  final String lastMessage;
  final String avatarUrl;
  final bool isOnline;

  ChatHistory({
    required this.userName,
    required this.userId,
    required this.lastMessage,
    this.avatarUrl = '',
    this.isOnline = false,
  });

  // Create a ChatHistory object from Firestore document
  factory ChatHistory.fromFirestore(DocumentSnapshot doc) {
    return ChatHistory(
      userName: doc['userName'],
      userId: doc['userId'],
      lastMessage: doc['lastMessage'],
      avatarUrl: doc['avatarUrl'] ?? '',
      isOnline: doc['isOnline'] ?? false,
    );
  }
}
