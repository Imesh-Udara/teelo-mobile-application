import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FireAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimatingicon;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallFire;
  const FireAnimation(
      {super.key,
      required this.child,
      required this.isAnimatingicon,
      this.duration = const Duration(milliseconds: 160),
      this.onEnd,
      this.smallFire = false});

  @override
  State<FireAnimation> createState() => _FireAnimationState();
}

class _FireAnimationState extends State<FireAnimation>
    with SingleTickerProviderStateMixin {
  //need to create animation controller
  late AnimationController controller;
  late Animation<double> scaleIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration.inMilliseconds ~/ 3,
      ),
    );
    scaleIcon = Tween<double>(begin: 1, end: 1.4).animate(controller);
  }

  //this call that current widget replace by another widget
  @override
  void didUpdateWidget(covariant FireAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimatingicon != oldWidget.isAnimatingicon) {
      beginAnimation();
    }
  }

  beginAnimation() async {
    if (widget.isAnimatingicon || widget.smallFire) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(
        const Duration(milliseconds: 240),
      );

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleIcon,
      child: widget.child,
    );
  }
}
