import 'package:flutter/material.dart';
import 'package:local_share/src/theme/theme.dart';

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
      style: TextStyle(color: AppColors.lightwhite),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
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
            color: AppColors.lightwhite,
          ),
        ),
      ),
    );
  }
}