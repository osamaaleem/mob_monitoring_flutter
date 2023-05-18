import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/custom_form_field.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/components/custom_elevated_button.dart';
import 'package:mob_monitoring_flutter/models/ip_address.dart';
import 'package:mob_monitoring_flutter/views/login.dart';
import 'package:mob_monitoring_flutter/views/redzone_selector.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _frmState = GlobalKey<FormState>();
  TextEditingController ipCtr = TextEditingController();
  bool _showSpinner = false;
  final snackBar = const SnackBar(content: Text("Connection Not Available"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter IP"),
        elevation: 3,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
            child: Form(
              key: _frmState,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomFormField(
                    tec: ipCtr,
                    hint: "Enter IP Address",
                    keyboardType: TextInputType.number,
                  ),
                  CustomSizedBox.large(),
                  CustomSizedBox.small(),
                  CustomElevatedButton(
                    btnText: "Enter",
                    onPressed: () {
                      setState(() {
                        _showSpinner = true;
                      });
                      if (_frmState.currentState!.validate()) {
                        _frmState.currentState!.save();
                        IPAddress.setIP(ipCtr.text);
                        Socket.connect(IPAddress.getIP(), 443,
                                timeout: const Duration(seconds: 5))
                            .then((socket) {
                          if (kDebugMode) {
                            print("Success");
                          }
                          setState(() {
                            _showSpinner = false;
                          });
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                              settings: const RouteSettings(name: '/login'),
                            ),
                          );
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => RedZoneSelectorMap(redZoneId: 6)));
                          socket.destroy();
                        }).catchError((error) {
                          if (kDebugMode) {
                            print("Exception on Socket $error");
                            setState(() {
                              _showSpinner = false;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                      }
                    },
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
