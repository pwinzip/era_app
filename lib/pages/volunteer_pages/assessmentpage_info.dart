import 'package:elra/utils/drawer_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class AssInfoPage extends StatefulWidget {
  const AssInfoPage({super.key});

  @override
  State<AssInfoPage> createState() => _AssInfoPageState();
}

class _AssInfoPageState extends State<AssInfoPage> {
  final _advancedDrawerController = AdvancedDrawerController();

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
                    "ประเมินความเสี่ยงในการทำงาน",
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "สภาพแวดล้อมและปัจจัยคุกคามในการทำงาน ปัจจัยเสี่ยงต่อการทำงานและการจัดการความปลอดภัยในที่ทำงานของผู้สูงอายุ",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(height: 16),
                  criteriaHeader(
                      'เกณฑ์การให้คะแนน ', 'โอกาส', ' การสัมผัสสิ่งคุกคาม'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("0 = ไม่เคยสัมผัส"),
                          Text("1 = สัมผัสน้อย (1 ครั้ง/เดือน)"),
                          Text("2 = สัมผัสปานกลาง (2 ครั้ง/เดือน)"),
                          Text("3 = สัมผัสมาก (ตั้งแต่ 3 ครั้งขึ้นไป/เดือน)"),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 16),
                  criteriaHeader('เกณฑ์การให้คะแนน ', 'ความรุนแรง',
                      ' ของการสัมผัสสิ่งคุกคาม'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("1 = รุนแรงน้อย (ปฐมพยาบาลเบื้องต้น)"),
                          Text(
                              "2 = รุนแรงปานกลาง (หยุดงานไม่เกิน 3 วัน/รักษาตัวเอง)"),
                          Text(
                              "3 = รุนแรงมาก (หยุดงานเกิน 3 วัน/รักษาตัวเอง/รับการรักษาจากถสานพยาบาล)"),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'หมายเหตุ: ',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text:
                                'การจัดการความปลอดภัย (ถ้ามี) สามารถตอบได้มากกว่า 1 ข้อ',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('ย้อนกลับ'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  RichText criteriaHeader(String str1, String boldstr, String str2) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: str1,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
              text: boldstr,
              style: const TextStyle(decoration: TextDecoration.underline)),
          TextSpan(text: str2)
        ],
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
