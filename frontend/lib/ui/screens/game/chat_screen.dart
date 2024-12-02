import 'package:flutter/material.dart';
import 'package:frontend/core/models/message.dart';
import 'package:frontend/core/models/user_app.dart';

class ChatScreen extends StatelessWidget {
  final UserApp chatUser;
  final String leagueId;
  final Stream<List<Message>> messagesStream;
  final Function(String) onSendMessage;

  const ChatScreen({
    Key? key,
    required this.chatUser,
    required this.leagueId,
    required this.messagesStream,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Message>>(
            stream: messagesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No messages yet.'));
              }

              final messages = snapshot.data!;
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ListTile(
                    title: Text(message.content ?? ''),
                    subtitle: Text(message.senderId ?? ''),
                    trailing: Text(
                      message.sentAt != null
                          ? message.sentAt!.toDate().toString()
                          : '',
                      style: TextStyle(fontSize: 10),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    onSendMessage(_messageController.text);
                    _messageController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
