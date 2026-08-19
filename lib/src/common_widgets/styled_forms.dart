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
      style: const TextStyle(color: Color(0xFFF5F6FA)),
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
      style: const TextStyle(color: Color(0xFFF5F6FA)),
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
            color: const Color(0xFFA4B0BE),
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
    // Fond sombre pour le champ de texte (cohérent avec les cartes du mode sombre)
    fillColor: const Color(0xFF2C2C2C),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: const Color(0xFF6C63FF).withValues(alpha :0.3),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      // Bordure violette principale lors du focus
      borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFFF4757), width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFFF4757), width: 2),
    ),
    labelStyle: const TextStyle(color: Color(0xFFA4B0BE)),
    hintStyle: TextStyle(color: const Color(0xFFA4B0BE).withValues(alpha :0.5)),
    prefixIconColor: const Color(0xFF6C63FF),
  );
}