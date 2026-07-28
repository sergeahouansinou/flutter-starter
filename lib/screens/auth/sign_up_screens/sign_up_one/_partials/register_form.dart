import 'package:cardifly/screens/auth/sign_up_screens/sign_up_one/_partials/terms_checkbox.dart';
import 'package:cardifly/ui/components/app_button_widget.dart';
import 'package:cardifly/ui/components/app_input.dart';
import 'package:cardifly/utils/util.dart';
import 'package:flutter/cupertino.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.onSubmit,
    this.onTerms,
    this.onPrivacy,
    this.loading = false,
  });

  final void Function(String fullName, String email, String password) onSubmit;
  final VoidCallback? onTerms;
  final VoidCallback? onPrivacy;
  final bool loading;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;
  bool _showTermsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppInput(
            label: 'Full name',
            hintText: 'Type your full name',
            prefixIcon: CupertinoIcons.person,
            controller: _nameController,
            isRequired: true,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: Util.fieldValidate,
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          AppInput(
            label: 'Password',
            hintText: 'Type your password',
            prefixIcon: CupertinoIcons.lock,
            controller: _passwordController,
            obscureText: _obscurePassword,
            isRequired: true,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            validator: Util.passwordValidate,
            suffixIcon: _obscurePassword
                ? CupertinoIcons.eye
                : CupertinoIcons.eye_slash,
            suffixIconTap: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 16),
          AppInput(
            label: 'Confirm password',
            hintText: 'Repeat your password',
            prefixIcon: CupertinoIcons.lock_shield,
            controller: _confirmController,
            obscureText: _obscureConfirm,
            isRequired: true,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onEditingComplete: _submit,
            validator: _validateConfirmation,
            suffixIcon: _obscureConfirm
                ? CupertinoIcons.eye
                : CupertinoIcons.eye_slash,
            suffixIconTap: () =>
                setState(() => _obscureConfirm = !_obscureConfirm),
          ),
          const SizedBox(height: 18),
          TermsCheckbox(
            value: _acceptedTerms,
            onChanged: _onTermsChanged,
            onTerms: widget.onTerms,
            onPrivacy: widget.onPrivacy,
            errorText: _showTermsError
                ? 'Please accept the terms to continue'
                : null,
          ),
          const SizedBox(height: 20),
          AppButtonWidget(
            title: 'Sign Up',
            loading: widget.loading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }

  void _onTermsChanged(bool value) {
    setState(() {
      _acceptedTerms = value;
      if (value) _showTermsError = false;
    });
  }

  String? _validateConfirmation(String? value) {
    final required = Util.passwordValidate(value);
    if (required != null) return required;
    return Util.passwordConfValidate(_passwordController.text, value);
  }

  void _submit() {
    if (widget.loading) return;

    final validForm = _formKey.currentState?.validate() ?? false;
    if (!_acceptedTerms) setState(() => _showTermsError = true);
    if (!validForm || !_acceptedTerms) return;

    widget.onSubmit(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );
  }
}
