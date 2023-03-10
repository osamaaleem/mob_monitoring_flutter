import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/custom_elevated_button.dart';
import 'package:mob_monitoring_flutter/components/custom_form_field.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/models/user.dart';
import 'package:mob_monitoring_flutter/networking/user_network.dart';



class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController org = TextEditingController();
  TextEditingController role = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up"),),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomFormField(tec: name, hint: 'Username'),
                CustomSizedBox.medium(),
                CustomFormField(tec: email, hint: 'Email'),
                CustomSizedBox.medium(),
                CustomFormField(tec: org, hint: 'Organization'),
                CustomSizedBox.medium(),
                CustomFormField(tec: role, hint: 'Role'),
                CustomSizedBox.medium(),
                CustomFormField(tec: pass, hint: 'Password',helperText: 'Password must contain special & numeric characters',),
                CustomSizedBox.large(),
                CustomElevatedButton(btnText: 'Register', onPressed: (){
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    User user = User.all(name: name.text, email: email.text, password: pass.text, organization: org.text, role: role.text);
                    UserNetwork.registerUser(user);
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
