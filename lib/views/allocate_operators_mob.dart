import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/networking/management_network.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/custom_sized_box.dart';
import '../models/mob.dart';
import '../models/user.dart';
import '../networking/mob_network.dart';
import '../networking/operator_network.dart';
//import '../networking/Operator_network.dart';

class AllocateMobOperator extends StatefulWidget {
  const AllocateMobOperator({super.key});

  @override
  State<AllocateMobOperator> createState() => _AllocateMobOperatorState();
}

class _AllocateMobOperatorState extends State<AllocateMobOperator> {
  List<User> operators = [];
  List<Mob> mobs = [];
  User? selectedOperator;
  Mob? selectedMob;
  final _formKey = GlobalKey<FormState>();
  bool isAsyncCall = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Allocate Operator to Mob")),
      body: ModalProgressHUD(
          inAsyncCall: isAsyncCall,
          child: FutureBuilder(
            future: getData(),
            builder: (ctx,snapshot){
              if(!snapshot.hasData){
                return const Center(child: CircularProgressIndicator());
              }
              else if(snapshot.hasError){
                return Center(
                  child: Text(
                    'API Unreachable',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }
              else{
                return Form(
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
                                  child: Image(image: AssetImage('assets/level.png'))),
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
                          const SizedBox(height: 20.0,),
                          DropdownButtonFormField<User>(
                            menuMaxHeight: 400,
                            decoration: const InputDecoration(
                              labelText: 'Select Operator',
                              border: OutlineInputBorder(),
                            ),
                            value: selectedOperator,
                            onChanged: (User? newValue) {
                              setState(() {
                                selectedOperator = newValue;
                              });
                            },
                            items: operators.map((User user) {
                              return DropdownMenuItem<User>(
                                value: user,
                                child: Text(user.name),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20.0,),
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
                            items: mobs.map((Mob mob) {
                              return DropdownMenuItem<Mob>(
                                value: mob,
                                child: Text(mob.name!),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20.0,),
                          ElevatedButton(
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                                setState(() {
                                  isAsyncCall = true;
                                });
                                var res = await ManagementNetwork.allocateMobToOperator(selectedMob!.mobID!, selectedOperator!.id!);
                                //await MobNetwork().allocateMobOperator(selectedMob!.id, selectedOperator!.id);
                                setState(() {
                                  isAsyncCall = false;
                                });
                                if(res && mounted){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text('Operator allocated to mob'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text('Error allocating Operator to mob'),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text('Allocate'),
                          ),
                        ],
                      ),
                    )
                );
              }
            },
          )
      ),
    );
  }
  Future<bool> getData() async {
    operators = await OperatorNetwork.GetOperatorsWithoutMobs();
    mobs = await MobNetwork().getMobsWithoutOperators();
    selectedOperator = operators[0];
    selectedMob = mobs[0];
    return true;
  }
}
