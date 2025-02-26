import 'package:flutter/material.dart';
import 'package:light_board/utils/text_format.dart';

class TextFormatSelector extends StatefulWidget {
  final TextFormat initialValue;
  final ValueChanged<TextFormat> onChanged;

  TextFormatSelector({
    required this.onChanged,
    this.initialValue = TextFormat.NORMAL,
    });

  @override
  _TextFormatSelectorState createState() => _TextFormatSelectorState();
}

class _TextFormatSelectorState extends State<TextFormatSelector> {
  late TextFormat _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TextFormat>(
      value: _selectedValue,
      onChanged: (TextFormat? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedValue = newValue;
          });
          widget.onChanged(newValue);
        }
      },
      items: TextFormat.values.map<DropdownMenuItem<TextFormat>>((TextFormat value) {
        return DropdownMenuItem<TextFormat>(
          value: value,
          child: Text(value.asString),
        );
      }).toList(),
    );
  }
}