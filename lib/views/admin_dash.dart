import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/networking/mob_network.dart';

class AdminDash extends StatefulWidget {
  const AdminDash({Key? key,required this.username}) : super(key: key);
  final String username;
  @override
  State<AdminDash> createState() => _AdminDashState();
}

class _AdminDashState extends State<AdminDash> {
  bool showSpinner = true;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(widget.username),
            const Text("Currently Active Mob"),
            FutureBuilder(
              future: MobNetwork().getActiveMobs(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  var m = snapshot.data;
                  return ListView.builder(
                    itemCount: m?.length,
                    itemBuilder: (BuildContext context, int index){
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.people_alt_outlined),
                          title: Text(m![index].name!),
                          subtitle:
                          Text(m[index].startDate.toString()),
                          trailing: const Icon(Icons.more_vert),
                          isThreeLine: true,
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator(),);
              },
            )
          ],
        ),
      ),
    );
  }
}
