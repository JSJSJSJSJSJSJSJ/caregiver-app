import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:caregiver_app/screens/chat/chats.dart';
import 'package:caregiver_app/screens/my_profile.dart';
import 'package:caregiver_app/screens/patient/appointments.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class MainPageCaregiver extends StatefulWidget {
  const MainPageCaregiver({Key? key}) : super(key: key);

  @override
  State<MainPageCaregiver> createState() => _MainPageCaregiverState();
}

class _MainPageCaregiverState extends State<MainPageCaregiver> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2;
  final List<Widget> _pages = [
    const Chats(),
    const Appointments(),
    const MyProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: GNav(
                curve: Curves.easeOutExpo,
                rippleColor: Colors.grey.shade300,
                hoverColor: Colors.grey.shade100,
                haptic: true,
                tabBorderRadius: 20,
                gap: 5,
                activeColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 200),
                tabBackgroundColor: Colors.blue.withOpacity(0.7),
                textStyle: GoogleFonts.lato(
                  color: Colors.white,
                ),
                iconSize: 30,
                tabs: const [
                  GButton(
                    icon: Icons.chat_outlined /* Typicons.group_outline */,
                    text: '聊天',
                  ),
                  GButton(
                    icon: Typicons.calendar,
                    text: '所有预约',
                  ),
                  GButton(
                    icon: Typicons.user,
                    text: '个人',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
