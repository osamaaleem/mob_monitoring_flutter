import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;

  const DatePickerFormField({super.key, required this.labelText, required this.controller});

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: widget.controller,
      onTap: () {
        _selectDate(context);
      },
      decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
              onPressed: () {
                _selectDate(context);
              },
              icon: Icon(Icons.calendar_today))),
    );
  }
}
