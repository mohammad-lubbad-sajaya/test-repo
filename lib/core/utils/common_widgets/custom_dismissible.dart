import 'package:flutter/material.dart';

class CustomDismissible extends StatefulWidget {
  final String dismissibleKey;
  final Widget child;
  final Widget? background;
  final Widget? secondaryBackground;
  final DismissDirectionCallback? onResize;
  final DismissDirectionCallback? onDismissed;
  final bool freezeSlide;

  const CustomDismissible({
    Key? key,
    required this.dismissibleKey,
    required this.child,
    required this.background,
    required this.secondaryBackground,
    this.onResize,
    required this.onDismissed,
    required this.freezeSlide,
  }) : super(key: key);

  @override
  _CustomDismissibleState createState() => _CustomDismissibleState();
}

class _CustomDismissibleState extends State<CustomDismissible> {
  Offset _startOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: widget.freezeSlide ? null : _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        children: [
          if (widget.secondaryBackground != null)
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _startOffset.dx != 0 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.centerRight,
                  child: widget.secondaryBackground,
                ),
              ),
            ),
          Dismissible(
            key: Key(widget.dismissibleKey),
            child: widget.child,
            background: widget.background,
            secondaryBackground: widget.secondaryBackground,
            resizeDuration: null,
            onDismissed: widget.onDismissed,
          ),
        ],
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _startOffset = details.localPosition;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_startOffset == Offset.zero) return;

    final newPosition = details.localPosition;
    final dx = newPosition.dx - _startOffset.dx;

    if (widget.onResize != null) {
      if (dx > 0) {
        widget.onResize!(DismissDirection.startToEnd);
      } else if (dx < 0) {
        widget.onResize!(DismissDirection.endToStart);
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _startOffset = Offset.zero;
    });
  }
}
