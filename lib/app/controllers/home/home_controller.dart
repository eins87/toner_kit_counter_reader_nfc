import 'dart:convert';
import 'dart:io';
import 'package:convert/convert.dart';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:toner_kit_counter_reader_nfc/app/controllers/home/unavailabledialog.dart';

// import '../../data/models/dummy.dart';
import 'androidsessiondialognfckit.dart';

class HomeController extends GetxController {
  // get list data from dummy.dart and pass it to variable
  // List<dynamic> data = Dummy.data;

  final RxString chipID = 'None'.obs;
  final RxDouble percentage = 0.00.obs;
  final RxString serialNumber = 'None'.obs;
  final RxInt capacity = 0.obs;
  final RxInt used = 0.obs;

  final RxString tonerType = 'None'.obs;
  final RxString colorTypeLetter = 'N'.obs;
  final RxString catridTypeLetter = 'None'.obs;
  Rx<Color> colorTypeBackground = Colors.black12.obs;
  RxList additionalData = [].obs;

  String upadateChipId() {
    try {
      additionalData[0] == null
          ? chipID.value = 'Belum ada data'
          : chipID.value = additionalData[0];
    } catch (e) {
      chipID.value = 'Belum ada data';
    }
    return chipID.value;
  }

  String updateSerialNumber() {
    try {
      String dataSN = additionalData[1];
      String hexSN = dataSN.substring(162, 178);
      List<int> byteArraySn = hex.decode(hexSN);
      serialNumber.value = utf8.decode(byteArraySn);
      serialNumber.value == ''
          ? serialNumber.value = 'Belum ada data'
          : serialNumber.value;
    } catch (e) {
      serialNumber.value = 'Belum ada data';
    }
    return serialNumber.value;
  }

  double updatePercentage() {
    if (capacity.value == 0) {
      return percentage.value = 0.00;
    }

    double percent = 100.0 - ((used / capacity.value) * 100);
    if (percent < 0) {
      return percentage.value = 0.00;
    }
    String formattedNumber = percent.toStringAsFixed(2);
    percentage.value = double.parse(formattedNumber);
    return percentage.value;
  }

  int updateCapacity() {
    try {
      String dataCapasity = additionalData[1];
      String hexCapasity = dataCapasity.substring(138, 142);
      List<int> byteArrayCapasity = hex.decode(hexCapasity);
      Iterable<int> byteArrayRevesed = byteArrayCapasity.reversed;
      String hexString = hex.encode(byteArrayRevesed.toList());
      String cap = int.parse(hexString, radix: 16).toString();
      capacity.value = int.parse('${cap}0', radix: 10);
    } catch (e) {
      capacity.value = 0;
    }
    return capacity.value;
  }

  int updateUsed() {
    try {
      String dataUsed = additionalData[1];
      String hexUsed = dataUsed.substring(18, 24);
      List<int> byteArrayUsed = hex.decode(hexUsed);
      Iterable<int> byteArrayUsedRevesed = byteArrayUsed.reversed;
      String hexString = hex.encode(byteArrayUsedRevesed.toList());
      String usedCounter = int.parse(hexString, radix: 16).toString();
      used.value = int.parse(usedCounter, radix: 10);
    } catch (e) {
      used.value = 0;
    }
    return used.value;
  }

  String updateTonerType() {
    try {
      String dataTonerType = additionalData[1];
      String hexTonerType = dataTonerType.substring(194, 210);
      List<int> byteArrayTonerType = hex.decode(hexTonerType);
      tonerType.value = utf8.decode(byteArrayTonerType);
      tonerType.value == ''
          ? tonerType.value = 'Belum ada data'
          : tonerType.value;
    } catch (e) {
      tonerType.value = 'Belum ada data';
    }
    return tonerType.value;
  }

  String updateColorTypeLetter() {
    tonerType.value == '' || tonerType.value == 'Belum ada data'
        ? colorTypeLetter.value = 'N'
        : colorTypeLetter.value = tonerType.substring(7, 8);
    updateColorTypeBackground();
    return colorTypeLetter.value;
  }

  String updateCatridTypeLetter() {
    tonerType.value == '' || tonerType.value == 'Belum ada data'
        ? catridTypeLetter.value = 'None'
        : catridTypeLetter.value = tonerType.substring(0, 7);
    return catridTypeLetter.value;
  }

  Color updateColorTypeBackground() {
    colorTypeLetter.value == 'K'
        ? colorTypeBackground.value = const Color.fromRGBO(0, 0, 0, 1)
        : colorTypeBackground.value;
    colorTypeLetter.value == 'C'
        ? colorTypeBackground.value = const Color.fromRGBO(0, 255, 255, 1)
        : colorTypeBackground.value;
    colorTypeLetter.value == 'M'
        ? colorTypeBackground.value = const Color.fromRGBO(255, 0, 255, 1)
        : colorTypeBackground.value;
    colorTypeLetter.value == 'Y'
        ? colorTypeBackground.value = const Color.fromRGBO(255, 255, 0, 1)
        : colorTypeBackground.value;
    colorTypeLetter.value == 'N'
        ? colorTypeBackground.value = Colors.black12
        : colorTypeBackground;
    return colorTypeBackground.value;
  }

  RxList getAdditionalData() {
    return additionalData;
  }

  void clearAdditionalData() {
    additionalData.clear();
    updateData();
  }

  @override
  void onInit() {
    super.onInit();
    print('homecontroller init');
    // percentage.listen((p0) {
    //   debugPrint('percentage changed $percentage');
    // });
  }

  @override
  void onReady() {
    super.onReady();
    print('homecontroller ready');
  }

  @override
  void onClose() {
    super.onClose();
    print('homecontroller close');
  }

  Future<dynamic> startSession({
    required BuildContext context,
    String alertMessage = 'Dekatkan perangkat NFC reader dengan NFC tag.',
  }) async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder: (context) => const UnavailableDialog(),
      );
    }

    if (Platform.isAndroid) {
      // ignore: use_build_context_synchronously
      final result = await showDialog(
        context: context,
        builder: (context) => AndroidSessionDialogNfcKit(alertMessage),
      );

      // print(jsonEncode(result));
      additionalData.value = [];
      if (result == null) {
        return;
      }
      for (var i in result!) {
        additionalData.add(i);
      }
      //print(additionalData);
      updateData();
      return;
    }

    throw ('Platform tidak didukung: ${Platform.operatingSystem}');
  }

  void updateData() {
    upadateChipId();
    updateSerialNumber();
    updateCapacity();
    updateUsed();
    updatePercentage();
    updateTonerType();
    updateColorTypeLetter();
    updateCatridTypeLetter();
  }
}
