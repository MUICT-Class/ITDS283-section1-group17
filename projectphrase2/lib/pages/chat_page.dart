import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;

  const ChatPage({super.key, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final String senderId;
  late DatabaseReference messageRef;
  Map<String, dynamic>? receiverData;
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    senderId = FirebaseAuth.instance.currentUser!.uid;
    messageRef = FirebaseDatabase.instance
        .ref("messages/$senderId/${widget.receiverId}");

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.receiverId)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          receiverData = doc.data();
        });
      }
    });
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      final message = {
        'text': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'sender': senderId,
        'receiver': widget.receiverId,
      };

      // Save message in sender's path
      messageRef.push().set(message);

      // Save message in receiver's path
      FirebaseDatabase.instance
          .ref("messages/${widget.receiverId}/$senderId")
          .push()
          .set(message);

      final chatSummary = {
        'lastMessage': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      FirebaseDatabase.instance
          .ref("chatHistory/$senderId/${widget.receiverId}")
          .set(chatSummary);

      FirebaseDatabase.instance
          .ref("chatHistory/${widget.receiverId}/$senderId")
          .set(chatSummary);

      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              backgroundImage: receiverData?['imageUrl'] != null
                  ? NetworkImage(receiverData!['imageUrl'])
                  : null,
              child: receiverData?['imageUrl'] == null
                  ? Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receiverData?['name'] ?? "Chat",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .ref("messages/${widget.receiverId}/$senderId")
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final data = Map<String, dynamic>.from(
                      snapshot.data!.snapshot.value as Map);
                  final messages = data.entries.map((entry) {
                    final value = Map<String, dynamic>.from(entry.value);
                    return {
                      'text': value['text'] ?? '',
                      'timestamp': value['timestamp'] ?? 0,
                      'sender': value['sender'] ?? '',
                    };
                  }).toList();

                  messages
                      .sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

                  return ListView.builder(
                    padding: EdgeInsets.all(25),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message['sender'] == senderId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.all(16),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.grey[300]
                                : Color.fromARGB(255, 146, 207, 182),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(message['text']),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No messages"));
                }
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF389B72),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Send a Message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
