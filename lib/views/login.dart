import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mob_monitoring_flutter/views/generic.dart';
import 'package:mob_monitoring_flutter/views/register.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/custom_elevated_button.dart';
import '../components/custom_sized_box.dart';
import '../components/custom_form_field.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome!"),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Column(
              children: [
                const SizedBox(
                    height: 200.0,
                    width: 200.0,
                    child: Image(image: AssetImage('assets/drone.png'))),
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
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            try{
                              Response res = await UserNetwork.login(nameCtr.text, passCtr.text);
                              if(res.statusCode == 200 && mounted){
                                var resBody = jsonDecode(res.body);
                                String role = resBody["message"].toString();
                                if (kDebugMode) {
                                  print("User Role: $role");
                                }
                                //TODO: add role wise navigation after creating screens.
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Generic()));
                              }
                            }
                            catch(e){
                              if (kDebugMode) {
                                print(e);
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            }
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
    );
  }
}
