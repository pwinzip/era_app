import 'dart:convert';
import 'dart:io';

import 'package:elra/models/eldersbyvolunteer_model.dart';
import 'package:elra/pages/admin_pages/admin_assessmentmain.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:elra/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class AdminAssessmentHomePage extends StatefulWidget {
  const AdminAssessmentHomePage({super.key});

  @override
  State<AdminAssessmentHomePage> createState() =>
      _AdminAssessmentHomePageState();
}

class _AdminAssessmentHomePageState extends State<AdminAssessmentHomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List elders_complete = [];
  List elders_incomplete = [];

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
          title: const Text("ผู้ดูแลระบบ"),
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
              // decoration:
              //     BoxDecoration(border: Border.all(style: BorderStyle.solid)),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(right: 16),
                    tileColor: const Color.fromARGB(255, 2, 128, 170),
                    title: Column(
                      children: [
                        Text(
                          "แบบประเมินประจำเดือน ${DateFormat.MMMM('th').format(DateTime.now())} พ.ศ. ${int.parse(DateFormat.y('th').format(DateTime.now())) + 543}",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 233, 233, 233)),
                        ),
                      ],
                    ),
                  ),
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "รายชื่อผู้สูงอายุ",
                      style: TextStyle(fontSize: 20, color: Colors.teal),
                    ),
                  )),
                  showElderList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getElders() async {
    SharedPreferences prefs = await _prefs;
    var url = Uri.parse("$apiURL/eldersbyadmin");

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
    });
    return response.body;
  }

  Widget showElderList() {
    return FutureBuilder(
      future: getElders(),
      builder: (context, snapshot) {
        List<Widget> myList = [];
        // print(snapshot);

        if (snapshot.hasData) {
          var jsonString = jsonDecode(snapshot.data.toString());
          EldersbyvolunteerModel eld =
              EldersbyvolunteerModel.fromJson(jsonString['data']);
          myList.add(
            Column(
              children: eld.incomplete.map((item) {
                return elderList(data: item, complete: false);
              }).toList(),
            ),
          );
          myList.add(
            Column(
              children: eld.complete.map((item) {
                return elderList(data: item, complete: true);
              }).toList(),
            ),
          );
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

        return Center(
          child: Column(
            children: myList,
          ),
        );
      },
    );
  }

  Widget elderList({required AssComplete data, required bool complete}) {
    return Card(
      color: complete
          ? const Color.fromARGB(255, 155, 250, 158)
          : Theme.of(context).cardColor,
      child: ListTile(
        onTap: () {},
        title: Text(
          data.codeName,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle:
            Text("${data.houseNo} หมู่ที่ ${data.moo} ตำบล${data.tambon}"),
        trailing: complete
            ? const SizedBox()
            : ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFFD937D))),
                onPressed: () {
                  print(data.userId);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AdminAssessmentMainPage(elderid: data.userId),
                      ));
                },
                child: const Text(
                  "ประเมิน",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
