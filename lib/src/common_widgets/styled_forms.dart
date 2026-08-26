import 'package:flutter/material.dart';
import 'package:local_share/src/theme/theme.dart';

class StyledForms extends StatefulWidget {
  const StyledForms({
    super.key,
    this.hintText,
    this.labelText,
    required this.typeForm,
    required this.textController,
    required this.validator,
    this.prefixIcon,
    this.isPassword = false,
  });

  final String? hintText;
  final String? labelText;
  final TextInputType typeForm;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool isPassword;

  @override
  State<StyledForms> createState() => _StyledFormsState();
}

class _StyledFormsState extends State<StyledForms> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      keyboardType: widget.typeForm,
      obscureText: _obscureText,
      validator: widget.validator,
      textInputAction: widget.isPassword
          ? TextInputAction.done
          : TextInputAction.next,
      style: TextStyle(color: AppColors.lightwhite),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : (widget.isPassword
                  ? const Icon(Icons.lock_outline_rounded)
                  : null),
        suffixIcon: widget.isPassword
            ? IconButton(
                tooltip: _obscureText
                    ? "Afficher le mot de passe"
                    : "Masquer le mot de passe",
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
              )
            : null,
      ),
    );
  }
}
