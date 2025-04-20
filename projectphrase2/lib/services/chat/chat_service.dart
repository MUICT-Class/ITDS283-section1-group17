import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send a message
  Future<void> sendMessage(String receiverID, String message,
      {String? imageUrl}) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception("User is not logged in.");
    }

    final String currentUserId = currentUser.uid;
    final Timestamp timestamp = Timestamp.now();

    // Construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Add the new message to Firestore
    try {
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .add({
        "senderId": currentUserId,
        "receiverId": receiverID,
        "message": message,
        "timestamp": timestamp,
        "imageUrl": imageUrl,
      });

      // Update the last message and timestamp in the chat room document
      await _firestore.collection("chat_rooms").doc(chatRoomID).set({
        "lastMessage": message,
        "lastMessageTimestamp": timestamp,
        "participants": ids,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error sending message: $e");
      throw Exception("Failed to send message.");
    }
  }

  // Get messages for a specific chat room
  Stream<QuerySnapshot> getMessages(String userID, String otherUserId) {
    List<String> ids = [userID, otherUserId];
    ids.sort(); // Sort the IDs to ensure a consistent chat room ID
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp",
            descending: false) // Ensure messages are ordered by timestamp
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    final currentUserID = _auth.currentUser?.uid;

    if (currentUserID == null) {
      // Return an empty stream if the user is not logged in
      return Stream.value([]);
    }

    // Fetch chat history where the current user is a participant
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final otherUserId = (data['participants'] as List)
            .firstWhere((id) => id != currentUserID);

        return {
          'username': data['username'] ?? 'Unknown User',
          'lastMessage': data['lastMessage'] ?? 'No messages yet',
          'userId': otherUserId,
        };
      }).toList();
    });
  }
}
