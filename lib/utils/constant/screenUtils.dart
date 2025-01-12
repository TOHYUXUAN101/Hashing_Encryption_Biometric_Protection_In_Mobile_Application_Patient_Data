import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospitize/main.dart';

class ScreenUtils {
  
  /// Hide the notification bar (status bar)
  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  /// Create and start a fade-in animation
  static Animation<double> createFadeInAnimation({
    required TickerProvider vsync,
    required int durationSeconds,
  }) {
    final controller = AnimationController(
      vsync: vsync,
      duration: Duration(seconds: durationSeconds),
    );
    final animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
    return animation;
  }

  /// Navigate to a new screen with a delay and remove the current route stack
  static void navigateAfterDelay({
    required BuildContext context,
    required Widget destination,
    required int delaySeconds,
  }) {
    Future.delayed(
      Duration(seconds: delaySeconds),
      () {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => destination),
          (route) => false,
        );
      },
    );
  }

  static void showCupertinoAlertDialog(BuildContext context, String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
