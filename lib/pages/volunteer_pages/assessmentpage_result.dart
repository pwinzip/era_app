import 'package:elra/utils/drawer_components.dart';
import 'package:elra/utils/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AssessmentResult extends StatefulWidget {
  const AssessmentResult({super.key});

  @override
  State<AssessmentResult> createState() => _AssessmentResultState();
}

class _AssessmentResultState extends State<AssessmentResult> {
  final _advancedDrawerController = AdvancedDrawerController();

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
                    "ผู้สูงอายุ ชื่อ นามสกุล",
                    style: TextStyle(fontSize: 16, color: Color(0xFF656363)),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 8),
                createCustomGauge(
                    title: "การประเมินความเสี่ยงภาพรวม", value: 4.29),
                createCustomGauge(title: "1. สิ่งแวดล้อมทางกายภาพ", value: 4.6),
                createCustomGauge(title: "2. สิ่งแวดล้อมทางเคมี", value: 6.2),
                createCustomGauge(title: "3. สิ่งแวดล้อมทางชีวภาพ", value: 2.5),
                createCustomGauge(title: "4. การยศาสตร์", value: 3.9),
                createCustomGauge(title: "5. จิตวิทยาสังคม", value: 7.4),
                createCustomGauge(
                    title: "6. ความเสี่ยงในการบาดเจ็บหรือเกิดอุบัติเหตุ",
                    value: 3.1),
                createCustomGauge(
                    title: "7. ความเสี่ยงในการเกิดไฟไหม้หรือสารเคมีรั่วไหล",
                    value: 4.5),
                createCustomGauge(title: "8. คุณภาพอากาศ", value: 2.1),
              ],
            ),
          ),
        ),
      ),
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
                textStyle:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
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
                            child: Text("$value",
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
