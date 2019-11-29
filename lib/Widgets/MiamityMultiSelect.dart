import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MiamityMultiSelect extends StatefulWidget {
  final List<String> reportList;
  MiamityMultiSelect(this.reportList, {this.onSelectionChanged});
  final Function(List<String>) onSelectionChanged;
  @override
  _MiamityMultiSelectState createState() => _MiamityMultiSelectState();
}

class _MiamityMultiSelectState extends State<MiamityMultiSelect> {
  List<String> selectedChoices = List();
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: EdgeInsets.all(2),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      );
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: _buildChoiceList(),
      ),
    );
  }
}
