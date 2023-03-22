import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/custom_sized_box.dart';
import 'package:mob_monitoring_flutter/components/full_screen_map.dart';
import 'package:mob_monitoring_flutter/components/map_display_container.dart';
import 'package:mob_monitoring_flutter/components/standard_dash_drawer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StandardUserDash extends StatefulWidget {
  StandardUserDash({Key? key, required this.email, required this.role})
      : super(key: key);
  String email;
  String role;
  @override
  State<StandardUserDash> createState() => _StandardUserDashState();
}

class _StandardUserDashState extends State<StandardUserDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child:
                StandardDashDrawer(email: widget.email, username: widget.role),
          ),
        ),
        appBar: AppBar(
          title: const Text("Mob Monitoring"),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    16, 40, MediaQuery.of(context).size.width * 0.04, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Mob Name.',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Stack(
                        children: [
                          //MapContainer(),
                          Container(
                            decoration: BoxDecoration(
                              color:
                              Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 280,
                            width: 380,
                            child: const Center(
                              child: Text('Assigned Mob Map Display'),
                            ),
                          ),
                          /**Positioned(
                              top: 8,
                              left: 8,
                              child: FilledButton.tonalIcon(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const FullScreenMap()));
                                },
                                icon: const Icon(
                                  Icons.fullscreen_rounded,
                                  size: 30,
                                ),
                                label: const Text('View Full Screen'),
                              )),**/
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 280.0,
                        width: 380.0,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(
                              width: 10.0,
                            ),
                            const Expanded(
                              child: CircleAvatar(
                                radius: 100,
                                backgroundImage: AssetImage('assets/crowd.png'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Mob Name',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer),
                                ),
                                CustomSizedBox.small(),
                                Text(
                                  'Mob Strength',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer),
                                ),
                                CustomSizedBox.small(),
                                Text(
                                  'Start Date',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer),
                                ),
                                CustomSizedBox.small(),
                                Text(
                                  'Drone Operator',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 280.0,
                        width: 380.0,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Drone Name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                    ),
                                    CustomSizedBox.small(),
                                    Text(
                                      'Drone Operator',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 0),
                                  child: CircularPercentIndicator(
                                    header: Text(
                                      'Time Remaining\n',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    //fillColor: Theme.of(context).colorScheme.onSecondaryContainer,
                                    progressColor:
                                        Theme.of(context).colorScheme.secondary,
                                    //backgroundColor: Theme.of(context).colorScheme.secondary,
                                    percent: 0.93,
                                    radius: 50,
                                    lineWidth: 10,
                                    animation: true,
                                    center: Text(
                                      '45 Min\'s',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            CustomSizedBox.large(),
                            Padding(
                              padding: const EdgeInsets.only(left: 5,right: 5),
                              child: LinearPercentIndicator(
                                leading: Icon(
                                  Icons.battery_6_bar_sharp,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                lineHeight: 25,
                                progressColor:
                                    Theme.of(context).colorScheme.secondary,
                                percent: 0.70,
                                animation: true,
                                center: Text('60%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer)),
                              ),
                            ),
                            CustomSizedBox.large(),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: LinearPercentIndicator(
                                leading: Icon(Icons.sd_storage,
                                    color:
                                        Theme.of(context).colorScheme.secondary),
                                lineHeight: 25,
                                progressColor:
                                    Theme.of(context).colorScheme.secondary,
                                percent: 0.70,
                                animation: true,
                                center: Text('50 MB',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
