import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/networking/drone_network.dart';
import 'package:mob_monitoring_flutter/networking/user_network.dart';
import 'package:mob_monitoring_flutter/views/update_user.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../models/drone.dart';
import '../models/user.dart';

class ViewUsers extends StatefulWidget {
  ViewUsers({Key? key}) : super(key: key);

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  final SnackBar snackBar = const SnackBar(content: Text('User Deleted'));
  final SnackBar errSnackBar = const SnackBar(content: Text('Error Deleting User'));
  bool _isAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Users'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isAsyncCall,
        child: FutureBuilder(
          future:
          UserNetwork.getAllUsers().timeout(const Duration(seconds: 5)),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<User> l = snapshot.data!;
              return ListView.builder(
                  itemCount: l.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(l[index].name),
                          subtitle: Text(l[index].role),
                          trailing: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  setState(() {
                                    _isAsyncCall = true;
                                  });
                                  var response = await UserNetwork.DeleteUser(l[index].id!);
                                  if(response.statusCode == 200){
                                    setState(() {
                                      _isAsyncCall = false;
                                    });
                                    if(mounted){
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  }
                                  else{
                                    setState(() {
                                      _isAsyncCall = false;
                                    });
                                   if(mounted){
                                     ScaffoldMessenger.of(context).showSnackBar(errSnackBar);
                                   }
                                  }
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateUser(u: l[index])));
                                },
                                icon: const Icon(Icons.edit),
                              ),
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
