import 'package:frontend/core/models/message.dart';

class Chat {
  String? leagueId;
  List<String>? participantsIds;
  //List<Message>? messages;

  Chat({
    required this.leagueId,
    required this.participantsIds,
    //required this.messages,
  });

  Map<String, dynamic> toMap() {
    return {
      'leagueId': leagueId,
      'participantsIds': participantsIds,
     // 'messages': messages?.map((m) => m.toMap()).toList() ?? [],
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      leagueId: map['leagueId'],
      participantsIds: map['participantsIds'],
      /*messages:
          List.from(map['messages']).map((m) => Message.fromMap(m)).toList(),*/
    );
  }
}
