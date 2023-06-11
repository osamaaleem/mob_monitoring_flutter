import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/custom_elevated_button.dart';
import 'package:mob_monitoring_flutter/components/custom_form_field.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/models/drone.dart';
import 'package:mob_monitoring_flutter/networking/drone_network.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mob_monitoring_flutter/components/custom_drop_down_2.dart';

class UpdateDrone extends StatefulWidget {
  UpdateDrone({Key? key, required this.d}) : super(key: key);
  Drone d;
  @override
  State<UpdateDrone> createState() => _UpdateDroneState();
}

class _UpdateDroneState extends State<UpdateDrone> {
  TextEditingController name = TextEditingController();
  TextEditingController isAvailable = TextEditingController();
  TextEditingController battery = TextEditingController();
  TextEditingController isCharged = TextEditingController();
  TextEditingController bufferSize = TextEditingController();

  String _chargeSelection = 'Charged';
  String _availableSelection = 'Available';
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  @override
  void initState() {
    super.initState();
    name.text = widget.d.name;
    isAvailable.text = widget.d.isAvailable? 'Available' : 'Not Available';
    battery.text = widget.d.battery.toString();
    isCharged.text = widget.d.isCharged? 'Charged' : 'Not Charged';
    bufferSize.text = widget.d.bufferSize.toString();
    _chargeSelection = isCharged.text;
    _availableSelection = isAvailable.text;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Drone"),
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
                        child: Image(image: AssetImage('assets/drone.png'))),
                    CustomSizedBox.large(),
                    CustomSizedBox.large(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFormField(
                          tec: name,
                          hint: 'Name',
                          keyboardType: TextInputType.text,
                        ),
                        CustomSizedBox.medium(),
                        CustomFormField(
                          tec: battery,
                          hint: 'Battery',
                          keyboardType: TextInputType.text,
                        ),
                        CustomSizedBox.medium(),
                        CustomFormField(
                          tec: bufferSize,
                          hint: 'Buffer Size',
                          keyboardType: TextInputType.text,
                          helperText: 'Size must be in MBs',
                        ),
                        CustomSizedBox.medium(),
                        CustomDropdownButton2(
                          hint: 'Charge Status',
                          value: _chargeSelection,
                          dropdownItems: const ['Charged', 'Not Charged'],
                          onChanged: (newValue) {
                            setState(() {
                              _chargeSelection = newValue!;
                              isCharged.text = newValue;
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                          buttonWidth: double.infinity,
                          buttonHeight: 63.0,
                          iconSize: 35,
                        ),
                        CustomSizedBox.medium(),
                        CustomDropdownButton2(
                          hint: 'Charge Status',
                          value: _availableSelection,
                          dropdownItems: const ['Available', 'Not Available'],
                          onChanged: (newValue) {
                            setState(() {
                              _availableSelection = newValue!;
                              isAvailable.text = newValue;
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                          buttonWidth: double.infinity,
                          buttonHeight: 63.0,
                          iconSize: 35,
                        ),
                        CustomSizedBox.large(),
                        CustomElevatedButton(
                            btnText: 'Add',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() {
                                  showSpinner = true;
                                });
                                Drone drone = Drone(
                                    name: name.text,
                                    isAvailable: isAvailable.text == 'Available'
                                        ? true
                                        : false,
                                    battery: double.parse(battery.text),
                                    isCharged: isCharged.text == 'Charged'
                                        ? true
                                        : false,
                                    bufferSize: int.parse(bufferSize.text));
                                if (kDebugMode) {
                                  print(drone.toJson());
                                }
                                List<TextEditingController> controllers = [
                                  name,
                                  isAvailable,
                                  battery,
                                  isCharged,
                                  bufferSize
                                ];
                                for (TextEditingController t in controllers) {
                                  t.clear();
                                }
                                //Response res = await UserNetwork.registerUser(user);
                                try {
                                  var res =
                                  await DroneNetwork().UpdateDrone(drone);
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
