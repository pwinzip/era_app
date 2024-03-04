import 'dart:convert';
import 'dart:io';

import 'package:elra/models/asselder_model.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_profile.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_one.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_two.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_three.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_four.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_five.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_six.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_seven.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_eight.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_result.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:elra/utils/info.dart';
import 'package:elra/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AssHomePage extends StatefulWidget {
  const AssHomePage({super.key, required this.elderid});

  final int elderid;

  @override
  State<AssHomePage> createState() => _AssHomePageState();
}

class _AssHomePageState extends State<AssHomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String username = "";
  String eldername = "";
  String elderaddr = "";
  String codename = "";
  int assId = 0;

  String month = "";
  int year = DateTime.now().year;
  bool isAllComplete = true;
  List<bool> _completed = [
    false, // general info
    false, // part 1 physic
    false, // part 2 chem
    false, // part 3 bio
    false, // part 4 kines
    false, // part 5 psycho
    false, // part 6 accident
    false, // part 7 fire
    false // part 8 air
  ];

  @override
  void dispose() {
    _advancedDrawerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    initialValue();
  }

  void initialValue() async {
    SharedPreferences prefs = await _prefs;
    username = prefs.getString('name')!;
    getElder();
  }

  Future<void> getElder() async {
    SharedPreferences prefs = await _prefs;
    print(widget.elderid);

    var url = Uri.parse("$apiURL/elderinfo/${widget.elderid}");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
    });

    print(response.statusCode);

    var jsonString = jsonDecode(response.body);
    print(jsonString);
    print("-----");
    AsselderModel assdata = AsselderModel.fromJson(jsonString['data'][0]);

    setState(() {
      eldername = assdata.prefix + assdata.name;
      elderaddr =
          "หมู่ที่ ${assdata.moo} ตำบล${assdata.tambon} อำเภอ${assdata.amphoe}";
      codename = assdata.codeName;
      prefs.setString('eldername', eldername);
      prefs.setString('elderaddr', elderaddr);
      prefs.setString('codename', assdata.codeName);
      print(assdata);

      if (assdata.assId != null) {
        assId = assdata.assId!;
      }
      _completed = [
        assdata.assPersonal == 0 || assdata.assPersonal == null ? false : true,
        assdata.assPart1 == 0 || assdata.assPart1 == null ? false : true,
        assdata.assPart2 == 0 || assdata.assPart2 == null ? false : true,
        assdata.assPart3 == 0 || assdata.assPart3 == null ? false : true,
        assdata.assPart4 == 0 || assdata.assPart4 == null ? false : true,
        assdata.assPart5 == 0 || assdata.assPart5 == null ? false : true,
        assdata.assPart6 == 0 || assdata.assPart6 == null ? false : true,
        assdata.assPart7 == 0 || assdata.assPart7 == null ? false : true,
        assdata.assPart8 == 0 || assdata.assPart8 == null ? false : true,
      ];

      for (var cp in _completed) {
        isAllComplete &= cp;
      }
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
          backgroundColor: const Color.fromARGB(255, 245, 195, 138),
          title: const Text("แบบประเมินความเสี่ยง"),
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
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog.fullscreen(
                      child: assessmentInstruction(context),
                    ),
                  );
                },
                icon: const Icon(Icons.info))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(right: 16),
                    // tileColor: const Color(0xFFEAEAEA),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          codename,
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFF656363)),
                        ),
                        Text(
                          elderaddr,
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFF656363)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    // shrinkWrap: true,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AssProfile(elderid: widget.elderid),
                              ));
                        },
                        child: createCardMenu("ข้อมูลทั่วไป", _completed[0]),
                      ),
                      InkWell(
                        onTap: () {
                          _completed[0]
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AssessmentPartOne(
                                    elderid: widget.elderid,
                                  ),
                                ))
                              : () {};
                        },
                        child: createCardMenu(
                            "1. สิ่งแวดล้อมทางกายภาพ", _completed[1]),
                      ),
                      InkWell(
                        onTap: () {
                          _completed[0]
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AssessmentPartTwo(
                                        elderid: widget.elderid),
                                  ))
                              : () {};
                        },
                        child: createCardMenu(
                            "2. สิ่งแวดล้อมทางเคมี", _completed[2]),
                      ),
                      InkWell(
                        onTap: _completed[0]
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssessmentPartThree(
                                          elderid: widget.elderid),
                                    ));
                              }
                            : () {},
                        child: createCardMenu(
                            "3. สิ่งแวดล้อมทางชีวภาพ", _completed[3]),
                      ),
                      InkWell(
                        onTap: _completed[0]
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssessmentPartFour(
                                          elderid: widget.elderid),
                                    ));
                              }
                            : () {},
                        child: createCardMenu("4. การยศาสตร์", _completed[4]),
                      ),
                      InkWell(
                        onTap: _completed[0]
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssessmentPartFive(
                                          elderid: widget.elderid),
                                    ));
                              }
                            : () {},
                        child:
                            createCardMenu("5. จิตวิทยาสังคม", _completed[5]),
                      ),
                      InkWell(
                        onTap: _completed[0]
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssessmentPartSix(
                                          elderid: widget.elderid),
                                    ));
                              }
                            : () {},
                        child: createCardMenu(
                            "6. ความเสี่ยงในการบาดเจ็บหรือเกิดอุบัติเหตุ",
                            _completed[6]),
                      ),
                      InkWell(
                        onTap: _completed[0]
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssessmentPartSeven(
                                          elderid: widget.elderid),
                                    ));
                              }
                            : () {},
                        child: createCardMenu(
                            "7. ความเสี่ยงในการเกิดไฟไหม้หรือสารเคมีรั่วไหล",
                            _completed[7]),
                      ),
                      InkWell(
                        onTap: _completed[0]
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssessmentPartEight(
                                          elderid: widget.elderid),
                                    ));
                              }
                            : () {},
                        child: createCardMenu("8. คุณภาพอากาศ", _completed[8]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: isAllComplete
                              ? () {
                                  submitResult();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AssessmentResult(
                                          elderid: widget.elderid,
                                        ),
                                      ));
                                }
                              : () {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    title: "ส่งแบบประเมิน",
                                    text: 'ทำแบบประเมินให้ครบถ้วน',
                                    confirmBtnText: "ตกลง",
                                  );
                                },
                          child: const Text("ส่งแบบประเมิน")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitResult() async {
    SharedPreferences prefs = await _prefs;
    var url = Uri.parse("$apiURL/updatestatus/$assId");
    var response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
    });
    print(response.statusCode);
  }

  Card createCardMenu(String title, bool enable) {
    return Card(
      color: enable ? const Color(0xFFBBFFBB) : const Color(0xFFF5AD86),
      child: ListTile(
        title: Text(title),
        trailing: enable
            ? const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF407F40),
              )
            : null,
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
