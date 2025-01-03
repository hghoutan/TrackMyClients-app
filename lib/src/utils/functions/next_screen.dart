import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void nextScreen(context, page, {rootNavgation = false}) {
  Navigator.of(context, rootNavigator: rootNavgation).push(MaterialPageRoute(builder: (context) => page));
}

void nextScreeniOS(context, page, {rootNavgation = false}) {
  Navigator.of(context, rootNavigator: rootNavgation).push(CupertinoPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(context, page) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplaceiOS(context, page) {
  Navigator.pushReplacement(context, CupertinoModalPopupRoute(builder: (context) => page));
}

void nextScreenPopup(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(fullscreenDialog: true, builder: (context) => page),
  );
}

void nextScreenPopupiOS(context, page) {
  Navigator.push(
    context,
    CupertinoPageRoute(fullscreenDialog: true, builder: (context) => page),
  );
}

void nextScreenAnimation(context, page, {rootNavgation = false}) {
    Navigator.of(context, rootNavigator: rootNavgation).push(PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) => page,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    ));
  }
void nextScreenReplaceAnimation(context, page,{rootNavgation = false}) {
    Navigator.of(context, rootNavigator: rootNavgation).pushReplacement(PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) => page,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    ));
  }

  void nextScreenCloseOthersAnimation(context, page, {rootNavgation = false}) {
    Navigator.of(context, rootNavigator: rootNavgation).pushAndRemoveUntil(PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) => page,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    ), ((route) => false));
  }


