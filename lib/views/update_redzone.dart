import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/redzone_dialogue.dart';
import 'package:mob_monitoring_flutter/models/redzone.dart';
import 'package:mob_monitoring_flutter/models/redzone_coordinates.dart';
import 'package:mob_monitoring_flutter/networking/redzone_network.dart';
import 'package:mob_monitoring_flutter/views/redzone_map_update.dart';
import 'package:mob_monitoring_flutter/views/redzone_selector.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/custom_form_field.dart';
import '../components/custom_sized_box.dart';

class UpdateRedzone extends StatefulWidget {
  UpdateRedzone({Key? key, required this.r}) : super(key: key);
  Redzone r;
  @override
  State<UpdateRedzone> createState() => _UpdateRedzoneState();
}

class _UpdateRedzoneState extends State<UpdateRedzone> {
  List<RedZoneCoordinates> redZoneCoordinates = [];
  Future<bool> _getRedzoneCoordinates() async {
    redZoneCoordinates = await RedzoneNetwork().getRedzoneCoordsById(widget.r.id!);
    if(redZoneCoordinates.isNotEmpty){
      return true;
    }
    return false;
  }
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  TextEditingController name = TextEditingController();
  bool isActive = false;
  bool addCoords = false;
  int? id;
  bool _coordinatesAvailable = false;
  @override
  void initState() {
    super.initState();
    name.text = widget.r.name;
    isActive = widget.r.isActive;
    id = widget.r.id;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Redzone"),
      ),
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
                        child: Image(image: AssetImage('assets/redzone.png'))),
                    CustomSizedBox.large(),
                    CustomSizedBox.large(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFormField(
                          tec: name,
                          hint: 'Redzone Title',
                          keyboardType: TextInputType.text,
                        ),
                        CustomSizedBox.medium(),
                        SwitchListTile(
                            title: const Text('Is Active'),
                            value: isActive,
                            onChanged: (value) {
                              setState(() {
                                isActive = value;
                              });
                            }),
                        CustomSizedBox.medium(),
                        ElevatedButton(
                          child: const Text('Update'),
                          onPressed: _updateButtonPressed ,
                        ),
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
  void _updateButtonPressed() async {
    setState(() {
      showSpinner = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        Redzone rz = Redzone.createObj(
            name: name.text, isActive: isActive);
        if(kDebugMode){
          print(rz.toJson());
        }
        bool added =
        await RedzoneNetwork().updateRedzone(rz);
        if(added){
          try{
            id = await RedzoneNetwork().getRedzoneIdByName(name.text);
            if(id != null){
              _coordinatesAvailable = await _getRedzoneCoordinates();
            }
          }
          catch(e){
            if(kDebugMode){
              print(e);
            }
          }
          catch(e){
            if(kDebugMode){
              print(e);
            }
          }
        }
        setState(() {
          showSpinner = false;
        });
        if (added && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Redzone Updated Successfully')));

          addCoords = (await showDialog<bool>(
              context: context,
              builder: (context) =>
              const RedzoneDialogue()))!;
          if (addCoords && context.mounted && id != null && _coordinatesAvailable) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RedzoneUpdateMap(redZoneId: id!,redZoneCoordinates: redZoneCoordinates,))

            );
          }
          else if(addCoords && context.mounted && id != null && !_coordinatesAvailable) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RedZoneSelectorMap(
                          redZoneId: id!,))
            );
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                    Text('Error Getting Redzone Id')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                  Text('Error Updating Redzone')));
        }
      } catch (e) {
        if(kDebugMode){
          print(e);
        }
        setState(() {
          showSpinner = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('An Error Occurred')));
      }
    }
  }
}
