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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: ca.colorsAvailable.entries.firstWhere(
        (entry) => entry.value == widget.initialValue,
        orElse: () => ca.colorsAvailable.entries.first,
      ).key,
      onChanged: (String? newValue) {
        if (newValue != null) {
          widget.initialValue = ca.colorsAvailable[newValue]!;
          setState(() {
          });
          widget.onChanged(ca.colorsAvailable[newValue]!);
        }
      },
      items: ca.colorsAvailable.keys.map<DropdownMenuItem<String>>((key) {
        return DropdownMenuItem<String>(
          value: key,
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: ca.colorsAvailable[key],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
              ),
              SizedBox(width: 8),
              Text(key),
            ],
          ),
        );
      }).toList(),
    );
  }
}