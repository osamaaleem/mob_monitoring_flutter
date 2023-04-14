/**import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/custom_elevated_button.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/networking/management_network.dart';
import '../models/management.dart';

import '../components/custom_drop_down_2.dart';
import '../models/mob.dart';

class ManageMob extends StatefulWidget {
  const ManageMob({Key? key}) : super(key: key);

  @override
  State<ManageMob> createState() => _ManageMobState();
}

class _ManageMobState extends State<ManageMob> {
  TextEditingController mob = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController drone = TextEditingController();
  TextEditingController operator = TextEditingController();
  TextEditingController zone = TextEditingController();
  late String
      _selectedUser,
      _selectedDrone,
      _selectedOperator,
      _selectedZone;
  late Mob _selectedMob;
  final _frmKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Mob'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: ManagementNetwork().getManagementData(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              Management m = snapshot.data!;
              List<String?> mNames = m.mobs.map((e) => e.name).toList();
              _selectedMob = m.mobs[0];
              _selectedUser = m.users[0];
              _selectedDrone = m.drones[0];
              _selectedOperator = m.operators[0];
              _selectedZone = m.redZones[9];
              return Form(
                key: _frmKey,
                child: Column(
                  children: [
                    CustomDropdownButton2(
                      hint: 'Select Mob',
                      value: _selectedMob.name,
                      dropdownItems: m.mobs,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedMob = newValue!;
                          mob.text = newValue;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      buttonWidth: double.infinity,
                      buttonHeight: 63.0,
                      iconSize: 35,
                    ),
                    CustomSizedBox.medium(),
                    CustomDropdownButton2(
                      hint: 'Select User',
                      value: _selectedUser,
                      dropdownItems: m.users,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedUser = newValue!;
                          user.text = newValue;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      buttonWidth: double.infinity,
                      buttonHeight: 63.0,
                      iconSize: 35,
                    ),
                    CustomSizedBox.medium(),
                    CustomDropdownButton2(
                      hint: 'Select Drone',
                      value: _selectedDrone,
                      dropdownItems: m.drones,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDrone = newValue!;
                          drone.text = newValue;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      buttonWidth: double.infinity,
                      buttonHeight: 63.0,
                      iconSize: 35,
                    ),
                    CustomSizedBox.medium(),
                    CustomDropdownButton2(
                      hint: 'Select Drone Operator',
                      value: _selectedOperator,
                      dropdownItems: m.operators,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedOperator = newValue!;
                          operator.text = newValue;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      buttonWidth: double.infinity,
                      buttonHeight: 63.0,
                      iconSize: 35,
                    ),
                    CustomSizedBox.medium(),
                    CustomDropdownButton2(
                      hint: 'Select Red Zone',
                      value: _selectedZone,
                      dropdownItems: m.redZones,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedZone = newValue!;
                          zone.text = newValue;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                      buttonWidth: double.infinity,
                      buttonHeight: 63.0,
                      iconSize: 35,
                    ),
                    CustomSizedBox.large(),
                    CustomElevatedButton(btnText: 'Submit', onPressed: () {})
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'API Unreachable',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
**/