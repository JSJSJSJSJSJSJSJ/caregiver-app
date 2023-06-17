import 'package:caregiver_app/screens/welcome/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:caregiver_app/screens/caregiver/main_page_caregiver.dart';
import 'package:caregiver_app/screens/caregiver_or_patient.dart';
import 'package:caregiver_app/screens/firebase_auth.dart';
import 'package:caregiver_app/screens/my_profile.dart';
import 'package:caregiver_app/screens/patient/appointments.dart';
import 'package:caregiver_app/screens/patient/caregiver_profile.dart';
import 'package:caregiver_app/screens/patient/main_page_patient.dart';

import 'firebase_options.dart';
import 'globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    _getUser();
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => user == null
            ? SplashScreen()
            : const CaregiverOrPatient(),
        '/login': (context) => const FireBaseAuth(),
        '/home': (context) =>
            isCaregiver ? const MainPageCaregiver() : const MainPagePatient(),
        '/profile': (context) => const MyProfile(),
        '/MyAppointments': (context) => const Appointments(),
        '/CaregiverProfile': (context) => CaregiverProfile(),
      },
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      // home: MainPageCaregiver(),
      // home: ChatRoom(
      //   userId: '1234',
      // ),
    );
  }
}
