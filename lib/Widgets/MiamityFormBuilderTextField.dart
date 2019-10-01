import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Classical MiamityButton which is green (Everything's fine!) , you can define a title, a onPressed function and a width (by default 150)
class MiamityFormBuilderTextField extends StatelessWidget {
  MiamityFormBuilderTextField(
      {this.isObscureText,
      this.controller,
      this.keyboardType,
      this.validators,
      this.label,
      this.onChanged,
      this.icon,
      this.readOnly,
      this.isFocused,
      @required this.attribute});

  final bool isObscureText;
  final String attribute;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<String Function(dynamic)> validators;
  final String label;
  final Function onChanged;
  final IconData icon;
  final bool readOnly;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: FormBuilderTextField(
        attribute: attribute,
        obscureText: isObscureText ?? false,
        autofocus: isFocused ?? false,
        controller: controller ?? null,
        onChanged: onChanged,
        readOnly: readOnly ?? false,
        decoration: new InputDecoration(
          labelText: icon != null ? label : "$label",
          alignLabelWithHint: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon) ?? null,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(50.0),
            borderSide: new BorderSide(),
          ),
        ),
        validators: validators ?? null,
        keyboardType: keyboardType,
      ),
    );
  }
}
