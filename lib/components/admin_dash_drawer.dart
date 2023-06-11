import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/views/add_dev.dart';
import 'package:mob_monitoring_flutter/views/add_redzone.dart';
import 'package:mob_monitoring_flutter/views/allocate_officer_mob.dart';
import 'package:mob_monitoring_flutter/views/allocate_operators_mob.dart';
import 'package:mob_monitoring_flutter/views/mob_list.dart';

import 'package:mob_monitoring_flutter/views/view_drones.dart';
import 'package:mob_monitoring_flutter/views/view_redzones.dart';
import 'package:mob_monitoring_flutter/views/view_users.dart';

import '../views/add_mob.dart';
import '../views/register.dart';

class AdminDashDrawer extends StatelessWidget {
  const AdminDashDrawer(
      {super.key, required this.email, required this.username});


  final String username;
  final String email;
  final snackBar = const SnackBar(content: Text("Logged Out"));
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
              ),
            ),
            otherAccountsPictures: [
              GestureDetector(
                child: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(context)
                      .popUntil((route) => route.settings.name == '/login');
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              )
            ],
          ),
          const Divider(
            color: Colors.grey,
            height: 20.0,
            thickness: 1,
          ),
          ExpansionTile(
            title: const Text("Manage Users"),
            leading: const Icon(Icons.account_circle_rounded),
            childrenPadding: const EdgeInsets.all(5.0),
            children: [
              ListTile(
                title: const Text("Add User"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Register()));
                },
              ),
              ListTile(
                title: const Text("View User"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewUsers()));
                },
              ),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddMob()));
                },
              ),
              ListTile(
                title: const Text("Allocate Officer"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AllocateMobOfficer()));
                },
              ),
              ListTile(
                title: const Text("Allocate Operator"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AllocateMobOperator()));
                },
              ),
              ListTile(
                title: const Text("Add Mob"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddMob()));
                },
              ),
              ListTile(
                title: const Text("Define Coordinates"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MobList(demonstrate: false,)));
                },
              ),
              ListTile(
                title: const Text("Demonstrate Mob"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MobList(demonstrate: true,)));
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text("Manage Redzones"),
            leading: const Icon(Icons.crisis_alert_rounded),
            childrenPadding: const EdgeInsets.all(5.0),
            children: [
              ListTile(
                title: const Text("View Redzones"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewRedzones()));
                },
              ),
              ListTile(
                title: const Text("Add Redzone"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddRedzone()));
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
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddDrone()));
                },
              ),
              ListTile(
                title: const Text("Allocate Officer"),
                onTap: () {
                  //TODO: Add allocation screen
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddMob()));
                },
              ),
              ListTile(
                title: const Text("View Drones"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ViewDrones()));
                },
              ),
              ListTile(
                title: const Text("Add Operator"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ViewDrones()));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
