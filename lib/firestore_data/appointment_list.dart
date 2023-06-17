import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:caregiver_app/globals.dart';
import 'package:intl/intl.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  late String _documentID;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  // delete appointment from both patient and caregiver
  Future<void> deleteAppointment(
      String docID, String caregiverId, String patientId) async {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(caregiverId)
        .collection('pending')
        .doc(docID)
        .delete();
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(patientId)
        .collection('pending')
        .doc(docID)
        .delete();
  }

  String _dateFormatter(String timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(timestamp));
    return formattedDate;
  }

  String _timeFormatter(String timestamp) {
    String formattedTime =
        DateFormat('kk:mm').format(DateTime.parse(timestamp));
    return formattedTime;
  }

  // alert box for confirmation of deleting appointment
  showAlertDialog(BuildContext context, String caregiverId, String patientId) {
    // No
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // YES
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        deleteAppointment(_documentID, caregiverId, patientId);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("确认删除"),
      content: const Text("您确定要删除这次护理预约吗?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // helping in removing pending appointment
  _checkDiff(DateTime date) {
    print(date);
    var diff = DateTime.now().difference(date).inSeconds;
    print('date difference : $diff');
    if (diff > 0) {
      return true;
    } else {
      return false;
    }
  }

  // for comparing date
  _compareDate(String date) {
    if (_dateFormatter(DateTime.now().toString())
            .compareTo(_dateFormatter(date)) ==
        0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .doc(user.uid)
            .collection('pending')
            .orderBy('date')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data!.size == 0
              ? Center(
                  child: Text(
                    '当前没有护理预约',
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];

                    // delete past appointments from pending appointment list
                    if (_checkDiff(document['date'].toDate())) {
                      deleteAppointment(document.id, document['caregiverId'],
                          document['patientId']);
                    }

                    // each appointment
                    return Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: () {},
                        child: ExpansionTile(
                          initiallyExpanded: true,

                          // main info of appointment
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // caregiver name
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  isCaregiver
                                      ? document['patientName']
                                      : document['caregiverName'],
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // Today label
                              Text(
                                _compareDate(
                                        document['date'].toDate().toString())
                                    ? "今天"
                                    : "",
                                style: GoogleFonts.lato(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(
                                width: 0,
                              ),
                            ],
                          ),

                          // appointment date
                          subtitle: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              _dateFormatter(
                                  document['date'].toDate().toString()),
                              style: GoogleFonts.lato(),
                            ),
                          ),

                          // patient info
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20, right: 10, left: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // patient info
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // patient name
                                      Text(
                                        isCaregiver
                                            ? ''
                                            : "病人姓名: ${document['patientName']}",
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      // Appointment time
                                      Text(
                                        '时间: ${_timeFormatter(document['date'].toDate().toString())}',
                                        style: GoogleFonts.lato(fontSize: 16),
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),

                                      Text(
                                        '需求描述 : ${document['description']}',
                                        style: GoogleFonts.lato(fontSize: 16),
                                      )
                                    ],
                                  ),

                                  // delete button
                                  IconButton(
                                    tooltip: '删除',
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _documentID = document.id;
                                      showAlertDialog(
                                          context,
                                          document['caregiverId'],
                                          document['patientId']);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
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
