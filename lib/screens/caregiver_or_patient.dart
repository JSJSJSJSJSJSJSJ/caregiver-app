import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:caregiver_app/globals.dart';
import 'package:caregiver_app/screens/caregiver/main_page_caregiver.dart';
import 'package:caregiver_app/screens/patient/main_page_patient.dart';

class CaregiverOrPatient extends StatefulWidget {
  const CaregiverOrPatient({Key? key}) : super(key: key);

  @override
  State<CaregiverOrPatient> createState() => _CaregiverOrPatientState();
}

class _CaregiverOrPatientState extends State<CaregiverOrPatient> {
  bool _isLoading = true;
  void _setUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    var basicInfo = snap.data() as Map<String, dynamic>;

    isCaregiver = basicInfo['type'] == 'caregiver' ? true : false;
    print('isCaregiver : $isCaregiver');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _setUser();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : isCaregiver
            ? const MainPageCaregiver()
            : const MainPagePatient();
  }
}
