import 'dart:convert';
import 'dart:io';

import 'package:elra/pages/admin_pages/admin_elderpage.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:elra/utils/phapayom.dart';
import 'package:elra/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddElderPage extends StatefulWidget {
  const AddElderPage({super.key});

  @override
  State<AddElderPage> createState() => _AddElderPageState();
}

class _AddElderPageState extends State<AddElderPage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String username = "";

  final _addVolunteerKey = GlobalKey<FormBuilderState>();
  bool isVisible = false;
  String tambon = "";

  @override
  void initState() {
    super.initState();
    tambon = tambonList[0];
    initialvalue();
  }

  void initialvalue() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      username = prefs.getString('name')!;
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
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: drawerAdminMenu(context, name: username),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ผู้ดูแลระบบ"),
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
            child: ListView(
              shrinkWrap: true,
              children: [
                const ListTile(
                  contentPadding: EdgeInsets.only(right: 16),
                  tileColor: Color.fromARGB(255, 2, 128, 170),
                  title: Column(
                    children: [
                      Text(
                        "เพิ่มผู้สูงอายุ",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 233, 233, 233)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    // shrinkWrap: true,
                    children: [
                      FormBuilder(
                        key: _addVolunteerKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "คำนำหน้าชื่อ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            prefixChip(),
                            const SizedBox(height: 16),
                            const Text(
                              "ชื่อ-นามสกุล",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            nameTextInput(),
                            const SizedBox(height: 16),
                            const Text(
                              "Codename",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            codenameTextInput(),
                            const SizedBox(height: 16),
                            const Text(
                              "บ้านเลขที่",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            housenoTextInput(),
                            const SizedBox(height: 16),
                            const Text(
                              "อำเภอ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            amphoeDropdown(),
                            const SizedBox(height: 16),
                            const Text(
                              "ตำบล",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            tambonDropdown(),
                            const SizedBox(height: 24),
                            const Text(
                              "หมู่ที่",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            mooDropdown(),
                            const SizedBox(height: 24),
                            saveButton(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Future<void> addElder() async {
    SharedPreferences prefs = await _prefs;
    if (_addVolunteerKey.currentState!.validate()) {
      var url = Uri.parse("$apiURL/elders");
      var body = jsonEncode({
        "prefix": _addVolunteerKey.currentState!.fields["prefix"]!.value,
        "name": _addVolunteerKey.currentState!.fields["name"]!.value,
        "code_name": _addVolunteerKey.currentState!.fields["codename"]!.value,
        "house_no": _addVolunteerKey.currentState!.fields["houseno"]!.value,
        "amphoe": _addVolunteerKey.currentState!.fields["amphoe"]!.value,
        "tambon": _addVolunteerKey.currentState!.fields["tambon"]!.value,
        "moo": int.parse(_addVolunteerKey.currentState!.fields["moo"]!.value),
      });

      try {
        print(body);
        var response = await http.post(
          url,
          body: body,
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:
                "Bearer ${prefs.getString("token")}"
          },
        );
        print(response.statusCode);
        if (!mounted) return;
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "เพิ่มผู้สูงอายุ",
            text: 'เพิ่มข้อมูลผู้สูงอายุสำเร็จ!',
            onConfirmBtnTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminElderPage(),
                )),
            confirmBtnText: "ตกลง");
      } catch (e) {
        print(e);
        if (!mounted) return;
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "ชื่อผู้ใช้งานซ้ำ",
            text: 'กรุณาตรวจสอบชื่อผู้ใช้งาน',
            confirmBtnText: "ตกลง");
      }
    }
  }

  Widget saveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
            onPressed: () {
              addElder();
            },
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text("เพิ่มผู้สูงอายุ")),
      ],
    );
  }

  FormBuilderDropdown<String> mooDropdown() {
    Map<int, String> moo = mooList[tambon];
    return FormBuilderDropdown(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: "moo",
      items: moo.entries.map((el) {
        return DropdownMenuItem(
            value: el.key.toString(),
            child: Text("หมู่ ${el.key} ${el.value}"));
      }).toList(),
      validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required(errorText: "เลือกหมู่ที่")]),
    );
  }

  FormBuilderDropdown<String> tambonDropdown() {
    return FormBuilderDropdown(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: "tambon",
      initialValue: tambonList[0],
      items: tambonList
          .map((tb) => DropdownMenuItem(
                value: tb,
                child: Text(tb),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          tambon = value!;
        });
      },
    );
  }

  FormBuilderDropdown<String> amphoeDropdown() {
    return FormBuilderDropdown(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: "amphoe",
      initialValue: "ป่าพะยอม",
      items: const [
        DropdownMenuItem(
          value: "ป่าพะยอม",
          child: Text("ป่าพะยอม"),
        )
      ],
    );
  }

  FormBuilderTextField housenoTextInput() {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'houseno',
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        // suffixIcon: _heightHasError
        //     ? const Icon(Icons.error, color: Colors.red)
        //     : const Icon(Icons.check, color: Colors.green),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "ใส่บ้านเลขที่"),
      ]),
    );
  }

  FormBuilderTextField codenameTextInput() {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'codename',
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        // suffixIcon: _heightHasError
        //     ? const Icon(Icons.error, color: Colors.red)
        //     : const Icon(Icons.check, color: Colors.green),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "ใส่รหัสชื่อ"),
      ]),
    );
  }

  FormBuilderTextField nameTextInput() {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'name',
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        // suffixIcon: _heightHasError
        //     ? const Icon(Icons.error, color: Colors.red)
        //     : const Icon(Icons.check, color: Colors.green),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "ใส่ชื่อ-นามสกุล"),
      ]),
    );
  }

  Widget prefixChip() {
    return FormBuilderChoiceChip<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 10,
      name: 'prefix',
      decoration: const InputDecoration(border: InputBorder.none),
      options: const [
        FormBuilderChipOption(
          value: "นาย",
          child: Text('นาย'),
        ),
        FormBuilderChipOption(
          value: "นาง",
          child: Text('นาง'),
        ),
        FormBuilderChipOption(
          value: "นางสาว",
          child: Text('นางสาว'),
        ),
      ],
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "เลือกคำนำหน้าชื่อ"),
      ]),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
