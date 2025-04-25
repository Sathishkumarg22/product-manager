import 'package:flutter/material.dart';

class AnimatedDismissibleBackground extends StatelessWidget {
  const AnimatedDismissibleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}