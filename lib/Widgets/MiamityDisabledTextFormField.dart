import 'package:flutter/material.dart';

class MiamityDisabledTextFormField extends StatefulWidget {
  MiamityDisabledTextFormField({
    this.isObscureText,
    this.controller,
    this.keyboardType,
    this.validator,
    this.label,
    this.onSaved,
    this.onChanged,
    this.icon,
    this.readOnly,
    this.isFocused,
    this.onTap,
    this.disabled,
  });

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
  final bool disabled;

  @override
  _MiamityDisabledTextFormFieldState createState() =>
      _MiamityDisabledTextFormFieldState();
}

class _MiamityDisabledTextFormFieldState
    extends State<MiamityDisabledTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextFormField(
        obscureText: widget.isObscureText ?? false,
        autofocus: widget.isFocused ?? false,
        controller: widget.controller ?? null,
        enabled: widget.disabled ?? true,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        readOnly: widget.readOnly ?? false,
        decoration: new InputDecoration(
          labelText: widget.icon != null ? widget.label : "${widget.label}",
          alignLabelWithHint: true,
          fillColor: Colors.white,
          prefixIcon: Icon(widget.icon) ?? null,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(50.0),
            borderSide: new BorderSide(),
          ),
        ),
        validator: widget.validator ?? null,
        keyboardType: widget.keyboardType,
        onSaved: widget.onSaved,
      ),
    );
  }
}
