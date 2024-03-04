import 'dart:convert';
import 'dart:io';

import 'package:elra/models/admin_model.dart';
import 'package:elra/pages/admin_pages/add_adminpage.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:elra/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String username = "";

  @override
  void initState() {
    super.initState();
    initialvalue();
  }

  void initialvalue() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      username = prefs.getString('name')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: backdrop(),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 0.9,
      openRatio: 0.6,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: drawerAdminMenu(context, name: username),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 197, 245),
          title: const Text("จัดการผู้ดูแลระบบ"),
          leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              )),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(left: 20, top: 20),
            alignment: Alignment.topCenter,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  showAdminList(),
                ],
              ),
            ),
          ),
        )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 138, 197, 245),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAdminPage(),
                ));
          },
          child: const Icon(Icons.person_add_alt_1_rounded),
        ),
      ),
    );
  }

  Widget showAdminList() {
    return FutureBuilder(
      future: getAdmins(),
      builder: (context, snapshot) {
        List<Widget> myList = [];
        // print(snapshot);

        if (snapshot.hasData) {
          var jsonString = jsonDecode(snapshot.data.toString());
          var data = jsonString['data'];

          myList = data.map<Widget>((json) {
            AdminModel vol = AdminModel.fromJson(json);
            return adminList(vol);
          }).toList();
        } else if (snapshot.hasError) {
          myList = [
            const Icon(Icons.error, color: Colors.red, size: 60),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text("ข้อผิดพลาด ${snapshot.error}"),
            )
          ];
        } else {
          myList = [
            const SizedBox(
                width: 60, height: 60, child: CircularProgressIndicator()),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text("อยู่ระหว่างประมวลผล"),
            )
          ];
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: myList,
        );
      },
    );
  }

  Widget adminList(AdminModel admin) {
    return Card(
      child: ListTile(
        onTap: () {},
        title: Text(
          "${admin.userprefix}${admin.name}",
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Text("ชื่อผู้ใช้งาน: ${admin.username}"),
      ),
    );
  }

  Future<String> getAdmins() async {
    SharedPreferences prefs = await _prefs;
    var url = Uri.parse("$apiURL/admins");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
    });
    return response.body;
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
