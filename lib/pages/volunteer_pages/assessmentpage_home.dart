import 'package:elra/pages/volunteer_pages/assessmentpage_one.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_profile.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_result.dart';
import 'package:elra/pages/volunteer_pages/assessmentpage_two.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:elra/utils/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class AssHomePage extends StatefulWidget {
  const AssHomePage({super.key});

  @override
  State<AssHomePage> createState() => _AssHomePageState();
}

class _AssHomePageState extends State<AssHomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final List<bool> _completed = [
    true, // general info
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AssProfile(uid: "uid"),
                              ));
                        },
                        child: createCardMenu("ข้อมูลทั่วไป", _completed[0]),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AssessmentPartOne(),
                              ));
                        },
                        child: createCardMenu(
                            "1. สิ่งแวดล้อมทางกายภาพ", _completed[1]),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AssessmentPartTwo(),
                              ));
                        },
                        child: createCardMenu(
                            "2. สิ่งแวดล้อมทางเคมี", _completed[2]),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AssessmentPartTwo(),
                              ));
                        },
                        child: createCardMenu(
                            "3. สิ่งแวดล้อมทางชีวภาพ", _completed[3]),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AssessmentPartTwo(),
                              ));
                        },
                        child: createCardMenu("4. การยศาสตร์", _completed[4]),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AssessmentPartTwo(),
                              ));
                        },
                        child:
                            createCardMenu("5. จิตวิทยาสังคม", _completed[5]),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AssessmentPartTwo(),
                              ));
                        },
                        child: createCardMenu(
                            "6. ความเสี่ยงในการบาดเจ็บหรือเกิดอุบัติเหตุ",
                            _completed[6]),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AssessmentPartTwo(),
                              ));
                        },
                        child: createCardMenu(
                            "7. ความเสี่ยงในการเกิดไฟไหม้หรือสารเคมีรั่วไหล",
                            _completed[7]),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AssessmentPartTwo(),
                              ));
                        },
                        child: createCardMenu("8. คุณภาพอากาศ", _completed[8]),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AssessmentResult(),
                                ));
                          },
                          child: const Text("ส่งข้อมูล")),
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
