import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/league.dart';
import 'package:frontend/core/models/message.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/core/services/chat_service.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.currentUser,
    required this.league,
    required this.chatService,
  }) : super(key: key);

  final ChatUser currentUser;
  final League league;
  final ChatService chatService;

  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  '${widget.league.name} Chat',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: MediaQuery.of(context).size.height - 150,
              width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: StreamBuilder<List<Message>>(
                  stream: widget.chatService.getMessages(widget.league.id),
                  builder: (context, snapshot) {
                    // Check the stream's state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CircularProgressIndicator(
                            color: primary,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }

                    List<Message> listMessages = [];

                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      // Retrieve the list of Message objects
                      listMessages = snapshot.data!;
                      listMessages
                          .sort((a, b) => b.sentAt!.compareTo(a.sentAt!));
                    }

                    // Use a FutureBuilder to handle async message conversion
                    return FutureBuilder<List<ChatMessage>>(
                      future: widget.chatService.generateChatMessagesList(
                          listMessages, widget.currentUser),
                      builder: (context, chatSnapshot) {
                        if (chatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primary,
                            ),
                          );
                        }

                        if (chatSnapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Error: ${chatSnapshot.error}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        }

                        // Retrieve the list of ChatMessage objects
                        List<ChatMessage> messages = chatSnapshot.data ?? [];

                        // Render DashChat with the messages
                        return ChatWidget(
                          messages: messages,
                          league: widget.league,
                          chatService: widget.chatService,
                          currentUser: widget.currentUser,
                        );
                      },
                    );
                  },
                )),
          ]),
        ),
      ),
    );
  }
}
