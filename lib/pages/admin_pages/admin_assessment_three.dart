import 'dart:convert';
import 'dart:io';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:elra/pages/admin_pages/admin_assessment_four.dart';
import 'package:elra/pages/admin_pages/admin_assessmentmain.dart';
import 'package:elra/utils/add_riskassessment.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:elra/utils/info.dart';
import 'package:elra/utils/manage_choices.dart';
import 'package:elra/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminAssessmentPartThree extends StatefulWidget {
  const AdminAssessmentPartThree({super.key, required this.elderid});

  final int elderid;

  @override
  State<AdminAssessmentPartThree> createState() =>
      _AdminAssessmentPartThreeState();
}

class _AdminAssessmentPartThreeState extends State<AdminAssessmentPartThree> {
  final _advancedDrawerController = AdvancedDrawerController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String username = "";
  String eldername = "";
  String elderaddr = "";
  String codename = "";
  int assId = 0;
  int part = 3;

  int criterias = 3;
  final List<String> _subpart = ["3.1", "3.2", "3.3"];
  List<bool> _disable3 = [];
  List<int> _answerTouch = [];
  List<int> _answerDamage = [];

  List<GlobalKey<CustomRadioButtonState>> radioCustomTouchKey = [];
  List<GlobalKey<CustomRadioButtonState>> radioCustomDamageKey = [];

  final Map<String, dynamic> _manageChoice3 = manageChoice3;
  final Map<String, dynamic> _enableManage3 = enableManage3;
  final List<String> _manageGroup3 = manageGroup1;

  final Map<String, dynamic> _questions3 = questions3;

  @override
  void dispose() {
    _advancedDrawerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _disable3 = List.generate(criterias, (index) => true);
    _answerTouch = List.generate(criterias, (index) => 0);
    _answerDamage = List.generate(criterias, (index) => 0);
    radioCustomTouchKey = List.generate(
        criterias, (index) => GlobalKey<CustomRadioButtonState>());
    radioCustomDamageKey = List.generate(
        criterias, (index) => GlobalKey<CustomRadioButtonState>());
    initialValue();
    getAssessment();
  }

