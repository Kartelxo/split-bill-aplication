import 'package:flutter/material.dart';

/// Extended FAB simples e minimalista.
/// Use: ExtendedFAB(label: 'Adicionar', onPressed: () {} )
class ExtendedFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color? backgroundColor;

  const ExtendedFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
    required this.label,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      backgroundColor: backgroundColor,
    );
  }
}
