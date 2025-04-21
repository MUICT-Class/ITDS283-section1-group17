import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<String> _getUserNameById(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.data()?['name'] ?? 'Unknown';
    }
    return 'Unknown';
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/camera_icon.svg',
                  color: Color(0xFF389B72),
                ),
                title: Text('Take Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    _uploadImage(File(pickedFile.path));
                  }
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/photo_icon.svg',
                  color: Color(0xFF389B72),
                ),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    _uploadImage(File(pickedFile.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImage(File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child('$senderId/$fileName.jpg');

    await storageRef.putFile(file);
    final imageUrl = await storageRef.getDownloadURL();

    final senderName = await _getUserNameById(senderId);
    final message = {
      'text': '',
      'imageUrl': imageUrl,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'sender': senderId,
      'senderName': senderName,
      'receiver': widget.receiverId,
    };

    messageRef.push().set(message);
    FirebaseDatabase.instance
        .ref("messages/${widget.receiverId}/$senderId")
        .push()
        .set(message);

    final chatSummary = {
      'lastMessage': '[Image]',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'senderId': senderId,
      'senderName': senderName,
    };

    FirebaseDatabase.instance
        .ref("chatHistory/$senderId/${widget.receiverId}")
        .set(chatSummary);
    FirebaseDatabase.instance
        .ref("chatHistory/${widget.receiverId}/$senderId")
        .set(chatSummary);
  }

  void _sendMessage() async {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      final senderName = await _getUserNameById(senderId);
      final message = {
        'text': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'sender': senderId,
        'senderName': senderName,
        'receiver': widget.receiverId,
      };

      final messageId = messageRef.push().key;
      messageRef.child(messageId!).set(message);

      FirebaseDatabase.instance
          .ref("messages/${widget.receiverId}/$senderId")
          .push()
          .set(message);

      final chatSummary = {
        'lastMessage': text,
        'lastMessageId': messageId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'senderId': senderId,
        'senderName': senderName,
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
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
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
                      'senderName': value['senderName'] ?? '',
                      'imageUrl': value['imageUrl'],
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
                        child: message['imageUrl'] != null
                            ? Container(
                                margin: EdgeInsets.only(bottom: 20),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(message['imageUrl']),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.all(12),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Colors.grey[300]
                                      : Color.fromARGB(255, 146, 207, 182),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  message['text'],
                                  style: TextStyle(fontSize: 16),
                                ),
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
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: _pickAndUploadImage,
                    ),
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
