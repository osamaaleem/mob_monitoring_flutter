import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Mob'),),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: ,
        ),
      ),
    );
  }
}
