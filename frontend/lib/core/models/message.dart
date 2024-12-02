import 'package:cloud_firestore/cloud_firestore.dart';

//enum MessageType { Text, Image }

class Message {
  String? senderId;
  String? content;
  //MessageType? messageType;
  Timestamp? sentAt;

  Message({
    required this.senderId,
    required this.content,
    //required this.messageType,
    required this.sentAt,
  });

    Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'sentAt': sentAt,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      content: map['content'],
      sentAt: map['sentAt'],
    );
  }
}