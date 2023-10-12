import 'package:elra/pages/volunteer_pages/assessment_home.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class VolunteerHomePage extends StatefulWidget {
  const VolunteerHomePage({super.key});

  @override
  State<VolunteerHomePage> createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends State<VolunteerHomePage> {
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
              // decoration:
              //     BoxDecoration(border: Border.all(style: BorderStyle.solid)),
              child: ListView(
                shrinkWrap: true,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // topCard(),
                  // const Padding(
                  //   padding: EdgeInsets.only(bottom: 16),
                  //   child: Text(
                  //     "รายชื่อผู้สูงอายุ",
                  //     style:
                  //         TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  //   ),
                  // ),
                  // Future builder list of elder
                  elderList(),
                  elderList(),
                  elderList(),
                  elderList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget elderList() {
    return Card(
      child: ListTile(
        onTap: () {},
        title: const Text("ชื่อ นามสกุล"),
        trailing: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFFFD937D))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AssHomePage(),
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
