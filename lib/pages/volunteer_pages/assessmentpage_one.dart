import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_home.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:elra/utils/info.dart';
import 'package:elra/utils/manage_choices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class AssessmentPartOne extends StatefulWidget {
  const AssessmentPartOne({super.key});

  @override
  State<AssessmentPartOne> createState() => _AssessmentPartOneState();
}

class _AssessmentPartOneState extends State<AssessmentPartOne> {
  final _advancedDrawerController = AdvancedDrawerController();

  // 6 Criterias
  final List<bool> _disable1 = List.generate(6, (index) => false);
  final List<int> _answerTouch = List.generate(6, (index) => 0);
  final List<int> _answerDamage = List.generate(6, (index) => 0);

  final Map<String, dynamic> _manageChoice1 = manageChoice1;
  final Map<String, dynamic> _enableManage1 = enableManage1;
  final List<String> _manageGroup1 = manageGroup1;

  @override
  void dispose() {
    _advancedDrawerController.dispose();
    super.dispose();
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
      drawer: drawerMenu(context),
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
                const ListTile(
                  contentPadding: EdgeInsets.only(right: 16),
                  tileColor: Color(0xFFEAEAEA),
                  title: Text(
                    "นางเพ็ญศรี พันธ์คง",
                    style: TextStyle(fontSize: 16, color: Color(0xFF656363)),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    // shrinkWrap: true,
                    children: [
                      const Text(
                        "1. สิ่งแวดล้อมทางกายภาพ",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // ---------- 1.1 ----------
                      const Text('1.1 มีการสัมผัสความร้อน',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      assessmentSection(index: 0),
                      const SizedBox(height: 16),
                      createCheckbox1(sub: "1.1"),
                      const Divider(),
                      // ---------- 1.2 ----------
                      const Text('1.2 มีการสัมผัสเสียงดัง',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      assessmentSection(index: 1),
                      const SizedBox(height: 16),
                      createCheckbox1(sub: "1.2"),
                      const Divider(),
                      // ---------- 1.3 ----------
                      const Text('1.3 มีแสงสว่างจ้าเกินไป',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      assessmentSection(index: 2),
                      const SizedBox(height: 16),
                      createCheckbox1(sub: "1.3"),
                      const Divider(),
                      // ---------- 1.4 ----------
                      const Text('1.4 มีแสงสว่างไม่เพียงพอ',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      assessmentSection(index: 3),
                      const SizedBox(height: 16),
                      createCheckbox1(sub: "1.4"),
                      const Divider(),
                      // ---------- 1.5 ----------
                      const Text('1.5 มีความสั่นสะเทือน',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      assessmentSection(index: 4),
                      const SizedBox(height: 16),
                      createCheckbox1(sub: "1.5"),
                      const Divider(),
                      // ---------- 1.6 ----------
                      const Text('1.6 มีการสัมผัสกับรังสี UV',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      assessmentSection(index: 5),
                      const SizedBox(height: 16),
                      createCheckbox1(sub: "1.6"),
                      const Divider(),
                      // ---------- action button ----------
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

  Widget actionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.arrow_back_ios_new),
          label: const Text("ย้อนกลับ"),
          onPressed: () {
            // back to home page
            Navigator.pop(context);
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AssHomePage(),
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
          enableShape: true,
          width: 60,
          elevation: 0,
          selectedBorderColor: Colors.transparent,
          unSelectedBorderColor: Colors.transparent,
          buttonLables: const ['0', '1', '2', '3'],
          buttonValues: const ["0", "1", "2", "3"],
          buttonTextStyle: const ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: Colors.black,
            textStyle: TextStyle(fontSize: 16),
          ),
          radioButtonValue: (value) {
            print(value);
            if (value == "0") {
              setState(() {
                _disable1[index] = true;
              });
            } else {
              setState(() {
                _disable1[index] = false;
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
          enableShape: true,
          disabledValues: _disable1[index] ? ["1", "2", "3"] : [],
          width: 60,
          elevation: 0,
          // absoluteZeroSpacing: true,
          selectedBorderColor: Colors.transparent,
          unSelectedBorderColor: Colors.transparent,
          buttonLables: const ['1', '2', '3'],
          buttonValues: const ["1", "2", "3"],
          buttonTextStyle: const ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: Colors.black,
            disabledColor: Color.fromARGB(255, 168, 168, 168),
            textStyle: TextStyle(fontSize: 16),
          ),
          radioButtonValue: (value) {
            print(value);
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
    for (var i in List.generate(_manageGroup1.length, (index) => index)) {
      widgets.add(
        CheckboxListTile(
          // value: _manageChoice1_1[i],
          // enabled: _enable_manage1_1[i],
          value: _manageChoice1[sub][i],
          enabled: _enableManage1[sub][i],
          controlAffinity: ListTileControlAffinity.trailing,
          dense: true,
          visualDensity: VisualDensity.comfortable,
          onChanged: (value) {
            setState(() {
              _manageChoice1[sub][i] = value!;
            });
          },
          title: Text(
            _manageGroup1[i],
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
