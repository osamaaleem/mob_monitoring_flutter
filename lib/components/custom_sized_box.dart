import 'package:flutter/cupertino.dart';

class CustomSizedBox{
  static Widget large(){
    return const SizedBox(
      height: 25,
    );
  }
  static Widget medium(){
    return const SizedBox(
      height: 15,
    );
  }
  static Widget small(){
    return const SizedBox(
      height: 10,
    );
  }
}
