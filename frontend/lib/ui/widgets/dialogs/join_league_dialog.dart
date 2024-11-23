import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class JoinLeagueDialog extends StatelessWidget {
  JoinLeagueDialog({Key? key}) : super(key: key);

  final _codeController = TextEditingController();

  void joinLeague(BuildContext context) async {
    final userId = Provider.of<AuthService>(context, listen: false).userApp!.id;
    try {
      final leaguesCollection =
          FirebaseFirestore.instance.collection('leagues');
      // Search for league with code
      final querySnapshot = await leaguesCollection
          .where('id', isEqualTo: _codeController.text)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('League not found'); // League with code not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: League not found'),
            backgroundColor: secondary,
          ),
        );
        return;
      }

      final leagueDoc = querySnapshot.docs.first;
      final leagueId = leagueDoc['id'];
      final leagueName = leagueDoc['name'];

      // Verify if user is already a member of the league
      final existingMembership = await FirebaseFirestore.instance
          .collection('userLeagues')
          .where('userId', isEqualTo: userId)
          .where('leagueId', isEqualTo: leagueId)
          .get();

      if (existingMembership.docs.isNotEmpty) {
        print(
            'User is already a member of this league'); // The user is already a member of this league
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: You are already a member of this league'),
            backgroundColor: secondary,
          ),
        );
        return;
      }

      // Add user to the league
      await FirebaseFirestore.instance
          .collection('leagues')
          .doc(leagueId)
          .update({
        'userIds': FieldValue.arrayUnion([userId]),
      });

      // Associate user with the league
      final userLeagueData = {
        'userId': userId,
        'leagueId': leagueId,
        'joinedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('userLeagues')
          .add(userLeagueData);

      print('User joined league successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('You have joined the league ${leagueName} successfully!'),
          backgroundColor: primary,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      print('Error joining league: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error joining league: $e'),
          backgroundColor: secondary,
        ),
      );
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
            if (_codeController.text.isNotEmpty) {
              joinLeague(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error: Code cannot be empty'),
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
              'JOIN',
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
            "Join a league",
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
              child: Text('Enter the league code to join:',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            ),
            SizedBox(height: 10),
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
                  controller: _codeController,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 10),
                    hintText: 'League code',
                    hintStyle: TextStyle(color: gray1, fontSize: 14),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(15),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            actionButtonRow(context, _codeController.text),
          ],
        ),
      ),
    );
  }
}
