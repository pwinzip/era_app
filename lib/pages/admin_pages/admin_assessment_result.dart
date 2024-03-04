import 'dart:convert';
import 'dart:io';

import 'package:elra/pages/admin_pages/admin_assessmentpage.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:elra/utils/info.dart';
import 'package:elra/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:http/http.dart' as http;

class AdminAssessmentResult extends StatefulWidget {
  const AdminAssessmentResult({super.key, required this.elderid});

  final int elderid;

  @override
  State<AdminAssessmentResult> createState() => _AdminAssessmentResultState();
}

class _AdminAssessmentResultState extends State<AdminAssessmentResult> {
  final _advancedDrawerController = AdvancedDrawerController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String username = "";
  String eldername = "";
  String elderaddr = "";
  String codename = "";
  int assId = 0;

  double overallresult = 0;
  List<double> partresult = List.generate(8, (index) => 0);

  @override
  void dispose() {
    _advancedDrawerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialValue();
  }

  void initialValue() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      username = prefs.getString('name')!;
      eldername = prefs.getString('eldername')!;
      elderaddr = prefs.getString('elderaddr')!;
      codename = prefs.getString('codename')!;
    });
    var url = Uri.parse("$apiURL/assessmentelder/${widget.elderid}");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
    });
    var jsonString = jsonDecode(response.body);
    setState(() {
      assId = jsonString['data']['ass_id'];
    });

    url = Uri.parse("$apiURL/riskresult/$assId");
    response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
    });
    jsonString = jsonDecode(response.body);
    // print(jsonString['resultpart']);
    // print(jsonString['overall']);
    setState(() {
      overallresult = jsonString['overall'];
      partresult.clear();
      for (double element in jsonString['resultpart']) {
        partresult.add(element);
      }
    });

    // print(overallresult);
    // print(partresult);
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
          title: const Text("ผลการประเมินความเสี่ยง"),
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
                createCustomGauge(
                    title: "การประเมินความเสี่ยงภาพรวม", value: overallresult),
                createCustomGauge(
                    title: "1. สิ่งแวดล้อมทางกายภาพ", value: partresult[0]),
                createCustomGauge(
                    title: "2. สิ่งแวดล้อมทางเคมี", value: partresult[1]),
                createCustomGauge(
                    title: "3. สิ่งแวดล้อมทางชีวภาพ", value: partresult[2]),
                createCustomGauge(title: "4. การยศาสตร์", value: partresult[3]),
                createCustomGauge(
                    title: "5. จิตวิทยาสังคม", value: partresult[4]),
                createCustomGauge(
                    title: "6. ความเสี่ยงในการบาดเจ็บหรือเกิดอุบัติเหตุ",
                    value: partresult[5]),
                createCustomGauge(
                    title: "7. ความเสี่ยงในการเกิดไฟไหม้หรือสารเคมีรั่วไหล",
                    value: partresult[6]),
                createCustomGauge(
                    title: "8. คุณภาพอากาศ", value: partresult[7]),
                actionButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget actionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.arrow_back_ios_new),
          label: const Text("กลับไปหน้าแรก"),
          onPressed: () {
            // back to home page
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminAssessmentHomePage(),
                ));
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFFFE965F)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            )),
          ),
        ),
      ],
    );
  }

  Widget createCustomGauge({required String title, required double value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        height: 300,
        child: SfRadialGauge(
            title: GaugeTitle(
                text: title,
                textStyle: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold)),
            axes: <RadialAxis>[
              RadialAxis(
                  minimum: 0,
                  maximum: 9,
                  interval: 1,
                  startAngle: 180,
                  endAngle: 0,
                  showLastLabel: true,
                  ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0,
                        endValue: 3,
                        color: Colors.green,
                        startWidth: 20,
                        endWidth: 20),
                    GaugeRange(
                        startValue: 3,
                        endValue: 6,
                        color: Colors.orange,
                        startWidth: 20,
                        endWidth: 20),
                    GaugeRange(
                        startValue: 6,
                        endValue: 9,
                        color: Colors.red,
                        startWidth: 20,
                        endWidth: 20)
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: value,
                    )
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: SizedBox(
                            child: Text(value.toStringAsFixed(3),
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                        angle: 90,
                        positionFactor: 0.4)
                  ])
            ]),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
