import 'package:flutter/cupertino.dart';
import 'package:supercharged/supercharged.dart';

class MySlideTransition extends StatefulWidget {
  final Widget child;
  final Offset offset;

  /// delay in milliseconds
  final int delay;

  /// duration in milliseconds
  final int duration;

  const MySlideTransition({
    required this.child,
    this.offset = const Offset(0.5, 0.0),
    this.delay = 300,
    this.duration = 300,
    super.key,
  });

  @override
  State<MySlideTransition> createState() => _MySlideTransitionState();
}

class _MySlideTransitionState extends State<MySlideTransition>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration.milliseconds,
      vsync: this,
    );

    widget.delay.milliseconds.delay.then((_) => _controller?.forward());
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return widget.child;

    return FadeTransition(
      opacity: _controller!,
      child: SlideTransition(
        position: widget.offset
            .tweenTo(Offset.zero)
            .curved(Curves.easeOutExpo)
            .animatedBy(_controller!),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;

    super.dispose();
  }
}
