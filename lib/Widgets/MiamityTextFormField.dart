import 'package:flutter/material.dart';

/// Classical MiamityButton which is green (Everything's fine!) , you can define a title, a onPressed function and a width (by default 150)
class MiamityTextFormField extends StatelessWidget {
  MiamityTextFormField(
      {this.isObscureText,
      this.controller,
      this.keyboardType,
      this.validator,
      this.label,
      this.onSaved,
      this.onChanged,
      this.icon,
      this.readOnly,
      this.isFocused,this.onTap});

  final bool isObscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function(String) validator;
  final String label;
  final Function onSaved;
  final Function onChanged;
  final IconData icon;
  final bool readOnly;
  final bool isFocused;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextFormField(
        obscureText: isObscureText ?? false,
        autofocus: isFocused ?? false,
        controller: controller ?? null,
        onChanged: onChanged,
        onTap:onTap,
        readOnly: readOnly ?? false,
        decoration: new InputDecoration(
          labelText: icon != null ? label : "     $label",
          alignLabelWithHint: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon) ?? null,
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
