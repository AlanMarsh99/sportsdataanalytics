import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/models/league.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/ui/theme.dart';

class LeaveLeagueDialog extends StatelessWidget {
  LeaveLeagueDialog({Key? key, required this.league, required this.user})
      : super(key: key);

  final League league;
  final UserApp user;

  Future<void> leaveLeague(BuildContext context) async {
    try {
      // Reference to the league document
      final leagueDoc =
          FirebaseFirestore.instance.collection('leagues').doc(league.id);

      // Update the userIds array to remove the user's ID
      await leagueDoc.update({
        'userIds': FieldValue.arrayRemove([user.id]),
      });

      final userLeagueQuery = await FirebaseFirestore.instance
          .collection('userLeagues')
          .where('userId', isEqualTo: user.id)
          .where('leagueId', isEqualTo: league.id)
          .get();

      for (var doc in userLeagueQuery.docs) {
        await doc.reference.delete();
      }

      print(
          'User ${user.username}} successfully removed from league ${league.name}}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully removed from league ${league.name}'),
          backgroundColor: primary,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to leave league: $e'),
          backgroundColor: secondary,
        ),
      );
      print('Failed to leave league: $e');
      Navigator.pop(context, false);
      throw Exception('Failed to leave the league. Please try again.');
    }
  }

  Widget actionButtonRow(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            Navigator.pop(context, false);
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
            await leaveLeague(context);
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
              'LEAVE',
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
            "Leave the league",
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
              child: Text('Do you want to leave the league ${league.name}?',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            ),
            const SizedBox(height: 25),
            actionButtonRow(context),
          ],
        ),
      ),
    );
  }
}
