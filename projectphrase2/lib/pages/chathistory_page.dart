import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => ChatHistoryState();
}

class ChatHistoryState extends State<ChatHistory> {
  Map<String, Map<String, dynamic>> userDataMap = {};

  Future<void> fetchUserData(String userId) async {
    if (userDataMap.containsKey(userId)) return;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        setState(() {
          userDataMap[userId] = data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Chat History", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref("chatHistory/${FirebaseAuth.instance.currentUser!.uid}")
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.snapshot.value as Map?;
          if (data == null) {
            return Center(child: Text("No chat history"));
          }

          final entries = data.entries.toList();

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final chatPartnerId = entries[index].key;
              final lastMessage = entries[index].value['lastMessage'] ?? '';
              final timestamp = entries[index].value['timestamp'] ?? 0;

              fetchUserData(chatPartnerId);
              final userData = userDataMap[chatPartnerId];

              final username = userData?['name'] ?? 'Unknown User';
              final profileImageUrl = userData?['imageUrl'];

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImageUrl == null
                        ? Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  title: Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(receiverId: chatPartnerId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
