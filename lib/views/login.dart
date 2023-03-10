import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/views/register.dart';
import '../components/custom_elevated_button.dart';
import '../components/custom_sized_box.dart';
import '../components/custom_form_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCtr = TextEditingController();
  TextEditingController passCtr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30.0),
        child: Column(
          children: [
            const Image(image: AssetImage('assets/drone.png')),
            CustomSizedBox.large(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomFormField(tec: nameCtr,hint: 'Username'),
                  CustomSizedBox.medium(),
                  CustomFormField(tec: passCtr, hint: 'Password',obscure: true,),
                  CustomSizedBox.large(),
                  CustomElevatedButton(btnText:'Login',onPressed: (){
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState?.save();
                    }
                  },),
                  CustomSizedBox.small(),
                  CustomElevatedButton(btnText: 'Register', onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                  })
                ],
              ),
            )
          ],
        ),
      ),),
    );
  }
}




