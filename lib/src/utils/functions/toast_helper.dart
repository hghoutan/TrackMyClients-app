import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static ToastHelper? _instance;
  FToast? _fToast;

  factory ToastHelper() {
    return _instance ??= ToastHelper._internal();
  }

  ToastHelper._internal();

  void init(BuildContext context) {
    _fToast = FToast();
    _fToast?.init(context);
  }

  void showCustomToast({
    required BuildContext context,
    Widget? toast,
    String? message,
    
    Duration? toastDuration,
    ToastGravity? gravity,
    Widget Function(BuildContext, Widget)? positionedToastBuilder,
  }) {
    _fToast?.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: toast ??  Text(
        message!,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      ),
      gravity: gravity ?? ToastGravity.BOTTOM,
      toastDuration: toastDuration ?? Duration(seconds: 2),
      positionedToastBuilder: positionedToastBuilder,
    );
  }
}