import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

flushbar(context, String message) {
  Flushbar(
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: Colors.green,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    borderRadius: BorderRadius.circular(10.0),
  ).show(context);
}
