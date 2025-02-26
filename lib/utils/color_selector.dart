import 'package:flutter/material.dart';
import 'package:light_board/utils/colors_available.dart' as ca;

class ColorSelector extends StatefulWidget {
  Color initialValue;
  final ValueChanged<Color> onChanged;

  ColorSelector({required this.initialValue, required this.onChanged});

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  // late Color _selectedValue;

  @override
  void initState() {
    super.initState();
    // _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Color>(
      value: widget.initialValue,
      onChanged: (Color? newValue) {
        if (newValue != null) {
          setState(() {
            widget.initialValue = newValue;
          });
          widget.onChanged(newValue);
        }
      },
      items: ca.colorsAvailable.map<DropdownMenuItem<Color>>((value) {
        return DropdownMenuItem<Color>(
          value: value,
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: value,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}