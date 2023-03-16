import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/models/mob.dart';
import 'package:mob_monitoring_flutter/views/add_mob.dart';
import 'package:mob_monitoring_flutter/views/register.dart';

import '../networking/mob_network.dart';

class AdminDash extends StatefulWidget {
  AdminDash({Key? key, required this.username}) : super(key: key);
  String username;
  @override
  State<AdminDash> createState() => _AdminDashState();
}

class _AdminDashState extends State<AdminDash> {
  Future<List<Mob>> f = MobNetwork().getAllMobs();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              ExpansionTile(
                title: const Text("Manage Users"),
                leading: const Icon(Icons.account_circle_rounded),
                childrenPadding: const EdgeInsets.all(5.0),
                children: [
                  ListTile(
                    title: const Text("Add User"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                    },
                  )
                ],
              ),
              ExpansionTile(
                title: const Text("Manage Mobs"),
                leading: const Icon(Icons.people_alt_sharp),
                childrenPadding: const EdgeInsets.all(5.0),
                children: [
                  ListTile(
                    title: const Text("Add Mob"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMob()));
                    },
                  )
                ],
              ),
              ExpansionTile(
                title: const Text("Manage Drones"),
                leading: const Icon(Icons.device_hub_rounded),
                childrenPadding: const EdgeInsets.all(5.0),
                children: [
                  ListTile(
                    title: const Text("Add Drone"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text("View Drones"),
                    onTap: () {},
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(widget.username),
        actions: [
          PopupMenuButton<Text>(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text("All Mobs"),
                  onTap: () {
                    setState(() {
                      f = MobNetwork().getAllMobs();
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text("Get All Active Mobs"),
                  onTap: () {
                    setState(() {
                      f = MobNetwork().getActiveMobs();
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text("Get In Active Mobs"),
                  onTap: () {
                    setState(() {
                      f = MobNetwork().getInActiveMobs();
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text("Mobs without Supervisors"),
                  onTap: () {
                    setState(() {
                      f = MobNetwork().getAllUnassignedUserMobs();
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text("Mobs with Supervisors"),
                  onTap: () {
                    setState(() {
                      f = MobNetwork().getAllUserAssignedMobs();
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text("Mobs without Drones"),
                  onTap: () {
                    setState(() {
                      f = MobNetwork().getAllMobsWithDroneAssigned();
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text("Mobs with Drones"),
                  onTap: () {
                    setState(() {
                      f = MobNetwork().getAllMobsWithoutDroneAssigned();
                    });
                  },
                )
              ];
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 25.0, 8.0, 15.0),
        child: FutureBuilder(
          future: f,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<Mob>? m = snapshot.data;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: m!.length,
                itemBuilder: (BuildContext context, int index) {
                  String dateString = '${m[index].startDate!.day}-${m[index].startDate!.month}-${m[index].startDate!.year}';
                  return Column(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 3,
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 16.0, 5.0, 5.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(m[index].name!),
                                leading: Text(m[index].actualStrength!.toString()),
                                subtitle: Text(
                                    "\nStart Date: $dateString\nActual Strength: ${m[index].actualStrength}"),
                                trailing: const Icon(Icons.people),
                              ),
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(16.0, 16.0,16.0, 0.0),
                                  child: m[index].isActive!
                                      ? const Text(
                                          "Active",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        )
                                      : const Text(
                                          "In Active",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        )),
                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: [
                                  TextButton(
                                    child: const Text("View Detail"),
                                    onPressed: (){},
                                  ),
                                  TextButton(
                                    child: const Text("Edit"),
                                    onPressed: (){},
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 20.0,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      )
                    ],
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