  void initialValue() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      username = prefs.getString('name')!;
      eldername = prefs.getString('eldername')!;
      elderaddr = prefs.getString('elderaddr')!;
      codename = prefs.getString('codename')!;
    });
  }

  Future<void> getAssessment() async {
    SharedPreferences prefs = await _prefs;
    var url = Uri.parse("$apiURL/assessmentelder/${widget.elderid}");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
    });
    var jsonString = jsonDecode(response.body);
    setState(() {
      assId = jsonString['data']['ass_id'];
    });

    url = Uri.parse("$apiURL/riskpartthree/$assId");
    response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
    });
    jsonString = jsonDecode(response.body);

    if (jsonString['data'].length > 0) {
      var data = jsonString['data'];
      var index = 0;
      for (var el in data) {
        setState(() {
          _manageChoice3[el['subpart']] = el['manage'];
          _answerTouch[index] = el['touch'];
          _answerDamage[index] = el['violent'];
          radioCustomTouchKey[index].currentState!.selectButton(el['touch']);
          radioCustomDamageKey[index].currentState!.selectButton(el['violent']);
        });
        index++;
      }
      print(_answerTouch);
      print(_answerDamage);
      print(_manageChoice3);
    }
  }

  @override
  Widget build(BuildContext context) {
    int subtitleIndex = 0;
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
          title: const Text("การประเมินความเสี่ยง"),
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
                const Divider(),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    // shrinkWrap: true,
                    children: [
                      const Text(
                        "3. สิ่งแวดล้อมทางชีวภาพ",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // try for loop
                      Column(
                        children: _questions3.entries.map((q) {
                          return _createQuestions(q, subtitleIndex++);
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      actionButton(),
                      const SizedBox(height: 16),
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

  Widget _createQuestions(MapEntry<String, dynamic> q, int indx) {
    return SizedBox(
      child: Column(
        children: [
          Text("${q.key} ${q.value}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          assessmentSection(index: indx),
          const SizedBox(height: 16),
          createCheckbox1(sub: q.key),
          const Divider(),
        ],
      ),
    );
  }

  Widget actionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.arrow_back_ios_new),
          label: const Text("ย้อนกลับ"),
          onPressed: () {
            // back to home page
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AdminAssessmentMainPage(elderid: widget.elderid),
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
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text("บันทึก"),
          onPressed: () {
            // save to database
            // back to home page
            print(_answerTouch);
            print(_answerDamage);
            print(_manageChoice3);

            var result = [];
            for (var i = 0; i < criterias; i++) {
              result.add({
                "subpart": _subpart[i],
                "touch": _answerTouch[i],
                "violent": _answerDamage[i],
                "manage": _manageChoice3[_subpart[i]],
              });
            }

            var body = {"part": part, "result": result};
            print(body);

            addRiskAssessment(assId, jsonEncode(body));

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AdminAssessmentPartFour(elderid: widget.elderid),
                ));
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF407F40)),
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

  Widget assessmentSection({required int index}) {
    return Column(
      children: [
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text(
            'โอกาสสัมผัส',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          tileColor: const Color(0xFF029F8F),
        ),
        const SizedBox(height: 8),
        CustomRadioButton(
          key: radioCustomTouchKey[index],
          enableShape: true,
          width: 60,
          elevation: 0,
          selectedBorderColor: Colors.transparent,
          unSelectedBorderColor: Colors.transparent,
          buttonLables: const ['0', '1', '2', '3'],
          buttonValues: const [0, 1, 2, 3],
          buttonTextStyle: const ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: Colors.black,
            textStyle: TextStyle(fontSize: 16),
          ),
          radioButtonValue: (value) {
            print(value);
            setState(() {
              _answerTouch[index] = value;
            });
            if (value == 0) {
              setState(() {
                print("$index disable");
                _disable3[index] = true;
                _answerDamage[index] = 0;
              });
            } else {
              setState(() {
                _disable3[index] = false;
              });
            }
          },
          selectedColor: Colors.blue.shade600,
          unSelectedColor: const Color(0xFFE8E8E8),
        ),
        const SizedBox(height: 16),
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text(
            'ความรุนแรง',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          tileColor: const Color(0xFF029F8F),
        ),
        const SizedBox(height: 8),
        CustomRadioButton(
          key: radioCustomDamageKey[index],
          enableShape: true,
          disabledValues: _disable3[index] ? [1, 2, 3] : [],
          width: 60,
          elevation: 0,
          // absoluteZeroSpacing: true,
          selectedBorderColor: Colors.transparent,
          unSelectedBorderColor: Colors.transparent,
          buttonLables: const ['1', '2', '3'],
          buttonValues: const [1, 2, 3],
          buttonTextStyle: const ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: Colors.black,
            disabledColor: Color.fromARGB(255, 168, 168, 168),
            textStyle: TextStyle(fontSize: 16),
          ),
          radioButtonValue: (value) {
            print(value);
            setState(() {
              _answerDamage[index] = value;
            });
          },
          selectedColor: Colors.blue.shade600,
          unSelectedColor: const Color(0xFFE8E8E8),
          disabledColor: const Color(0xFFE8E8E8),
        ),
      ],
    );
  }

  Widget createCheckbox1({required String sub}) {
    List<Widget> widgets = [];
    widgets.add(
      ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text(
          'การจัดการความความปลอดภัย (ถ้ามี)',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        tileColor: const Color(0xFF029F8F),
      ),
    );
    for (var i in List.generate(_manageGroup3.length, (index) => index)) {
      widgets.add(
        CheckboxListTile(
          // value: _manageChoice1_1[i],
          // enabled: _enable_manage1_1[i],
          value: _manageChoice3[sub][i],
          enabled: _enableManage3[sub][i],
          controlAffinity: ListTileControlAffinity.trailing,
          dense: true,
          visualDensity: VisualDensity.comfortable,
          onChanged: (value) {
            setState(() {
              _manageChoice3[sub][i] = value!;
            });
          },
          title: Text(
            _manageGroup3[i],
            style: const TextStyle(fontSize: 14),
          ),
        ),
      );
    }
    return Column(children: widgets);
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
