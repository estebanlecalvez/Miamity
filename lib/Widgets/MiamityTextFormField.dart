import 'package:flutter/material.dart';

/// Classical MiamityButton which is green (Everything's fine!) , you can define a title, a onPressed function and a width (by default 150)
class MiamityTextFormField extends StatelessWidget {
  MiamityTextFormField({
    this.isObscureText,
    this.controller,
    this.keyboardType,
    this.validator,
    this.label,
    this.onSaved,
    this.onChanged
  });

  final bool isObscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function(String) validator;
  final String label;
  final Function onSaved;
  final Function onChanged;
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextFormField(
        obscureText: isObscureText ?? false,
        controller: controller ?? null,
        onChanged: onChanged,

        decoration: new InputDecoration(
          labelText: "     " + label,
          alignLabelWithHint: true,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(50.0),
            borderSide: new BorderSide(),
          ),
        ),
        validator: validator ?? null,
        keyboardType: keyboardType,
        onSaved: onSaved,
      ),
    );
  }
}
