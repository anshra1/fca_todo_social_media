import 'package:flutter/material.dart';

class SmoothKeyboardDismiss extends StatefulWidget {
  const SmoothKeyboardDismiss({
    required this.child,
    super.key,
    this.duration = const Duration(seconds: 1),
    this.curve = Curves.easeInOut,
  });
  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  SmoothKeyboardDismissState createState() => SmoothKeyboardDismissState();
}

class SmoothKeyboardDismissState extends State<SmoothKeyboardDismiss>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    if (FocusScope.of(context).hasFocus) {
      _controller.forward().then((_) {
        FocusScope.of(context).unfocus();
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
          return Container(
            padding: EdgeInsets.only(
              bottom: bottomPadding * (1 - _animation.value),
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
