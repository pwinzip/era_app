import 'dart:convert';
import 'dart:io';

import 'package:elra/models/eldersbyvolunteer_model.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_home.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:elra/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerHomePage extends StatefulWidget {
  const VolunteerHomePage({super.key});

  @override
  State<VolunteerHomePage> createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends State<VolunteerHomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List elders_complete = [];
  List elders_incomplete = [];

  String username = "";

  @override
  void initState() {
    super.initState();
    initialvalue();
    // getElders();
  }

  void initialvalue() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      username = prefs.getString('name')!;
    });
  }

  Future<String> getElders() async {
    SharedPreferences prefs = await _prefs;
    var moo = prefs.getInt("moo");
    var tambon = prefs.getString("tambon");
    var amphoe = prefs.getString("amphoe");
    var url = Uri.parse("$apiURL/eldersbyaddress");
    var body = jsonEncode({"moo": moo, "tambon": tambon, "amphoe": amphoe});

    var response = await http.post(url, body: body, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
    });

    // var jsonString = jsonDecode(response.body);
    // print(jsonString);
    // Eldersbyvolunteer eld = Eldersbyvolunteer.fromJson(jsonString['data']);
    // elders_incomplete = jsonString['data']['incomplete']
    //     .map<AssComplete>((json) => AssComplete.fromJson(json))
    //     .toList();
    // elders_complete = jsonString['data']['complete']
    //     .map<AssComplete>((json) => AssComplete.fromJson(json))
    //     .toList();
    // print(elders_incomplete);
    // print(elders_complete);
    return response.body;
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
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: drawerMenu(context, name: username),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("อาสาสมัคร"),
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
                      "รายชื่อผู้สูงอายุที่รับผิดชอบ",
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssHomePage(elderid: data.userId),
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

  Widget topCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      height: 90,
      child: Card(
        color: const Color(0xFF4B82DF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: const Text(
                    "เลือกหมู่ที่",
                    // style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Column circularMenu(IconData icon, String str, MaterialPageRoute route) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, route);
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const CircleBorder()),
            padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
            backgroundColor: MaterialStateProperty.all(const Color(0xFFF77129)),
          ),
          child: Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),
        ),
        Text(str)
      ],
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
