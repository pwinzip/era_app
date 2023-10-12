import 'package:elra/pages/volunteer_pages/volunteer_homepage.dart';
import 'package:flutter/material.dart';

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

SafeArea drawerMenu(BuildContext context) {
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
              child: const Column(
                children: [
                  Text("ชื่อ นามสกุล"),
                  Text("ประเภทผู้ใช้"),
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
              leading: const Icon(Icons.home),
              title: const Text('หน้าหลัก'),
            ),
            ListTile(
              onTap: () {
                print("ประวัติการประเมิน");
              },
              leading: const Icon(Icons.history),
              title: const Text('ประวัติการประเมิน'),
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
