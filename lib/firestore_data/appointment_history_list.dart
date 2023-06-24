import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:caregiver_app/globals.dart';
import 'package:intl/intl.dart';

class AppointmentHistoryList extends StatefulWidget {
  const AppointmentHistoryList({Key? key}) : super(key: key);

  @override
  State<AppointmentHistoryList> createState() => _AppointmentHistoryListState();
}

class _AppointmentHistoryListState extends State<AppointmentHistoryList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  late String _documentID;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  String _dateFormatter(String timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(timestamp));
    return formattedDate;
  }

  Future<void> deleteAppointment(String docID) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.uid)
        .collection('all')
        .doc(docID)
        .delete();
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void openRatingDialog(String caregiverId, String appointmentId) {
    double rating = 0; // 评分值，可以使用StatefulWidget来管理评分值

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('评价此次护理'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3, // 控制大小，可以根据需要调整比例
            child: Column(
              children: [
                // 添加评分部件
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 0,
                  maxRating: 5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // 构造评分数据
                Map<String, dynamic> ratingData = {
                  'caregiverId': caregiverId,
                  'appointmentId': appointmentId,
                  'rating': rating,
                };
                try {
                  // 写入Firestore的代码
                  await FirebaseFirestore.instance
                      .collection('ratings')
                      .add(ratingData);
                  Navigator.pop(context); // 关闭评价窗口
                } catch (e) {
                  print('评分数据写入Firestore时出现错误：$e');
                }
              },
              child: Text('提交'),
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .doc(user.uid)
              .collection('all')
              .orderBy('date', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data!.size == 0
                ? Text(
                    '在这里查看护理预约历史...',
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blueGrey[50],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 添加评分按钮时使用的布局
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // caregiver name
                              Text(
                                '${index + 1}. ${isCaregiver ? '${document['patientName']}' : '${document['caregiverName']}'}',
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                _dateFormatter(
                                    document['date'].toDate().toString()),
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  document['description'] ?? '未填写')
                            ],
                          ),
                          // 添加评分按钮
                          IconButton(
                            onPressed: () {
                              // 在这里执行评分操作
                              openRatingDialog(document['caregiverId'], document['appointmentID']);
                            },
                            icon: const Icon(Icons.star),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
