// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:toner_kit_counter_reader_nfc/app/ui/utils/utils.dart';

class AndroidSessionDialogNfcKit extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const AndroidSessionDialogNfcKit(this.alertMessage);
  final String alertMessage;
  // final Future<void> Function(NFCTag tag) handleTag;
  // final NFCTag tag;

  @override
  State<AndroidSessionDialogNfcKit> createState() =>
      _AndroidSessionDialogNfcKitState();
}

class _AndroidSessionDialogNfcKitState
    extends State<AndroidSessionDialogNfcKit> {
  // ignore: constant_identifier_names
  static const String READ_NFC_DATA = "0223001B";
  String? _alertMessage;
  String? _errorMessage;
  String? _tagData;
  String? _tagId;

  @override
  void initState() {
    super.initState();
    _tagRead();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = Utils.getWidth(context);
    return AlertDialog(
      title: Text(
        _errorMessage?.isNotEmpty == true
            ? 'Error'
            : _alertMessage?.isNotEmpty == true
                ? 'Success'
                : 'Silahkan scan NFC tag',
      ),
      content: _errorMessage?.isNotEmpty == true
          ? Text(_errorMessage!)
          : _alertMessage?.isNotEmpty == true
              ? Text(_alertMessage!)
              : SizedBox(
                  width: screenWidth * 0.9,
                  child: Lottie.asset('assets/animation/scan-tag-nfc-kyo.json'),
                ),
      actions: [
        TextButton(
          child: Text(_errorMessage?.isNotEmpty == true
              ? 'OK'
              : _alertMessage?.isNotEmpty == true
                  ? 'OK'
                  : 'BATAL'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  @override
  void dispose() {
    FlutterNfcKit.finish();
    super.dispose();
  }

  Future<void> _tagRead() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      setState(() {
        _errorMessage =
            'Tidak ada perangkat NFC atau perangkat NFC tidak dihidupkan';
      });
    }
    try {
      var tag = await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));

      if (tag.id.isEmpty) {
        return setState(() {
          _errorMessage = 'Tidak dapat membaca NFC tag';
        });
      }

      if (tag.type == NFCTagType.iso15693) {
        _tagId = tag.id;
        var tagData = await FlutterNfcKit.transceive(READ_NFC_DATA);
        if (tagData.isNotEmpty) {
          _tagData = tagData;
          setState(() {
            _alertMessage = 'Berhasil membaca data NFC tag';
            Navigator.pop(context, [_tagId, _tagData]);
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Tidak dapat membaca data NFC tag.';
      });
    }
    await FlutterNfcKit.finish();
  }
}
