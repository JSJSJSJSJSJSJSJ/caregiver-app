import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:caregiver_app/screens/patient/caregiver_profile.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class TopRatedList extends StatefulWidget {
  const TopRatedList({Key? key}) : super(key: key);

  @override
  State<TopRatedList> createState() => _TopRatedListState();
}

class _TopRatedListState extends State<TopRatedList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('caregiver')
            .orderBy('rating', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: min(5, snapshot.data!.docs.length),
            itemBuilder: (context, index) {
              DocumentSnapshot caregiver = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Card(
                  color: Colors.blue[50],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 9,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CaregiverProfile(
                              caregiver: caregiver['name'],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(caregiver['profilePhoto'] ?? ''),
                            backgroundColor: Colors.blue,
                            radius: 25,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                caregiver['name'],
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                caregiver['specialization'],
                                style: GoogleFonts.lato(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Typicons.star_full_outline,
                                    size: 20,
                                    color: Colors.indigo[400],
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    caregiver['rating'].toString(),
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
