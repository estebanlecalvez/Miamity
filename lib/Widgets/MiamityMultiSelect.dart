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
      choices.add(ChoiceChip(
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
      // La moitié de la taille de l'écran.
      height: MediaQuery.of(context).size.height / 2,
      child: Wrap(
        children: _buildChoiceList(),
      ),
    );
  }
}
