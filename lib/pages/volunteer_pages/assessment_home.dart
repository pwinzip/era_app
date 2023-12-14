import 'package:elra/pages/volunteer_pages/assessment_one_page.dart';
import 'package:elra/pages/volunteer_pages/assessment_profile.dart';
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
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
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
                    "ผู้สูงอายุ ชื่อ นามสกุล",
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
                      createMenu(
                        "ข้อมูลทั่วไป",
                        MaterialPageRoute(
                          builder: (context) => const AssProfile(uid: "u0001"),
                        ),
                        _completed[0],
                      ),
                      createMenu(
                        "1. สิ่งแวดล้อมทางกายภาพ",
                        MaterialPageRoute(
                          builder: (context) => const AssessmentPartOne(),
                        ),
                        _completed[1],
                      ),
                      createMenu(
                        "2. สิ่งแวดล้อมทางเคมี",
                        MaterialPageRoute(
                          builder: (context) => const AssessmentPartOne(),
                        ),
                        _completed[2],
                      ),
                      createMenu(
                        "3. สิ่งแวดล้อมทางชีวภาพ",
                        MaterialPageRoute(
                          builder: (context) => const AssessmentPartOne(),
                        ),
                        _completed[3],
                      ),
                      createMenu(
                        "4. การยศาสตร์",
                        MaterialPageRoute(
                          builder: (context) => const AssessmentPartOne(),
                        ),
                        _completed[4],
                      ),
                      createMenu(
                        "5. จิตวิทยาสังคม",
                        MaterialPageRoute(
                          builder: (context) => const AssessmentPartOne(),
                        ),
                        _completed[5],
                      ),
                      createMenu(
                        "6. ความเสี่ยงในการบาดเจ็บหรือเกิดอุบัติเหตุ",
                        MaterialPageRoute(
                          builder: (context) => const AssessmentPartOne(),
                        ),
                        _completed[6],
                      ),
                      createMenu(
                        "7. ความเสี่ยงในการเกิดไฟไหม้หรือสารเคมีรั่วไหล",
                        MaterialPageRoute(
                          builder: (context) => const AssessmentPartOne(),
                        ),
                        _completed[7],
                      ),
                      createMenu(
                        "8. คุณภาพอากาศ",
                        MaterialPageRoute(
                          builder: (context) => const AssessmentPartOne(),
                        ),
                        _completed[8],
                      ),
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

  InkWell createMenu(
      String title, MaterialPageRoute materialPageRoute, bool enable) {
    return InkWell(
      onTap: () {
        Navigator.push(context, materialPageRoute);
      },
      child: Card(
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
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
