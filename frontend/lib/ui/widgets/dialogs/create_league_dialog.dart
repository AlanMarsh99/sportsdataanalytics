import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/models/chat.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/core/services/chat_service.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateLeagueDialog extends StatelessWidget {
  CreateLeagueDialog({Key? key}) : super(key: key);

  final _nameController = TextEditingController();
  ChatService chatService = ChatService();

  void createLeague(BuildContext context) async {
    final userId = Provider.of<AuthService>(context, listen: false).userApp!.id;
    try {
      // Unique code 6 characters
      final id = const Uuid().v1().substring(0, 6).toUpperCase();

      final leagueData = {
        'id': id,
        'name': _nameController.text,
        'userIds': [userId],
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('leagues')
          .doc(id)
          .set(leagueData);

      // Asociar al usuario con la liga
      final userLeagueData = {
        'userId': userId,
        'leagueId': id,
        'joinedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('userLeagues')
          .add(userLeagueData);

      Chat newChat =
          Chat(leagueId: id, participantsIds: [userId]);

      await chatService.createChatForLeague(newChat);

      print('League created successfully with code: $id');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('League created successfully with code: $id'),
          backgroundColor: primary,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      print('Error creating league: $e');
      Navigator.pop(context, false);
    }
  }

  Widget actionButtonRow(BuildContext context, String newName) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(color: primary, width: 2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                  color: primary, fontSize: 14.0, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onPressed: () async {
            if (_nameController.text.isNotEmpty) {
              createLeague(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error: Name cannot be empty'),
                  backgroundColor: secondary,
                ),
              );
            }
          },
          child: Container(
            width: 110,
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(color: secondary, width: 2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: const Text(
              'CREATE',
              style: TextStyle(
                  color: white, fontSize: 14.0, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Create a league",
            style: TextStyle(color: primary, fontWeight: FontWeight.bold),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close_rounded,
                size: 24,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                height: 40.0,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  cursorColor: secondary,
                  controller: _nameController,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 10),
                    hintText: 'League name',
                    hintStyle: TextStyle(color: gray1, fontSize: 14),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(15),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            actionButtonRow(context, _nameController.text),
          ],
        ),
      ),
    );
  }
}
