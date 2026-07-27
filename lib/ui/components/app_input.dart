import 'package:cardifly/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInput extends StatefulWidget {
  const AppInput({
    super.key,
    this.formKey,
    this.hintText,
    this.validator,
    this.inputFormatters,
    this.obscureText = false,
    this.controller,
    this.textInputAction,
    this.onEditingComplete,
    this.focusNode,
    this.autoFocus = false,
    this.isRequired = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.onChanged,
    this.suffixIconTap,
    this.maxLines = 1,
    this.filled = true,
    this.fillColor,
    this.maxLength,
    this.textStyle,
    this.textAlign,
    this.suffixIcon,
    this.autofillHints,
    this.readOnly = false,
    this.initialValue,
    this.onTap,
    this.label,
    this.prefixIcon,
    this.width,
    this.minLines = 1,
    this.radius = 8.0,
    this.showClearButton = false,
  });

  final Key? formKey;
  final String? hintText;
  final String? initialValue;
  final String? label;
  final bool obscureText;
  final bool isRequired;
  final bool autoFocus;
  final bool filled;
  final bool readOnly;
  final bool showClearButton;
  final int? maxLength;
  final int minLines;
  final int maxLines;
  final double? width;
  final double radius;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? fillColor;
  final TextStyle? textStyle;
  final VoidCallback? suffixIconTap;
  final TextAlign? textAlign;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _elevationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtle = Theme.of(context).textTheme.displaySmall?.color;

    return AnimatedBuilder(
      animation: _elevationAnimation,
      builder: (context, child) {
        return SizedBox(
          width: widget.width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            child: child,
          ),
        );
      },
      child: TextFormField(
        key: widget.formKey,
        inputFormatters: widget.inputFormatters,
        onTap: widget.onTap,
        textAlign: widget.textAlign ?? TextAlign.start,
        onChanged: widget.onChanged,
        autofocus: widget.autoFocus,
        cursorColor: Constants.appPrimaryColor,
        keyboardType: widget.keyboardType,
        focusNode: _focusNode,
        textInputAction: widget.textInputAction,
        readOnly: widget.readOnly,
        controller: _controller,
        cursorWidth: 1.0,
        cursorHeight: 14,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        minLines: widget.obscureText ? 1 : widget.minLines,
        obscureText: widget.obscureText,
        maxLength: widget.maxLength,
        validator: widget.validator,
        onEditingComplete: widget.onEditingComplete,
        autofillHints: widget.autofillHints,
        textCapitalization: widget.textCapitalization,
        style: widget.textStyle ??
            TextStyle(fontSize: 13, color: subtle?.withValues(alpha: 1.0)),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          filled: widget.filled,
          fillColor: widget.fillColor,
          label: widget.label == null
              ? null
              : RichText(
                  text: TextSpan(
                    text: '${widget.label} ',
                    style: TextStyle(
                      fontSize: 13,
                      color: subtle,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      if (widget.isRequired)
                        const TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                    ],
                  ),
                ),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: subtle, fontSize: 13),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, size: 18, color: subtle)
              : null,
          prefixIconConstraints:
              const BoxConstraints(minWidth: 32, minHeight: 40),
          suffixIcon: _buildSuffixIcon(subtle),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 32, minHeight: 40),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(Color? subtle) {
    if (_controller.text.isNotEmpty &&
        widget.showClearButton &&
        !widget.readOnly) {
      return IconButton(
        onPressed: () {
          _controller.clear();
          widget.onChanged?.call('');
        },
        icon: const Icon(Icons.close_rounded, size: 14),
        color: subtle,
        splashRadius: 14,
        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }
    if (widget.suffixIcon != null) {
      return IconButton(
        onPressed: widget.suffixIconTap,
        icon: Icon(widget.suffixIcon, size: 16),
        color: subtle,
        splashRadius: 14,
        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }
    return null;
  }
}
