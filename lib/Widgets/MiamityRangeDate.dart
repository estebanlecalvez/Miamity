import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

/// Classical MiamityButton which is green (Everything's fine!) , you can define a title, a onPressed function and a width (by default 150)
class MiamityRangeDate extends StatelessWidget {
  MiamityRangeDate({
    this.attribute1,
    this.attribute2,
    this.label1,
    this.label2,
  });

  final String attribute1;
  final String attribute2;
  final String label1;
  final String label2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.0),
      child: Wrap(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(6.0),
            child: FormBuilderDateTimePicker(
              attribute: attribute1,
              decoration: new InputDecoration(
                labelText: label1 ?? "",
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.calendar_today),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                  borderSide: new BorderSide(),
                ),
              ),
              format: DateFormat("dd/MM/yyyy - HH'h'mm"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6.0),
            child: FormBuilderDateTimePicker(
              attribute: attribute2,
              format: DateFormat("dd/MM/yyyy - HH'h'mm"),
              decoration: new InputDecoration(
                labelText: label2 ?? "",
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.calendar_today),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                  borderSide: new BorderSide(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
