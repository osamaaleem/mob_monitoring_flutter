import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/models/redzone.dart';
import 'package:mob_monitoring_flutter/networking/drone_network.dart';
import 'package:mob_monitoring_flutter/networking/redzone_network.dart';
import 'package:mob_monitoring_flutter/networking/user_network.dart';
import 'package:mob_monitoring_flutter/views/update_redzone.dart';
import 'package:mob_monitoring_flutter/views/update_user.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../models/drone.dart';
import '../models/user.dart';

class ViewRedzones extends StatefulWidget {
  ViewRedzones({Key? key}) : super(key: key);

  @override
  State<ViewRedzones> createState() => _ViewRedzonesState();
}

class _ViewRedzonesState extends State<ViewRedzones> {
  final SnackBar snackBar = const SnackBar(content: Text('Redzone Deleted'));
  final SnackBar errSnackBar = const SnackBar(content: Text('Error Deleting Redzone'));
  bool _isAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Redzones'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isAsyncCall,
        child: FutureBuilder(
          future:
          RedzoneNetwork().getAllZones().timeout(const Duration(seconds: 5)),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<Redzone> l = snapshot.data!;
              return ListView.builder(
                  itemCount: l.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(l[index].name),
                          subtitle: Text(l[index].isActive? 'Active' : 'Inactive',style: TextStyle(color: l[index].isActive? Colors.green:Colors.red),),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const Text('Edit'),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateRedzone(r: l[index])));
                                },
                              ),
                              PopupMenuItem(
                                child: const Text('Delete'),
                                onTap: () async {
                                  setState(() {
                                    _isAsyncCall = true;
                                  });
                                  var response =
                                  await RedzoneNetwork().deleteRedzone(l[index].id!);
                                  if (response) {
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
