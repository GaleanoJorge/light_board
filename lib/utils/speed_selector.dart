import 'package:flutter/material.dart';

class SpeedSelector extends StatefulWidget {

  final ValueChanged<int> onChanged;
  double speed;

  SpeedSelector({
    this.speed = 25,
    super.key,
    required this.onChanged,
  });

  @override
  State<SpeedSelector> createState() => _SpeedSelectorState();
}

class _SpeedSelectorState extends State<SpeedSelector> {
  void _incrementSpeed() {
    if (widget.speed < 100) {
      widget.speed += 1;
      setState(() {});
      widget.onChanged(widget.speed.toInt());
    }
  }

  void _decrementSpeed() {
    if (widget.speed > 10) {
      widget.speed -= 1;
      setState(() {});
      widget.onChanged(widget.speed.toInt());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Velocidad: ${widget.speed.toInt()}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_downward, color: Colors.grey),
              onPressed: _decrementSpeed,
            ),
            Expanded(
              child: Slider(
                value: widget.speed,
                min: 10,
                max: 100,
                divisions: 40,
                label: widget.speed.toInt().toString(),
                onChanged: (newValue) {
                  widget.speed = newValue;
                  setState(() {});
                  widget.onChanged(widget.speed.toInt());
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_upward, color: Colors.grey),
              onPressed: _incrementSpeed,
            ),
          ],
        ),
      ],
    );
  }
}