// chat_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String? imageUrl; // Optional field for image URL

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.imageUrl,
  });

  // Convert Message to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'imageUrl': imageUrl, // Add imageUrl to the map if it's not null
    };
  }

  // Create Message from a map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      message: map['message'],
      timestamp: map['timestamp'],
      imageUrl: map['imageUrl'], // Handle the imageUrl field
    );
  }
}
