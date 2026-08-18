import 'package:flutter/material.dart';

class StyledForms extends StatelessWidget {
  const StyledForms({
    required this.hintText,
    required this.labelText,
    required this.typeForm,
    required this.textController,
    required this.validator,
    this.prefixIcon,
    super.key,
  });

  final String hintText;
  final String labelText;
  final TextInputType typeForm;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      keyboardType: typeForm,
      validator: validator,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}

class StyledFormsPassword extends StatefulWidget {
  const StyledFormsPassword({
    required this.hintText,
    required this.labelText,
    required this.typeForm,
    required this.textController,
    required this.validator,
    super.key,
  });

  final String hintText;
  final String labelText;
  final TextInputType typeForm;
  final TextEditingController textController;
  final String? Function(String?)? validator;

  @override
  State<StyledFormsPassword> createState() => _StyledFormsPasswordState();
}

class _StyledFormsPasswordState extends State<StyledFormsPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      keyboardType: widget.typeForm,
      obscureText: _obscureText,
      validator: widget.validator,
      textInputAction: TextInputAction.done,
      decoration: _inputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: Icons.lock_outline_rounded,
        suffixIcon: IconButton(
          tooltip: _obscureText
              ? 'Afficher le mot de passe'
              : 'Masquer le mot de passe',
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String hintText,
  required String labelText,
  IconData? prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,

    prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,

    suffixIcon: suffixIcon,

    filled: true,
    fillColor: Colors.white,

    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.cyan, width: 2),
    ),

    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
    ),

    labelStyle: TextStyle(color: Colors.grey.shade600),

    hintStyle: TextStyle(color: Colors.grey.shade400),

    prefixIconColor: Colors.grey.shade500,
  );
}
