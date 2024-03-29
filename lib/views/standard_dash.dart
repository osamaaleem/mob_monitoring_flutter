import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mob_monitoring_flutter/components/map_display_container.dart';
import 'package:mob_monitoring_flutter/models/mob.dart';
import 'package:mob_monitoring_flutter/views/google_map_screen.dart';

import '../components/Standard_dash_drawer.dart';
import '../components/custom_sized_box.dart';
import '../models/user.dart';
import '../networking/mob_network.dart';

class StandardDash extends StatefulWidget {
  StandardDash({Key? key, required this.u})
      : super(key: key);
  User u;
  @override
  State<StandardDash> createState() => _StandardDashState();
}

class _StandardDashState extends State<StandardDash> {
  //Future<List<Mob>> f = MobNetwork().getMobByOfficerId(widget.u.id!);
  bool showOnMap = false;
  String appBarTitle = "Allotted Mobs";
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: StandardDashDrawer(
            username: widget.u.name,
            email: widget.u.email,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(appBarTitle),
        // actions: [
        //   PopupMenuButton<Text>(
        //     itemBuilder: (context) {
        //       return [
        //         PopupMenuItem(
        //           child: const Text("View On Map"),
        //           onTap: () {
        //             setState(() {
        //               appBarTitle = "Active Mobs on Map";
        //               showOnMap = true;
        //             });
        //           },
        //         ),
        //         PopupMenuItem(
        //           child: const Text("Show All Mobs"),
        //           onTap: () {
        //             setState(() {
        //               showOnMap = false;
        //               appBarTitle = "All Mobs";
        //               f = MobNetwork().getAllMobs();
        //             });
        //           },
        //         ),
        //         PopupMenuItem(
        //           child: const Text("Show All Active Mobs"),
        //           onTap: () {
        //             setState(() {
        //               showOnMap = false;
        //               appBarTitle = "Active Mobs";
        //               f = MobNetwork().getActiveMobs();
        //             });
        //           },
        //         ),
        //         PopupMenuItem(
        //           child: const Text("Show Inactive Mobs"),
        //           onTap: () {
        //             setState(() {
        //               showOnMap = false;
        //               appBarTitle = "Inactive Mobs";
        //               f = MobNetwork().getInActiveMobs();
        //             });
        //           },
        //         ),
        //         PopupMenuItem(
        //           child: const Text("Show Mobs without Supervisors"),
        //           onTap: () {
        //             setState(() {
        //               showOnMap = false;
        //               appBarTitle = "Mobs without Supervisors";
        //               f = MobNetwork().getAllUnassignedUserMobs();
        //             });
        //           },
        //         ),
        //         PopupMenuItem(
        //           child: const Text("Show Mobs with Supervisors"),
        //           onTap: () {
        //             setState(() {
        //               showOnMap = false;
        //               appBarTitle = "Mobs with Supervisors";
        //               f = MobNetwork().getAllUserAssignedMobs();
        //             });
        //           },
        //         ),
        //         PopupMenuItem(
        //           child: const Text("Show Mobs without Drones"),
        //           onTap: () {
        //             setState(() {
        //               showOnMap = false;
        //               appBarTitle = "Mobs without Drones";
        //               f = MobNetwork().getAllMobsWithDroneAssigned();
        //             });
        //           },
        //         ),
        //         PopupMenuItem(
        //           child: const Text("Show Mobs with Drones"),
        //           onTap: () {
        //             setState(() {
        //               showOnMap = false;
        //               appBarTitle = "Mobs with Drones";
        //               f = MobNetwork().getAllMobsWithoutDroneAssigned();
        //             });
        //           },
        //         )
        //       ];
        //     },
        //   )
        // ],
      ),
      body: StandardView(id: widget.u.id!,),
    );
  }
}

class StandardView extends StatelessWidget {
  const StandardView({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 25.0, 8.0, 15.0),
      child: FutureBuilder(
        future:  MobNetwork().getMobByOfficerId(id).timeout(const Duration(seconds: 5)),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'API Unreachable',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
          if (snapshot.hasData) {
            List<Mob>? m = snapshot.data;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: m!.length,
              itemBuilder: (BuildContext context, int index) {
                String dateString = m[index].startDate!;
                DateTime mobDate = DateTime.parse(dateString);
                return Column(
                  children: [
                    Card(
                      elevation: 1,
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 16.0, 5.0, 5.0),
                        child: Column(
                          children: [
                            // MapContainer(
                            //
                            // ),

                            CustomSizedBox.medium(),
                            ListTile(
                              title: Text(m[index].name!),
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage('assets/crowd.png'),
                              ),
                              subtitle: Text(
                                  "\nStart Date: ${DateFormat.yMd().format(mobDate).toString()}\nActual Strength: ${m[index].actualStrength}"),
                              trailing: const Icon(Icons.people),
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 16.0, 16.0, 0.0),
                                child: m[index].isActive!
                                    ? const Text(
                                  "Active",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                )
                                    : const Text(
                                  "Inactive",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                )),
                            ButtonBar(
                              alignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  child: const Text("View Detail"),
                                  onPressed: () {
                                  },
                                ),
                                TextButton(
                                  child: const Text("Edit"),
                                  onPressed: () {},
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
    );
  }
}
