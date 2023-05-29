import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/networking/mob_network.dart';
import 'package:mob_monitoring_flutter/views/mob_demo_navigator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MobList extends StatefulWidget {
  MobList({Key? key, required this.demonstrate}) : super(key: key);
  bool demonstrate = false;
  @override
  State<MobList> createState() => _MobListState();
}

class _MobListState extends State<MobList> {
  bool _isAsync = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Mob'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isAsync,
        child: FutureBuilder(
          future: widget.demonstrate? MobNetwork().getAllMobs():MobNetwork().getMobsWithoutPreDefCoords(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              bool isActive = false;
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, index) {
                  isActive = snapshot.data![index].isActive!;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isAsync = true;
                          });
                        },
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MobDemoNavigator(
                                          id: snapshot.data![index].mobID!,
                                          mobName: snapshot.data![index].name!,
                                          demonstrate: widget.demonstrate,
                                        )));
                          },
                          leading: const Icon(Icons.people_alt),
                          title: Text(snapshot.data![index].name!),
                          subtitle: Text(
                            isActive ? "Active" : "Inactive",
                            style: TextStyle(
                                color: isActive ? Colors.green : Colors.red),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
