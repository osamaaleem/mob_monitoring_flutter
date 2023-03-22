import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mob_monitoring_flutter/components/custom_elevated_button.dart';
import 'package:mob_monitoring_flutter/components/custom_form_field.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/models/user.dart';
import 'package:mob_monitoring_flutter/networking/user_network.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/custom_drop_down_2.dart';

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
  String _selectedValue = 'Standard';
  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register User"),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomSizedBox.large(),
                    CustomSizedBox.small(),
                    const SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Image(image: AssetImage('assets/user.png'))),
                    CustomSizedBox.large(),
                    CustomSizedBox.large(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFormField(
                          tec: name,
                          hint: 'Username',
                          keyboardType: TextInputType.text,
                        ),
                        CustomSizedBox.medium(),
                        CustomFormField(
                          tec: email,
                          hint: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        CustomSizedBox.medium(),
                        CustomFormField(
                          tec: org,
                          hint: 'Organization',
                          keyboardType: TextInputType.text,
                        ),
                        CustomSizedBox.medium(),
                        CustomFormField(
                          tec: pass,
                          hint: 'Password',
                          helperText:
                              'Password must contain special & numeric characters',
                          keyboardType: TextInputType.text,
                        ),
                        CustomSizedBox.medium(),
                        CustomDropdownButton2(
                          hint: 'Charge Status',
                          value: _selectedValue,
                          dropdownItems: const ['Standard', 'Admin'],
                          onChanged: (newValue) {
                            setState(() {
                              _selectedValue = newValue!;
                              role.text = newValue;
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                          buttonWidth: double.infinity,
                          buttonHeight: 63.0,
                          iconSize: 35,
                        ),
                        CustomSizedBox.large(),
                        CustomElevatedButton(
                            btnText: 'Register',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() {
                                  showSpinner = true;
                                });
                                User user = User.all(
                                    name: name.text,
                                    email: email.text,
                                    password: pass.text,
                                    organization: org.text,
                                    role: role.text);
                                if (kDebugMode) {
                                  print("User Role: ${user.role}");
                                }
                                List<TextEditingController> controllers = [
                                  name,
                                  email,
                                  pass,
                                  org,
                                  role
                                ];
                                for (TextEditingController t in controllers) {
                                  t.clear();
                                }
                                //Response res = await UserNetwork.registerUser(user);
                                try {
                                  Response res =
                                      await UserNetwork.registerUser(user);
                                  if (res.statusCode == 200 && mounted) {
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  if (kDebugMode) {
                                    print(e);
                                  }
                                  showSpinner = false;
                                }
                              }
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
