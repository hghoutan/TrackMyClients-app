import 'package:flutter/material.dart';

class MainButtonWidget extends StatelessWidget {
  final String text;
  final TextStyle style;
  final VoidCallback onPressed;
  final bool isFromAlertDialog;
  final bool isSmallBtn;
  final Color backgroundColor;
  const MainButtonWidget({
    super.key,
    required this.text,
    required this.style,
    this.isFromAlertDialog = false,
    this.isSmallBtn = false,
    this.backgroundColor = const Color(0xff125B8A),
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFromAlertDialog ? 300 : double.infinity,
      padding: const EdgeInsets.only(top: 16.0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isSmallBtn ? 12.0 : 10.0)),
          textStyle: style,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
              horizontal: 24.0, vertical: isSmallBtn ? 12.0 : 18.0),
          backgroundColor: backgroundColor,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
