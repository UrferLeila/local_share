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
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
    );
  }
}
