import 'package:flutter/material.dart';

class CardContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color background;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  const CardContainer({
    super.key,
    required this.child,
    required this.background,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding = const EdgeInsets.all(16),
  });

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.98,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) => _controller.forward(),
      onTapCancel: () => _controller.forward(),
      child: ScaleTransition(
        scale: _controller,
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.background,
            borderRadius: widget.borderRadius,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
