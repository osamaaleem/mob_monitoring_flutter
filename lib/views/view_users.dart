import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/networking/drone_network.dart';

import '../models/drone.dart';

class ViewDrones extends StatelessWidget {
  const ViewDrones({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Users'),
      ),
      body: FutureBuilder(
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
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {},
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
    );
  }
}
