import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomRaisedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;
  final Color? color;
  final List<Color>? colors;
  final List<BoxShadow>? shadow;
  final Alignment? begin;
  final Alignment? end;
  final double radius;
  final double height = 54;

  const CustomRaisedButton({
    Key? key,
    this.onTap,
    this.onLongPress,
    required this.child,
    this.color = primaryColor,
    this.colors = const [primaryColor, primaryColor],
    this.shadow,
    this.begin,
    this.end,
    this.radius = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: height,
      decoration: BoxDecoration(
        color: onTap == null ? Colors.grey : color,
        borderRadius: BorderRadius.circular(radius),
        gradient: colors == null || onTap == null
            ? null
            : LinearGradient(
                begin: begin ?? Alignment.topCenter,
                end: end ?? Alignment.bottomCenter,
                colors: colors ?? [],
              ),
        boxShadow: shadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
