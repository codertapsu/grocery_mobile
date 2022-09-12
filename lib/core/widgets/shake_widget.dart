import 'dart:math';

import 'package:flutter/material.dart';

/**
 * @example
 * 1. declare a GlobalKey
 * final shakeKey = GlobalKey<ShakeWidgetState>();
 * 2. shake the widget via the GlobalKey when a button is pressed
 * child: ElevatedButton(
 *  child: Text('Sign In', style: TextStyle(fontSize: 20)),
 *  onPressed: () => shakeKey.currentState?.shake(),
 *  ),
 * 3. Add a parent ShakeWidget to the child widget we want to animate
 * ShakeWidget(
 * 4. pass the GlobalKey as an argument
 * key: shakeKey,
 * 5. configure the animation parameters
 * shakeCount: 3,
 * shakeOffset: 10,
 * shakeDuration: Duration(milliseconds: 500),
 * 6. Add the child widget that will be animated
 * child: Text(
 * 'Invalid credentials',
 * textAlign: TextAlign.center,
 * style: TextStyle(
 * color: Colors.red,
 * fontSize: 20,
 * fontWeight: FontWeight.bold),
 * ),
 * )
 */

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);
  final Duration animationDuration;
  late final animationController =
      AnimationController(vsync: this, duration: animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 400),
  }) : super(key: key);
  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;

  @override
  ShakeWidgetState createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  ShakeWidgetState(Duration duration) : super(duration);

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // 1. return an AnimatedBuilder
    return AnimatedBuilder(
      // 2. pass our custom animation as an argument
      animation: animationController,
      // 3. optimization: pass the given child as an argument
      child: widget.child,
      builder: (context, child) {
        final sineValue =
            sin(widget.shakeCount * 2 * pi * animationController.value);
        return Transform.translate(
          // 4. apply a translation as a function of the animation value
          offset: Offset(sineValue * widget.shakeOffset, 0),
          // 5. use the child widget
          child: child,
        );
      },
    );
  }
}
