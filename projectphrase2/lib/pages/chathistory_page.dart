import 'package:flutter/material.dart';
import 'package:projectphrase2/pages/chat_page.dart';
import 'package:projectphrase2/services/chat/chat_service.dart';
import '../services/auth_service.dart';

class ChathistoryPage extends StatelessWidget {
  ChathistoryPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat History"),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUsersStream(), // Fetch chat history stream
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error loading chat history.",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data?.isEmpty ?? true) {
          return const Center(
            child: Text(
              'No chat history available.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    final String username = userData['username'] ?? 'Unknown User';
    final String lastMessage = userData['lastMessage'] ?? 'No messages yet';
    final String userId = userData['userId'] ?? '';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Text(
          username.isNotEmpty ? username[0].toUpperCase() : '?',
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(username),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              receiverID: userId, // Pass the userId to the Chat page
            ),
          ),
        );
      },
    );
  }
}