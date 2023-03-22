import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({Key? key, required this.btnText, required this.onPressed}) : super(key: key);
  final String btnText;
  final Function()? onPressed;
  final ButtonStyle style = FilledButton.styleFrom(textStyle: const TextStyle(
    fontSize: 20
  ));
  final ButtonStyle styleElevated = ElevatedButton.styleFrom(textStyle: const TextStyle(
      fontSize: 17
  ),elevation: 1);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.0,
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed,style: styleElevated,child: Text(btnText),),
      //child: FilledButton(onPressed: onPressed,style: style,child: Text(btnText),),
    );
  }
}
