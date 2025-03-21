import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  final Color? color;
  final double? size;
  final String? text;

  const LoadingAnimation({
    Key? key,
    this.color,
    this.size,
    this.text,
  }) : super(key: key);

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _animation,
            child: Container(
              width: widget.size ?? 80,
              height: widget.size ?? 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    (widget.color ?? Colors.orange).withOpacity(0.2),
                    (widget.color ?? Colors.orange).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (widget.color ?? Colors.orange).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.local_movies_outlined,
                size: (widget.size ?? 80) * 0.6,
                color: widget.color ?? Colors.orange,
              ),
            ),
          ),
          if (widget.text != null) ...[
            SizedBox(height: 20),
            Text(
              widget.text!,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
