import 'package:flutter/material.dart';

class AnimatedLoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final bool isPressed;

  const AnimatedLoginButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.isPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        child:
            isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
                : const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
      ),
    );
  }
}
