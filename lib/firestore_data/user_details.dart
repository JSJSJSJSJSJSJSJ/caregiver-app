import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:caregiver_app/globals.dart';
import 'package:caregiver_app/model/update_user_details.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;

  // 用户信息集合
  Map<String, dynamic> details = {};

  List<String> keyOrder = [
    'name',
    'bio',
    'email',
    'address',
    'phone',
    'birthDate',
  ];

  Future<void> _getUser() async {
    user = _auth.currentUser!;

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection(isCaregiver ? 'caregiver' : 'patient')
        .doc(user.uid)
        .get();

    // setState(() {
    //   details = snap.data() as Map<String, dynamic>;
    //   details = Map.fromEntries(details.entries.toList()..sort((a, b) => keyOrder.indexOf(a.key).compareTo(keyOrder.indexOf(b.key))));
    // });
    // // 输出拿到的user信息
    // print(snap.data());

    Map<String, dynamic> newDetails = snap.data() as Map<String, dynamic>;

    // setState(() {
    //   details = Map.fromEntries(details.entries.toList()..sort((a, b) => keyOrder.indexOf(a.key).compareTo(keyOrder.indexOf(b.key))));
    //   details.addAll(newDetails);
    // });
    setState(() {
      details = Map.fromEntries(newDetails.entries.where((entry) => keyOrder.contains(entry.key)).toList());
      details = Map.fromEntries(details.entries.toList()..sort((a, b) => keyOrder.indexOf(a.key).compareTo(keyOrder.indexOf(b.key))));
    });

    // 输出完整的用户信息
    print(details);
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        controller: ScrollController(),
        shrinkWrap: true,
        itemCount: details.length,
        itemBuilder: (context, index) {
          String key = details.keys.elementAt(index);
          String value = details[key] == null ? 'Not Added' : details[key].toString();
          String label = key[0].toUpperCase() + key.substring(1);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: InkWell(
              splashColor: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateUserDetails(
                      label: label,
                      field: key,
                      value: value,
                    ),
                  ),
                ).then((value) {
                  // 重新获取用户数据
                  _getUser();
                  setState(() {});
                });
              },
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  height: MediaQuery.of(context).size.height / 14,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        value.substring(0, min(20, value.length)),
                        style: GoogleFonts.lato(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
