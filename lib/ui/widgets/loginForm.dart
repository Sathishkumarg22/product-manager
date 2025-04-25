import 'package:demo/blocs/auth/auth_bloc.dart';
import 'package:demo/blocs/auth/auth_event.dart';
import 'package:demo/blocs/auth/auth_state.dart';
import 'package:demo/ui/widgets/animatedLoginButton.dart';
import 'package:demo/ui/widgets/animatedTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  final userNameController = TextEditingController(text: 'mor_2314');
  final passwordController = TextEditingController(text: '83r5^_');
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          AnimatedTextField(
            controller: userNameController,
            label: 'Username',
            icon: Icons.person,
            delay: const Duration(milliseconds: 200),
          ),
          const SizedBox(height: 16),
          AnimatedTextField(
            controller: passwordController,
            label: 'Password',
            icon: Icons.lock,
            obscureText: true,
            delay: const Duration(milliseconds: 400),
          ),
          const SizedBox(height: 24),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return AnimatedLoginButton(
                isLoading: state is AuthLoading,
                onPressed: () {
                  setState(() => _isButtonPressed = true);
                  context.read<AuthBloc>().add(
                    LoginRequested(
                      username: userNameController.text,
                      password: passwordController.text,
                    ),
                  );
                  Future.delayed(
                    const Duration(milliseconds: 300),
                    () => setState(() => _isButtonPressed = false),
                  );
                },
                isPressed: _isButtonPressed,
              );
            },
          ),
        ],
      ),
    );
  }
}
