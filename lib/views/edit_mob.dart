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

class EditMob extends StatefulWidget {
  EditMob({Key? key, required this.m}) : super(key: key);
  Mob m;
  @override
  State<EditMob> createState() => _EditMobState();
}

class _EditMobState extends State<EditMob> {
  TextEditingController mobId = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController sDate = TextEditingController();
  TextEditingController eDate = TextEditingController();
  TextEditingController pStrength = TextEditingController();
  TextEditingController position = TextEditingController();
  TextEditingController endLat = TextEditingController();
  TextEditingController endLon = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobId.text = widget.m.mobID!.toString();
    name.text = widget.m.name!;
    sDate.text = widget.m.startDate!;
    eDate.text = widget.m.endDate!;
    pStrength.text = widget.m.proputedStrength!.toString();
    position.text = "${widget.m.mobStartLat}, ${widget.m.mobStartLon}";
  }
  bool _isActive = true;

  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  //static final route = MaterialPageRoute(builder: (context) => LocationPicker());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Mob"),
      ),
      //resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomSizedBox.large(),
                    const SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Image(image: AssetImage('assets/people.png'))),
                    CustomSizedBox.large(),
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
                        CustomFormField(
                          tec: pStrength,
                          hint: 'Proputed Strength',
                          keyboardType: TextInputType.text,
                        ),
                        CustomSizedBox.medium(),
                        TextFormField(
                          controller: position,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LocationPicker(position: position,
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
                            btnText: 'Confirm',
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                List<String> cords = position.text.split(',');
                                if (kDebugMode) {
                                  print("Making Mob Model");
                                }
                                Mob mob = Mob(
                                  mobID: int.parse(mobId.text),
                                  name: name.text,
                                  startDate: sDate.text,
                                  endDate: eDate.text,
                                  proputedStrength: int.parse(pStrength.text),
                                  actualStrength: 0,
                                  isActive: _isActive,
                                  mobStartLat: double.parse(cords[0]),
                                  mobStartLon: double.parse(cords[1]),

                                );
                                if (kDebugMode) {
                                  print(mob.toJson());
                                }
                                //Response res = await UserNetwork.EditMobUser(user);
                                try {
                                  bool res = await MobNetwork().updateMob(mob);
                                  if (res && mounted) {
                                    setState(() {
                                      showSpinner = false;
                                      List<TextEditingController> controllers = [
                                        name,
                                        sDate,
                                        eDate,
                                        pStrength,
                                        position,
                                        endLon,
                                        endLat
                                      ];
                                      for (TextEditingController t in controllers) {
                                        t.clear();
                                      }
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
