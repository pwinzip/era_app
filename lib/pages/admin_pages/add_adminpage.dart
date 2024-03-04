import 'dart:convert';
import 'dart:io';

import 'package:elra/pages/admin_pages/admin_homepage.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:elra/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAdminPage extends StatefulWidget {
  const AddAdminPage({super.key});

  @override
  State<AddAdminPage> createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String username = "";

  final _addAdminKey = GlobalKey<FormBuilderState>();
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
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
          backgroundColor: const Color.fromARGB(255, 138, 197, 245),
          title: const Text("เพิ่มผู้ดูแลระบบ"),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    // shrinkWrap: true,
                    children: [
                      FormBuilder(
                        key: _addAdminKey,
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
                              "ชื่อผู้ใช้งานที่ใช้เข้าสู่ระบบ (Username)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            usernameTextInput(),
                            const SizedBox(height: 16),
                            const Text(
                              "รหัสผ่าน",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            passwordTextInput(),
                            const SizedBox(height: 16),
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

  Future<void> addAdmin() async {
    SharedPreferences prefs = await _prefs;
    if (_addAdminKey.currentState!.validate()) {
      var url = Uri.parse("$apiURL/admins");
      var body = jsonEncode({
        "prefix": _addAdminKey.currentState!.fields["prefix"]!.value,
        "name": _addAdminKey.currentState!.fields["name"]!.value,
        "username": _addAdminKey.currentState!.fields["username"]!.value,
        "password": _addAdminKey.currentState!.fields["password"]!.value
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
            title: "เพิ่มผู้ดูแลระบบ",
            text: 'เพิ่มข้อมูลผู้ดูแลระบบสำเร็จ!',
            onConfirmBtnTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHomePage(),
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
              addAdmin();
            },
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text("เพิ่มผู้ดูแลระบบ")),
      ],
    );
  }

  FormBuilderTextField passwordTextInput() {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'password',
      obscureText: !isVisible,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        suffixIcon: isVisible
            ? IconButton(
                icon: const Icon(Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        // suffixIcon: _heightHasError
        //     ? const Icon(Icons.error, color: Colors.red)
        //     : const Icon(Icons.check, color: Colors.green),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "ใส่รหัสผ่าน"),
      ]),
    );
  }

  FormBuilderTextField usernameTextInput() {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'username',
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9_.]"))
      ],
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        // suffixIcon: _heightHasError
        //     ? const Icon(Icons.error, color: Colors.red)
        //     : const Icon(Icons.check, color: Colors.green),
      ),
      validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required(errorText: "ใส่ชื่อผู้ใช้งาน")]),
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
      alignment: WrapAlignment.start,
      spacing: 4,
      runSpacing: 15,
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
