import 'dart:io';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mob_monitoring_flutter/components/custom_themes.dart';
import 'package:mob_monitoring_flutter/views/welcome_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Mob Monitoring',
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorSchemeTeal
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorSchemeTeal,
      ),
      home:const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/drone.png'),
      title: const Text(
        "Mob Monitoring",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      showLoader: true,
      loadingText: const Text("Loading..."),
      navigator:const Welcome(),
      durationInSeconds: 5,
    );
  }
}

