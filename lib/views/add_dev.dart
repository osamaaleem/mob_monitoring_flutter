import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/custom_elevated_button.dart';
import 'package:mob_monitoring_flutter/components/custom_form_field.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/models/drone.dart';
import 'package:mob_monitoring_flutter/networking/drone_network.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/custom_drop_down.dart';



class AddDrone extends StatefulWidget {
  const AddDrone({Key? key}) : super(key: key);

  @override
  State<AddDrone> createState() => _AddDroneState();
}

class _AddDroneState extends State<AddDrone> {
  TextEditingController name = TextEditingController();
  TextEditingController isAvailable = TextEditingController();
  TextEditingController battery = TextEditingController();
  TextEditingController isCharged = TextEditingController();
  TextEditingController bufferSize = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register User"),),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomSizedBox.large(),
                    CustomSizedBox.small(),
                    const SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Image(image: AssetImage('assets/drone.png'))),
                    CustomSizedBox.large(),
                    CustomSizedBox.large(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFormField(tec: name, hint: 'Name',keyboardType: TextInputType.text,),
                        CustomSizedBox.medium(),
                        CustomFormField(tec: battery, hint: 'Battery',keyboardType: TextInputType.text,),
                        CustomSizedBox.medium(),
                        CustomFormField(tec: bufferSize, hint: 'Buffer Size',keyboardType: TextInputType.text,helperText: 'Size must be in MBs',),
                        CustomSizedBox.medium(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: MyDropdownListWidget(options: const ['Available','Not Available'], controller: isAvailable),
                        ),
                        CustomSizedBox.medium(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: MyDropdownListWidget(options: const ['Charged','Not Charged'], controller: isCharged),
                        ),
                        CustomSizedBox.large(),
                        CustomElevatedButton(btnText: 'Add', onPressed:  () async {
                          setState(() {
                            showSpinner = true;
                          });
                          if(_formKey.currentState!.validate()){
                            _formKey.currentState!.save();
                            Drone drone = Drone(name: name.text, isAvailable: isAvailable.text == 'Available'?true:false, battery:double.parse(battery.text), isCharged: isCharged.text == 'Charged'?true:false, bufferSize: int.parse(bufferSize.text));
                            List<TextEditingController> controllers = [name,isAvailable,battery,isCharged,bufferSize];
                            for(TextEditingController t in controllers){
                              t.clear();
                            }
                            //Response res = await UserNetwork.registerUser(user);
                            try{
                              bool res = await DroneNetwork().addDrone(drone);
                              if(res && mounted){
                                setState(() {
                                  showSpinner = false;
                                });
                                Navigator.pop(context);
                              }
                            }
                            catch(e){
                              setState(() {
                                showSpinner = false;
                              });
                              if (kDebugMode) {
                                print(e);
                              }
                              setState(() {
                                showSpinner = false;
                              });
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
