import 'package:flutter/material.dart';

class MyDropdownListWidget extends StatefulWidget {
  final List<String> options;
  TextEditingController controller;

  MyDropdownListWidget({
    Key? key,
    required this.options,
    required this.controller,
  }) : super(key: key);

  @override
  _MyDropdownListWidgetState createState() => _MyDropdownListWidgetState();
}
class _MyDropdownListWidgetState extends State<MyDropdownListWidget> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.options.first,
      onChanged: (newValue) {
        setState(() {
          //_selectedOption = newValue.toString()!;
          widget.controller.text = newValue!.toString();
        });
      },
      items: widget.options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
