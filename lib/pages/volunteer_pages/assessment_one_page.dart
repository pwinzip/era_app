import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class AssessmentPartOne extends StatefulWidget {
  const AssessmentPartOne({super.key});

  @override
  State<AssessmentPartOne> createState() => _AssessmentPartOneState();
}

class _AssessmentPartOneState extends State<AssessmentPartOne> {
  final _advancedDrawerController = AdvancedDrawerController();

  // bool _disable1_1 = false;
  // bool _disable1_2 = false;
  // bool _disable1_3 = false;
  // bool _disable1_4 = false;
  // bool _disable1_5 = false;
  // bool _disable1_6 = false;
  final List<bool> _disable1 = [false, false, false, false, false, false];
  // final List<bool> _manageChoice1_1 = [false, false, false, false, false];

  final Map<String, dynamic> _manageChoice1 = {
    "1.1": [false, false, false, false, false],
    "1.2": [false, false, false, false, false],
    "1.3": [false, false, false, false, false],
    "1.4": [false, false, false, false, false],
    "1.5": [false, false, false, false, false],
    "1.6": [false, false, false, false, false],
  };

  final Map<String, dynamic> _enable_manage1 = {
    "1.1": [false, false, true, true, true],
    "1.2": [true, false, true, true, true],
    "1.3": [true, false, true, true, true],
    "1.4": [true, false, true, true, true],
    "1.5": [true, false, true, true, true],
    "1.6": [true, true, true, true, true],
  };

  // final List<bool> _enable_manage1_1 = [false, false, true, true, true];
  // final List<bool> _enable_manage1_2 = [true, false, true, true, true];
  // final List<bool> _enable_manage1_3 = [true, false, true, true, true];
  // final List<bool> _enable_manage1_4 = [true, false, true, true, true];
  // final List<bool> _enable_manage1_5 = [true, false, true, true, true];
  // final List<bool> _enable_manage1_6 = [true, true, true, true, true];
  final List<String> _manage_group1 = [
    'การบำรุงรักษา/ปรับปรุงพื้นที่',
    'ทำความสะอาดร่างกาย/เสื้อผ้า',
    'ใช้อุปกร์ป้องกันอันตรายส่วนบุคคล',
    'เรียนรู้/อ่านฉลาก/คู่มือ',
    'ตรวจสุขภาพ',
  ];

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
              )),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.only(left: 20, top: 20),
              child: Column(
                // shrinkWrap: true,
                children: [
                  const Text(
                    "1. สิ่งแวดล้อมทางกายภาพ",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text('1.1 มีการสัมผัสความร้อน',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  assessmentSection(index: 0),
                  const SizedBox(height: 16),
                  const Text('การจัดการความความปลอดภัย (ถ้ามี)'),
                  createCheckbox1(sub: "1.1"),
                  const Divider(),
                  const Text('2. มีการสัมผัสเสียงดัง',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  assessmentSection(index: 1),
                  const SizedBox(height: 16),
                  const Text('การจัดการความความปลอดภัย (ถ้ามี)'),
                  createCheckbox1(sub: "1.2"),
                  const Divider(),
                  const Text('3. มีแสงสว่างจ้าเกินไป',
                      style: TextStyle(fontSize: 18)),
                  const Text('4. มีแสงสว่างไม่เพียงพอ',
                      style: TextStyle(fontSize: 18)),
                  const Text('5. มีความสั่นสะเทือน',
                      style: TextStyle(fontSize: 18)),
                  const Text('6. มีการสัมผัสกับรังสี UV',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('ย้อนกลับ'),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save_alt),
                        label: const Text("บันทึก"),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget assessmentSection({required int index}) {
    return Column(
      children: [
        const Text('โอกาสสัมผัส'),
        CustomRadioButton(
          enableShape: true,
          width: 60,
          elevation: 0,
          // absoluteZeroSpacing: true,
          unSelectedColor: Theme.of(context).canvasColor,
          selectedBorderColor: Colors.black,
          unSelectedBorderColor: Colors.black,
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
        ),
        const SizedBox(height: 16),
        const Text('ความรุนแรง'),
        CustomRadioButton(
          enableShape: true,
          disabledValues: _disable1[index] ? ["1", "2", "3"] : [],
          disabledColor: Colors.grey[400],
          width: 60,
          elevation: 0,
          // absoluteZeroSpacing: true,
          selectedBorderColor: Colors.black,
          unSelectedBorderColor: Colors.black,
          buttonLables: const ['1', '2', '3'],
          buttonValues: const ["1", "2", "3"],
          buttonTextStyle: ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: Colors.black,
            disabledColor: Colors.grey.shade700,
            textStyle: const TextStyle(fontSize: 16),
          ),
          radioButtonValue: (value) {
            print(value);
          },
          selectedColor: Colors.blue.shade600,
          unSelectedColor: Theme.of(context).canvasColor,
        ),
      ],
    );
  }

  Widget createCheckbox1({required String sub}) {
    List<Widget> widgets = [];
    for (var i in List.generate(_manage_group1.length, (index) => index)) {
      widgets.add(
        CheckboxListTile(
          // value: _manageChoice1_1[i],
          // enabled: _enable_manage1_1[i],
          value: _manageChoice1[sub][i],
          enabled: _enable_manage1[sub][i],
          controlAffinity: ListTileControlAffinity.trailing,
          dense: true,
          visualDensity: VisualDensity.comfortable,
          onChanged: (value) {
            setState(() {
              _manageChoice1[sub][i] = value!;
            });
          },
          title: Text(
            _manage_group1[i],
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
