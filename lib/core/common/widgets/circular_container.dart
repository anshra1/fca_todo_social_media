import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    required this.child,
    super.key,
    this.color = Colors.blue,
    this.boxShape = BoxShape.rectangle,
  });

  final Widget child;
  final Color color;
  final BoxShape boxShape;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: boxShape,
        color: color,
      ),
      child: child,
    );
  }
}
