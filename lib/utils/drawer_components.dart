import 'dart:io';

import 'package:elra/pages/admin_pages/admin_assessmentpage.dart';
import 'package:elra/pages/admin_pages/admin_elderpage.dart';
import 'package:elra/pages/admin_pages/admin_homepage.dart';
import 'package:elra/pages/admin_pages/admin_volunteer.dart';
import 'package:elra/pages/loginpage.dart';
import 'package:elra/pages/volunteer_pages/volunteer_homepage.dart';
import 'package:elra/variables.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Widget backdrop() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFEB958), Color(0xFFFE965F), Color(0xFFFD937D)],
      ),
    ),
  );
}

SafeArea drawerMenu(BuildContext context, {required String name}) {
  return SafeArea(
    child: Container(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 128.0,
              height: 128.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                // bottom: 8.0,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 36.0,
              ),
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VolunteerHomePage(),
                    ));
              },
              leading: const Icon(Icons.elderly),
              title: const Text('รายชื่อผู้สูงอายุ'),
            ),
            ListTile(
              onTap: () {
                print("การประเมิน");
              },
              leading: const Icon(Icons.check_box_outlined),
              title: const Text('การประเมินความเสี่ยง'),
            ),
            ListTile(
              onTap: () {
                print("ประวัติการประเมิน");
              },
              leading: const Icon(Icons.history),
              title: const Text('ประวัติการประเมิน'),
            ),
            ListTile(
              onTap: () {
                print("รายงานการประเมินความเสี่ยง");
              },
              leading: const Icon(Icons.bar_chart_rounded),
              title: const Text('รายงานการประเมินความเสี่ยง'),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                print("ข้อมูลส่วนตัว");
              },
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('ข้อมูลส่วนตัว'),
            ),
            ListTile(
              onTap: () {
                print("ออกจากระบบ");
                var url = Uri.parse("$apiURL/logout");
                logout(url).then((value) {
                  print(value.body);
                  clearPrefs();
                });
                // Navigation to Login page
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
              leading: const Icon(Icons.logout),
              title: const Text('ออกจากระบบ'),
            ),
          ],
        ),
      ),
    ),
  );
}

SafeArea drawerAdminMenu(BuildContext context, {required String name}) {
  return SafeArea(
    child: Container(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 128.0,
              height: 128.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                // bottom: 8.0,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 36.0,
              ),
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminHomePage(),
                    ));
              },
              leading: const Icon(Icons.assignment_ind_outlined),
              title: const Text('จัดการผู้ดูแลระบบ'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminVolunteerPage(),
                    ));
              },
              leading: const Icon(Icons.volunteer_activism),
              title: const Text('จัดการอาสาสมัคร'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminElderPage(),
                    ));
              },
              leading: const Icon(Icons.elderly_rounded),
              title: const Text('จัดการผู้สูงอายุ'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminAssessmentHomePage(),
                    ));
              },
              leading: const Icon(Icons.check_box_outlined),
              title: const Text('ทำแบบประเมินความเสี่ยง'),
            ),
            ListTile(
              onTap: () {
                print("รายงานการประเมิน");
              },
              leading: const Icon(Icons.bar_chart_rounded),
              title: const Text('รายงานการประเมิน'),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                print("ข้อมูลส่วนตัว");
              },
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('ข้อมูลส่วนตัว'),
            ),
            ListTile(
              onTap: () {
                print("ออกจากระบบ");
                var url = Uri.parse("$apiURL/logout");
                logout(url).then((value) {
                  print(value.body);
                  clearPrefs();
                });
                // Navigation to Login page
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
              leading: const Icon(Icons.logout),
              title: const Text('ออกจากระบบ'),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<http.Response> logout(Uri url) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await http.post(url, headers: {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
  });
}

void clearPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}
