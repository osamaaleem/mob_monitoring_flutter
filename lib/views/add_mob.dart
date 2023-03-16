import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/custom_elevated_button.dart';
import 'package:mob_monitoring_flutter/components/custom_form_field.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/components/date_picker.dart';
import 'package:mob_monitoring_flutter/models/mob.dart';
import 'package:mob_monitoring_flutter/networking/mob_network.dart';
import 'package:mob_monitoring_flutter/views/location_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddMob extends StatefulWidget {
  const AddMob({Key? key}) : super(key: key);

  @override
  State<AddMob> createState() => _AddMobState();
}

class _AddMobState extends State<AddMob> {
  TextEditingController name = TextEditingController();
  TextEditingController sDate = TextEditingController();
  TextEditingController eDate = TextEditingController();
  TextEditingController pStrength = TextEditingController();
  TextEditingController startLat = TextEditingController();
  TextEditingController startLon = TextEditingController();
  TextEditingController endLat = TextEditingController();
  TextEditingController endLon = TextEditingController();

  bool _isActive = true;

  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  //static final route = MaterialPageRoute(builder: (context) => LocationPicker());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Mob"),
      ),
      //resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: Column(
                  children: [
                    const SizedBox(
                        height: 150.0,
                        width: 150.0,
                        child: Image(image: AssetImage('assets/user.png'))),
                    CustomSizedBox.large(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFormField(
                          tec: name,
                          hint: 'Mob Title',
                          keyboardType: TextInputType.text,
                        ),
                        CustomSizedBox.medium(),
                        DatePickerFormField(
                          labelText: 'Select Start Date',
                          controller: sDate,
                        ),
                        CustomSizedBox.medium(),
                        DatePickerFormField(
                            labelText: 'Select End Date', controller: eDate),
                        CustomSizedBox.medium(),
                        CustomFormField(
                          tec: pStrength,
                          hint: 'Proputed Strength',
                          keyboardType: TextInputType.text,
                        ),
                        CustomSizedBox.medium(),
                        TextFormField(
                          controller: startLat,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LocationPicker(
                                              latCont: startLat,
                                              lonCont: startLon,
                                            )));
                              },
                              child: const Icon(Icons.location_pin),
                            ),
                            labelText: 'Select Start Location',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        CustomSizedBox.medium(),
                        TextFormField(
                          controller: endLat,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LocationPicker(
                                              latCont: endLat,
                                              lonCont: endLon,
                                            )));
                              },
                              child: const Icon(Icons.location_pin),
                            ),
                            labelText: 'Select Start Location',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        CustomSizedBox.small(),
                        Column(
                          children: <Widget>[
                            ListTile(
                              title: const Text('Active'),
                              leading: Radio<bool>(
                                value: true,
                                groupValue: _isActive,
                                onChanged: (value) {
                                  setState(() {
                                    _isActive = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Inactive'),
                              leading: Radio<bool>(
                                value: false,
                                groupValue: _isActive,
                                onChanged: (value) {
                                  setState(() {
                                    _isActive = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        CustomSizedBox.medium(),
                        CustomElevatedButton(
                            btnText: 'AddMob',
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                Mob mob = Mob(
                                    name: name.text,
                                    startDate: DateTime.parse(sDate.text),
                                    endDate: DateTime.parse(eDate.text),
                                    proputedStrength: int.parse(pStrength.text),
                                    actualStrength: 0,
                                    isActive: _isActive,
                                    mobStartLat: double.parse(startLat.text),
                                    mobStartLon: double.parse(startLon.text),
                                    mobEndLat: double.parse(endLat.text),
                                    mobEndLon: double.parse(endLon.text));
                                List<TextEditingController> controllers = [
                                  name,
                                  sDate,
                                  eDate,
                                  pStrength,
                                  startLon,
                                  startLat,
                                  endLon,
                                  endLat
                                ];
                                for (TextEditingController t in controllers) {
                                  t.clear();
                                }
                                //Response res = await UserNetwork.AddMobUser(user);
                                try {
                                  bool res = await MobNetwork().addMob(mob);
                                  if (res && mounted) {
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
