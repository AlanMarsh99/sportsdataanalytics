import 'package:flutter/material.dart';
import 'package:frontend/ui/theme.dart';

class WarningDialog extends StatelessWidget {
  final String message;
  final bool error;

  WarningDialog({required this.message, required this.error});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: error
            ? const Text(
                "ERROR",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              )
            : const Text(
                "WARNING",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        content: Text(message, style: const TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(color: primary),
            ),
          ),
        ],);
  }
}
