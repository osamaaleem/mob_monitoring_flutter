import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/networking/management_network.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/custom_sized_box.dart';
import '../models/mob.dart';
import '../networking/mob_network.dart';
import '../networking/redzone_network.dart';
import '../models/redzone.dart';

class AllocateRedzoneMob extends StatefulWidget {
  const AllocateRedzoneMob({Key? key}) : super(key: key);

  @override
  State<AllocateRedzoneMob> createState() => _AllocateRedzoneMobState();
}

class _AllocateRedzoneMobState extends State<AllocateRedzoneMob> {
  List<Redzone> redzones = [];
  List<Mob> mobs = [];
  Redzone? selectedRedzone;
  Mob? selectedMob;
  final _formKey = GlobalKey<FormState>();
  bool isAsyncCall = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    redzones = await RedzoneNetwork().getUnallocatedRedzones();
    mobs = await MobNetwork().getActiveMobs();
    setState(() {
      selectedRedzone = redzones.isNotEmpty ? redzones[0] : null;
      selectedMob = mobs.isNotEmpty ? mobs[0] : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Allocate redzone to Mob")),
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
                DropdownButtonFormField<Redzone>(
                  menuMaxHeight: 400,
                  decoration: const InputDecoration(
                    labelText: 'Select redzone',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedRedzone,
                  onChanged: (Redzone? newValue) {
                    setState(() {
                      selectedRedzone = newValue;
                    });
                  },
                  items: redzones.isNotEmpty
                      ? redzones.map((Redzone redzone) {
                    return DropdownMenuItem<Redzone>(
                      value: redzone,
                      child: Text(redzone.name),
                    );
                  }).toList()
                      : [
                    const DropdownMenuItem<Redzone>(
                      value: null,
                      child: Text('No redzones available'),
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
                      var res = await ManagementNetwork.allocateMobToredzone(
                          selectedMob!.mobID!, selectedRedzone!.id!);
                      setState(() {
                        isAsyncCall = false;
                      });
                      if (res && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text('redzone allocated to mob'),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text('Error allocating redzone to mob'),
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