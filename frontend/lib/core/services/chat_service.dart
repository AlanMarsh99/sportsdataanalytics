import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:frontend/core/models/chat.dart';
import 'package:frontend/core/models/message.dart';
import 'package:frontend/core/models/user_app.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createChatForLeague(Chat chat) async {
    try {
      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(chat.leagueId);
      await chatRef.set(chat.toMap());
      print('Chat created successfully');
    } catch (e) {
      print('Error creating chat: $e');
    }
  }

  Future<void> addParticipantToChat(String leagueId, String userId) async {
    try {
      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(leagueId);

      await chatRef.update({
        'participantsIds': FieldValue.arrayUnion([userId]),
      });

      print('Participant added to chat successfully');
    } catch (e) {
      print('Error adding participant to chat: $e');
    }
  }

  Future<Chat?> getChat(String leagueId) async {
    final doc = await _firestore.collection('chats').doc(leagueId).get();
    if (doc.exists) {
      return Chat.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> sendMessage(String leagueId, Message message) async {
    try {
      final messagesRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(leagueId)
          .collection('messages');
      await messagesRef.add(message.toMap());
      print('Message sent successfully');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Stream<List<Message>> getMessages(String leagueId) {
    final messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(leagueId)
        .collection('messages')
        .orderBy('sentAt', descending: false);

    return messagesRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<UserApp> getChatUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return UserApp.fromMap(doc.data()!);
  }

  Future<List<ChatMessage>> generateChatMessagesList(
      List<Message> messages, ChatUser currentUser) async {
    // Use Future.wait to handle asynchronous operations inside a loop
    return await Future.wait(messages.map((m) async {
      ChatUser user = currentUser;

      // Fetch user details only if the sender is not the current user
      if (m.senderId != currentUser.id) {
        UserApp senderUser = await getChatUser(m.senderId!);

        user = ChatUser(
          id: m.senderId!,
          firstName: senderUser.username,
          profileImage: 'assets/avatars/${senderUser.avatar}.png',
        );
      }

      // Create and return the ChatMessage instance
      return ChatMessage(
        text: m.content ?? "",
        user: user,
        createdAt: m.sentAt!.toDate(),
      );
    }).toList());
  }
}
