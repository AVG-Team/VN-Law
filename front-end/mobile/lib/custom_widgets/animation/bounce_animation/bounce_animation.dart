import 'package:flutter/material.dart';

typedef BounceWidgetBuilder = Widget Function(
    BuildContext context, VoidCallback onTap);

class BounceAnimationBuilder extends StatefulWidget {
  final double scaleMagnitude;
  final BounceWidgetBuilder builder;

   const BounceAnimationBuilder(
      {super.key ,this.scaleMagnitude = 0.2, required this.builder}) : assert(scaleMagnitude >= 0 && scaleMagnitude <= 1);

  @override
  BounceAnimationBuilderState createState() => BounceAnimationBuilderState();
}

class BounceAnimationBuilderState extends State<BounceAnimationBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
        upperBound: widget.scaleMagnitude)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 - _controller.value,
      child: widget.builder(context,() => _controller.forward()),
    );
  }
}
