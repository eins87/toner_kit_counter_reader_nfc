import 'package:flutter/material.dart';

class Utils {
  static double getWidth(context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double getHeight(context) {
    return MediaQuery.sizeOf(context).height;
  }
}
