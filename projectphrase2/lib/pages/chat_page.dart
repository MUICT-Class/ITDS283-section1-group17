import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectphrase2/services/auth_service.dart';
import 'package:projectphrase2/services/chat/chat_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Chat extends StatefulWidget {
  final String receiverID;

  Chat({super.key, required this.receiverID});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  File? _selectedImage;

  // Fetch the current user's username
  String get currentUserName =>
      _authService.currentUser?.displayName ?? 'No Name';

  Future<String> getRecipientUsername() async {
    if (widget.receiverID.isEmpty) {
      return 'Unknown User';
    }

    try {
      // Fetch the user document from the 'Users' collection
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.receiverID)
          .get();
      if (userDoc.exists) {
        return userDoc.data()?['username'] ?? 'Unknown User';
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      debugPrint("Error fetching user document: $e");
      return 'Unknown User';
    }
  }

  Future<String> _uploadImageToFirebase(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('chat_images/$fileName.jpg');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL(); // Return the image URL
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return '';
    }
  }

  void sendMessage() async {
  if (_messageController.text.isEmpty && _selectedImage == null) {
    debugPrint("Error: Message text and image are both empty.");
    return; // Do nothing if both text and image are empty
  }

  String message = _messageController.text.trim();
  String? imageUrl;

  // If there's an image, upload it and get the image URL
  if (_selectedImage != null) {
    imageUrl = await _uploadImageToFirebase(_selectedImage!);
    if (imageUrl.isEmpty) {
      debugPrint("Error: Failed to upload image.");
      return; // Stop if the image upload fails
    }
    message = "Image"; // Set message to "Image" if an image is sent
  }

  try {
    // Ensure receiverID is not null or empty
    if (widget.receiverID.isEmpty) {
      debugPrint("Error: Receiver ID is empty.");
      return;
    }

    // Send the message using ChatService
    await _chatService.sendMessage(widget.receiverID, message, imageUrl: imageUrl);

    // Clear the message input and reset the selected image
    _messageController.clear();
    setState(() {
      _selectedImage = null;
    });
  } catch (e) {
    debugPrint("Error sending message: $e");
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildChatMessages(context)),
          SafeArea(child: _buildMessageInput()),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: FutureBuilder<String>(
        future: getRecipientUsername(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...", style: TextStyle(color: Colors.black));
          } else if (snapshot.hasError) {
            return Text("Error", style: TextStyle(color: Colors.black));
          } else {
            return Text(snapshot.data ?? "Unknown User",
                style: TextStyle(color: Colors.black));
          }
        },
      ),
    );
  }

  Widget _buildChatMessages(BuildContext context) {
    String senderID = _authService.currentUser?.uid ?? '';
    return StreamBuilder<QuerySnapshot>(
        stream: _chatService.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading messages"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No messages yet"));
          }
          return ListView(
            padding: EdgeInsets.all(25),
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(context, doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(BuildContext context, DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Align(
      alignment: data['senderId'] == _authService.currentUser?.uid
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: data['senderId'] == _authService.currentUser?.uid
              ? Colors.grey[300]
              : Color.fromARGB(255, 146, 207, 182),
          borderRadius: BorderRadius.circular(25),
        ),
        child: data['imageUrl'] != null
            ? Image.network(data['imageUrl'])
            : Text(data["message"] ?? ""),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  _selectedImage = File(pickedFile.path);
                });
              }
            },
            child: Icon(Icons.add_a_photo, color: Color(0xFF389B72)),
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
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Send a Message",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: sendMessage,
            child: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}