import 'package:flutter/material.dart';

class StyledForms extends StatefulWidget {
  const StyledForms({
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
  State<StyledForms> createState() =>
      _StyledFormsState();
}

class _StyledFormsState extends State<StyledForms> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.typeForm,
      maxLines: null,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.cyan, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          borderSide: BorderSide(color: Colors.yellow, width: 2.0),
        ),
      ),
      validator: widget.validator,
      controller: widget.textController,
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
  State<StyledFormsPassword> createState() =>
      _StyledFormsPasswordState();
}

class _StyledFormsPasswordState
    extends State<StyledFormsPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.typeForm,
      maxLines: 1,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.cyan,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.cyan, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          borderSide: BorderSide(color: Colors.yellow, width: 2.0),
        ),
      ),
      validator: widget.validator,
      controller: widget.textController,
    );
  }
}
