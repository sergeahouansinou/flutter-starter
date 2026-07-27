import 'package:cardifly/ui/components/app_button_widget.dart';
import 'package:cardifly/ui/components/app_input.dart';
import 'package:cardifly/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSubmit,
    this.onForgotPassword,
    this.loading = false,
  });

  final void Function(String email, String password) onSubmit;
  final VoidCallback? onForgotPassword;
  final bool loading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.loading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmit(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppInput(
            label: 'Email',
            hintText: 'Type your email',
            prefixIcon: CupertinoIcons.envelope,
            controller: _emailController,
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Util.requireAndValidateEmail,
          ),
          const SizedBox(height: 20),
          AppInput(
            label: 'Password',
            hintText: 'Type your password',
            prefixIcon: CupertinoIcons.lock,
            controller: _passwordController,
            obscureText: _obscurePassword,
            isRequired: true,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onEditingComplete: _submit,
            validator: Util.passwordValidate,
            suffixIcon: _obscurePassword
                ? CupertinoIcons.eye
                : CupertinoIcons.eye_slash,
            suffixIconTap: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              child: const Text(
                'Forgot Password ?',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AppButtonWidget(
            title: 'Sign In',
            loading: widget.loading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
