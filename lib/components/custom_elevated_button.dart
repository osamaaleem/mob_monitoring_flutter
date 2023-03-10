import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({Key? key, required this.btnText, required this.onPressed}) : super(key: key);
  final String btnText;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.0,
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed,child: Text(btnText)),
    );
  }
}
