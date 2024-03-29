import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/networking/drone_network.dart';
import 'package:mob_monitoring_flutter/views/update_drone.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../models/drone.dart';

class ViewDrones extends StatefulWidget {
  const ViewDrones({Key? key}) : super(key: key);

  @override
  State<ViewDrones> createState() => _ViewDronesState();
}

class _ViewDronesState extends State<ViewDrones> {
  final SnackBar snackBar = const SnackBar(content: Text('Drone Deleted'));
  final SnackBar errSnackBar = const SnackBar(content: Text('Error Deleting Drone'));
  bool _isAsyncCall = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Drones'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isAsyncCall,
        child: FutureBuilder(
          future:
              DroneNetwork().fetchDrones().timeout(const Duration(seconds: 60)),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<Drone> l = snapshot.data!;
              return ListView.builder(
                  itemCount: l.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.device_hub),
                          title: Text(l[index].name),
                          subtitle: Text("${l[index].isAvailable? 'Available': 'Not Available'}\n${l[index].isCharged?'Charged':'Not Charged'}"),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const Text('Edit'),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateDrone(d: l[index])));
                                },
                              ),
                              PopupMenuItem(
                                child: const Text('Delete'),
                                onTap: () async {
                                  setState(() {
                                    _isAsyncCall = true;
                                  });
                                  var response =
                                  await DroneNetwork().DeleteDrone(l[index].droneId!);
                                  if (response.statusCode == 200) {
                                    setState(() {
                                      _isAsyncCall = false;
                                    });
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  } else {
                                    setState(() {
                                      _isAsyncCall = false;
                                    });
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(errSnackBar);
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        CustomSizedBox.medium()
                      ],
                    );
                  });
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    Text(snapshot.error.toString()),
                    Text(
                      'API Unreachable',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
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
