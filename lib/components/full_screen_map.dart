import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/map_display_container.dart';

class FullScreenMap extends StatelessWidget {
  const FullScreenMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mob Name')),
      body: SafeArea(
        child: Expanded(child: MapContainer(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        )),
      ),
    );
  }
}
