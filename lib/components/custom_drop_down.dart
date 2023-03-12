import 'package:flutter/material.dart';

class MyDropdownListWidget extends StatefulWidget {
  final List<String> options;
  final TextEditingController controller;

  const MyDropdownListWidget({
    Key? key,
    required this.options,
    required this.controller,
  }) : super(key: key);

  @override
  _MyDropdownListWidgetState createState() => _MyDropdownListWidgetState();
}

class _MyDropdownListWidgetState extends State<MyDropdownListWidget> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedOption,
      onChanged: (newValue) {
        setState(() {
          _selectedOption = newValue!;
          widget.controller.text = newValue;
        });
      },
      items: widget.options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }
}
