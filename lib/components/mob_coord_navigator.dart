import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mob_monitoring_flutter/networking/coordinate_network.dart';

import '../models/mob_coords.dart';

class MobCoordNavigator {
  int id;
  String mobName;
  bool demonstrate;
  MobCoordNavigator(
      {required this.id, required this.mobName, required this.demonstrate});
  Future<List<MobCoordinates>?> _getPreDefCoords(int mobID) async {
    var mobCoords = await CoordinateNetwork.getPreDefCoords(mobID);
    if (mobCoords.isNotEmpty) {
      return mobCoords;
    } else {
      return Future.value(null);
    }
  }

}
