import 'package:flutter/material.dart';

class LoaderWidget extends StatefulWidget {
  final double width;
  final double height;
  final bool useIcon;
  final IconData? icon;
  final Color? iconColor;
  final String? imagePath;

  const LoaderWidget({
    super.key,
    required this.width,
    required this.height,
    this.useIcon = false,
    this.icon,
    this.iconColor,
    this.imagePath,
  });

  @override
  LoaderWidgetState createState() => LoaderWidgetState();
}

class LoaderWidgetState extends State<LoaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
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
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: child,
          );
        },
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: widget.useIcon
              ? Icon(
                  widget.icon ?? Icons.hourglass_empty,
                  size: widget.width,
                  color: widget.iconColor ??
                      Theme.of(context).colorScheme.secondary,
                )
              : Image.asset(
                  widget.imagePath ?? 'assets/images/app_logo.png',
                  width: widget.width,
                  height: widget.height,
                ),
        ),
      ),
    );
  }
}
