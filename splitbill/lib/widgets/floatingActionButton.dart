import 'package:flutter/material.dart';

/// Um FAB muito simples e reutilizável.
/// Use: SimpleFAB(onPressed: () { ... });
class SimpleFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;

  const SimpleFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      child: Icon(icon),
    );
  }
}