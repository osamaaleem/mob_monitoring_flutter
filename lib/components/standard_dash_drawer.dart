import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/brightness_toggle_button.dart';
import 'package:mob_monitoring_flutter/views/add_dev.dart';

import '../views/add_mob.dart';
import '../views/register.dart';

class StandardDashDrawer extends StatelessWidget {
  const StandardDashDrawer({
    super.key,
    required this.email,
    required this.username
  });

  final String username;
  final String email;
  final snackBar = const SnackBar(content: Text("Logged Out"));
  @override
  Widget build(BuildContext context) {
    return Column(
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
              child: const Icon(Icons.logout,color: Colors.white,),
              onTap: (){
                Navigator.of(context).popUntil((route) => route.settings.name == '/login');
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Register()));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddMob()));
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDrone()));
              },
            ),
            ListTile(
              title: const Text("View Drones"),
              onTap: () {},
            )
          ],
        ),
      ],
    );
  }
}
