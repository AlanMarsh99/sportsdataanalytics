import 'package:flutter/material.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/theme.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String message;

  InfoDialog({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      content: Text(message, style: TextStyle(color: Colors.black, fontSize: isMobile ? 14 : 16)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "OK",
            style: TextStyle(color: primary),
          ),
        ),
      ],
    );
  }
}
