import 'package:flutter/material.dart';
import 'package:hospitize/utils/constant/color.dart';
import 'package:hospitize/utils/constant/screenUtils.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 1. Hide the status bar using ScreenUtils
    ScreenUtils.hideStatusBar();

    // 2. Create the fade-in animation using ScreenUtils
    _animation = ScreenUtils.createFadeInAnimation(
      vsync: this,
      durationSeconds: 2,
    );

    // 3. Navigate after a delay using ScreenUtils
    ScreenUtils.navigateAfterDelay(
      context: context,
      destination: widget.child!,
      delaySeconds: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "lib/assets/logo.png",
                width: 200, 
              ),
            ],
          ),
        ),
      )
    );
  }
}
