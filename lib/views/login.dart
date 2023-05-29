import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mob_monitoring_flutter/views/admin_dash.dart';
import 'package:mob_monitoring_flutter/views/standard_dash.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/custom_elevated_button.dart';
import '../components/custom_sized_box.dart';
import '../components/custom_form_field.dart';
import '../models/user.dart';
import '../networking/user_network.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCtr = TextEditingController();
  TextEditingController passCtr = TextEditingController();
  bool showSpinner = false;
  static const snackBar = SnackBar(
    content: Text("Authentication Failed! Please Try Again"),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text("Welcome!"),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomSizedBox.large(),
                  CustomSizedBox.medium(),
                  // SizedBox(
                  //   width: 350,
                  //   child: DefaultTextStyle(style: const TextStyle(fontSize: 25.0,fontFamily: 'Agne',color: Colors.black),
                  //     child: AnimatedTextKit(
                  //       animatedTexts: [
                  //         TypewriterAnimatedText('Mob Monitoring System'),
                  //         //TypewriterAnimatedText('Monitoring'),
                  //         //TypewriterAnimatedText('System')
                  //       ],
                  //     ),),
                  //
                  // ),
                  // CustomSizedBox.large(),
                  // CustomSizedBox.medium(),
                  const SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: Image(image: AssetImage('assets/user.png'))),

                  CustomSizedBox.large(),
                  CustomSizedBox.large(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomFormField(
                          tec: nameCtr,
                          hint: 'Username',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        CustomSizedBox.medium(),
                        CustomFormField(
                          tec: passCtr,
                          hint: 'Password',
                          obscure: true,
                          keyboardType: TextInputType.text,
                        ),
                        CustomSizedBox.large(),
                        CustomElevatedButton(
                          btnText: 'Login',
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              try {
                                Response res = await UserNetwork.login(
                                    nameCtr.text, passCtr.text);
                                if (res.statusCode == 200 && mounted) {
                                  var resBody = jsonDecode(res.body);
                                  //String role = resBody["message"].toString();
                                  User u = User.fromJson(resBody);
                                  if (kDebugMode) {
                                    print("User Role: ${u.role}");
                                  }
                                  String name = nameCtr.text;
                                  nameCtr.clear();
                                  passCtr.clear();
                                  if(u.role == 'Standard'){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StandardDash(u: u)));
                                  }
                                  else{
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AdminDash(u: u,),settings: const RouteSettings(name: '/AdminDash')));
                                  }

                                } else {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              } catch (e) {
                                if (kDebugMode) {
                                  print(e);
                                }
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
