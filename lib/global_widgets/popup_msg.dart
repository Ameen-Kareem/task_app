import 'package:flutter/material.dart';

class PopupMsg {
  static popUpMsg({required String msg, required BuildContext context}) {
    return ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg)));
  }
}
