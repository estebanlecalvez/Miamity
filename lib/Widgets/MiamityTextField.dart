import 'package:flutter/material.dart';

///  By default, nothing is required, but better to perform things onto it.
/// 
/// text: [String]   the labelText of the TextField
/// 
/// controller: [TextEditingController]   the controller which use this TextField
/// 
/// labelColor: [Color]   the color of the label. By default => Green
/// 
/// keyboardType: [TextInputType]   The type of keyboard (phone/email/number etc.)
///   
/// isPasswordField : [bool]   If this is a password TextField => true
/// 
/// isPostalCode: [bool]   If this is a postal code TextField => true (limit to 5 characters)
/// 
/// doCorrect: [bool]   Ce widget doit il corriger automatiquement les fautes? by default : false.
/// 
/// onTapFunction: [Function] Permet de dire si on appel une fonction en appuyant sur le bouton ou non
class MiamityTextField extends StatelessWidget {
  MiamityTextField(
      {this.text,
      this.controller,
      this.labelColor,
      this.keyboardType,
      this.isPasswordField,
      this.isPostalCode,
      this.doCorrect,
      this.onTapFunction});

  
  final String text;
  final TextEditingController controller;
  final Color labelColor;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final bool isPostalCode;
  final bool doCorrect;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
            labelText: text,
            labelStyle: TextStyle(
                color: labelColor ?? Colors.green,
                fontWeight: FontWeight.w600)),
        keyboardType: keyboardType,
        controller: controller,
        onTap: onTapFunction ?? null,
        autocorrect: doCorrect ?? false,
        obscureText: isPasswordField ?? false);
  }
}
