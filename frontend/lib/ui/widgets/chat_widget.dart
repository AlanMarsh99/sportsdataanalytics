import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/league.dart';
import 'package:frontend/core/models/message.dart';
import 'package:frontend/core/services/chat_service.dart';
import 'package:frontend/ui/theme.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    Key? key,
    required this.currentUser,
    required this.messages,
    required this.league,
    required this.chatService,
  }) : super(key: key);

  final ChatUser currentUser;
  final List<ChatMessage> messages;
  final League league;
  final ChatService chatService;

  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashChat(
      currentUser: widget.currentUser,
      messageOptions: MessageOptions(
        currentUserContainerColor: primary,
        showOtherUsersAvatar: true,
        showTime: true,
        avatarBuilder:
            (ChatUser user, Function? onPress, Function? onLongPress) {
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Center(
                child: Image.asset(
                  user.profileImage ?? 'assets/avatars/default.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      inputOptions: const InputOptions(
        sendOnEnter: true,
        alwaysShowSend: true,
        inputTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      onSend: (message) {
        final newMessage = Message(
          senderId: widget.currentUser.id,
          content: message.text,
          sentAt: Timestamp.now(),
        );
        widget.chatService.sendMessage(widget.league.id, newMessage);
      },
      messages: widget.messages,
    );
  }
}
