import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/networking/management_network.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/custom_sized_box.dart';
import '../models/mob.dart';
import '../models/user.dart';
import '../networking/mob_network.dart';
import '../networking/officer_network.dart';

class AllocateMobOfficer extends StatefulWidget {
  const AllocateMobOfficer({Key? key}) : super(key: key);

  @override
  State<AllocateMobOfficer> createState() => _AllocateMobOfficerState();
}

class _AllocateMobOfficerState extends State<AllocateMobOfficer> {
  List<User> officers = [];
  List<Mob> mobs = [];
  User? selectedOfficer;
  Mob? selectedMob;
  final _formKey = GlobalKey<FormState>();
  bool isAsyncCall = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    officers = await OfficerNetwork.GetOfficersWithoutMobs();
    mobs = await MobNetwork().getMobsWithoutOfficers();
    setState(() {
      selectedOfficer = officers.isNotEmpty ? officers[0] : null;
      selectedMob = mobs.isNotEmpty ? mobs[0] : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Allocate Officer to Mob")),
      body: ModalProgressHUD(
        inAsyncCall: isAsyncCall,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                CustomSizedBox.large(),
                CustomSizedBox.small(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 80.0,
                        width: 80.0,
                        child: Image(image: AssetImage('assets/policeman.png'))),
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: Image(image: AssetImage('assets/next.png'))),
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                        height: 80.0,
                        width: 80.0,
                        child: Image(image: AssetImage('assets/people.png'))),
                  ],
                ),
                CustomSizedBox.large(),
                const SizedBox(height: 20.0),
                DropdownButtonFormField<User>(
                  menuMaxHeight: 400,
                  decoration: const InputDecoration(
                    labelText: 'Select Officer',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedOfficer,
                  onChanged: (User? newValue) {
                    setState(() {
                      selectedOfficer = newValue;
                    });
                  },
                  items: officers.isNotEmpty
                      ? officers.map((User user) {
                    return DropdownMenuItem<User>(
                      value: user,
                      child: Text(user.name),
                    );
                  }).toList()
                      : [
                    const DropdownMenuItem<User>(
                      value: null,
                      child: Text('No officers available'),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                DropdownButtonFormField<Mob>(
                  menuMaxHeight: 400,
                  decoration: const InputDecoration(
                    labelText: 'Select Mob',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedMob,
                  onChanged: (Mob? newValue) {
                    setState(() {
                      selectedMob = newValue;
                    });
                  },
                  items: mobs.isNotEmpty
                      ? mobs.map((Mob mob) {
                    return DropdownMenuItem<Mob>(
                      value: mob,
                      child: Text(mob.name!),
                    );
                  }).toList()
                      : [
                    const DropdownMenuItem<Mob>(
                      value: null,
                      child: Text('No mobs available'),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isAsyncCall = true;
                      });
                      var res = await ManagementNetwork.allocateMobToOfficer(
                          selectedMob!.mobID!, selectedOfficer!.id!);
                      setState(() {
                        isAsyncCall = false;
                      });
                      if (res && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text('Officer allocated to mob'),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text('Error allocating officer to mob'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Allocate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
