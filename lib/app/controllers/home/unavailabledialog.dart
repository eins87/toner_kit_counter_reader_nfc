import 'package:flutter/material.dart';

class UnavailableDialog extends StatelessWidget {
  const UnavailableDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: const Text(
          'Perangkat NFC tidak didukung atau mungkin perangkat NFC dimatikan'),
      actions: [
        TextButton(
          child: const Text('GOT IT'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
