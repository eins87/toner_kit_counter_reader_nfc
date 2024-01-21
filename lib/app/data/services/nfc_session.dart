// ignore: unused_import
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

Future<void> startSession({
  required BuildContext context,
  required Future<String?> Function(NfcTag) handleTag,
  String alertMessage = 'Hold your device near the item.',
}) async {
  if (!(await NfcManager.instance.isAvailable())) {
    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (context) => _UnavailableDialog(),
    );
  }

  if (Platform.isAndroid) {
    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (context) => _AndroidSessionDialog(alertMessage, handleTag),
    );
  }

  throw ('unsupported platform: ${Platform.operatingSystem}');
}

class _UnavailableDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: const Text(
          'NFC may not be supported or may be temporarily turned off.'),
      actions: [
        TextButton(
          child: const Text('GOT IT'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class _AndroidSessionDialog extends StatefulWidget {
  const _AndroidSessionDialog(this.alertMessage, this.handleTag);
  final String alertMessage;
  final Future<String?> Function(NfcTag tag) handleTag;

  @override
  State<_AndroidSessionDialog> createState() => __AndroidSessionDialogState();
}

class __AndroidSessionDialogState extends State<_AndroidSessionDialog> {
  String? _alertMessage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          final result = await widget.handleTag(tag);
          if (result == null) return;
          await NfcManager.instance.stopSession();
          setState(() => _alertMessage = result);
        } catch (e) {
          await NfcManager.instance.stopSession().catchError((_) {/* no op */});
          setState(() => _errorMessage = '$e');
        }
      },
    ).catchError((e) => setState(() => _errorMessage = '$e'));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _errorMessage?.isNotEmpty == true
            ? 'Error'
            : _alertMessage?.isNotEmpty == true
                ? 'Success'
                : 'Ready to scan',
      ),
      content: Text(
        _errorMessage?.isNotEmpty == true
            ? _errorMessage!
            : _alertMessage?.isNotEmpty == true
                ? _alertMessage!
                : widget.alertMessage,
      ),
      actions: [
        TextButton(
          child: Text(
            _errorMessage?.isNotEmpty == true
                ? 'GOT IT'
                : _alertMessage?.isNotEmpty == true
                    ? 'OK'
                    : 'CANCEL',
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession().catchError((_) {/* no op */});
    super.dispose();
  }
}
