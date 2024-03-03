import 'dart:convert';
import 'dart:io';

import 'package:elra/pages/admin_pages/admin_assessment_one.dart';
import 'package:elra/pages/admin_pages/admin_assessmentmain.dart';
import 'package:elra/utils/drawer_components.dart';
import 'package:elra/utils/info.dart';
import 'package:elra/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class AdminAssProfile extends StatefulWidget {
  const AdminAssProfile({super.key, required this.elderid});

  final int elderid;

  @override
  State<AdminAssProfile> createState() => _AdminAssProfileState();
}

class _AdminAssProfileState extends State<AdminAssProfile> {
  final _advancedDrawerController = AdvancedDrawerController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String username = "";
  String eldername = "";
  String elderaddr = "";
  String codename = "";

  final _formKey = GlobalKey<FormBuilderState>();
  bool _ageHasError = true;
  bool _workPeriodHasError = true;
  bool _houseMemberHasError = true;
  bool _aliveMemberHasError = true;
  bool _incomeHasError = true;
  bool _educationHasError = true;
  bool _weightHasError = true;
  bool _heightHasError = true;

  var incomeOptions = [
    'ไม่พอใช้ มีหนี้สิน',
    'ไม่พอใช้ ไม่มีหนี้สิน',
    'พอใช้ มีหนี้สิน',
    'พอใช้ ไม่มีหนี้สิน'
  ];

  var educationOptions = [
    'ไม่ได้เรียนหนังสือ',
    'ประถมศึกษาตอนต้น',
    'ประถมศึกษาตอนปลาย',
    'มัธยมศึกษาตอนต้น',
    'มัธยมศึกษาตอนปลาย/ปวช.',
    'อนุปริญญา/ปวส.',
    'ปริญญาตรี',
    'สูงกว่าปริญญาตรี'
  ];

  var maritalOption = ['โสด', 'สมรส', 'หย่าร้าง', 'คู่สมรมเสียชีวิต'];
  var genderOption = ['ชาย', 'หญิง'];

  void _onChangedGender(dynamic val) {
    print("errrr");
    debugPrint(val.toString());
  }

  void _onChangedCareer(dynamic val) {
    print("career");
    debugPrint(val.toString());
  }

  @override
  void initState() {
    super.initState();
    initialValue();
  }

  void initialValue() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      username = prefs.getString('name')!;
      eldername = prefs.getString('eldername')!;
      elderaddr = prefs.getString('elderaddr')!;
      codename = prefs.getString('codename')!;
    });
    getPersonal();
  }

  Future<void> getPersonal() async {
    SharedPreferences prefs = await _prefs;
    var url = Uri.parse("$apiURL/personalassessment/${widget.elderid}");
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
    });

    var jsonString = jsonDecode(response.body);

    if (jsonString['data'].length > 0) {
      var data = jsonString['data'][0];
      print(data);
      _formKey.currentState?.fields['age']!.didChange(data['age'].toString());
      _formKey.currentState?.fields['weight']!
          .didChange(data['weight'].toString());
      _formKey.currentState?.fields['height']!
          .didChange(data['height'].toString());
      _formKey.currentState?.fields['house_member']!
          .didChange(data['house_member'].toString());
      _formKey.currentState?.fields['children']!
          .didChange(data['children'].toString());
      _formKey.currentState?.fields['work_period']!
          .didChange(data['year_working'].toString());
      _formKey.currentState?.fields['work_hour']!
          .didChange(data['period_working'].toString());

      _formKey.currentState?.fields['income']!
          .didChange(incomeOptions[data['income']]);
      _formKey.currentState?.fields['education']!
          .didChange(educationOptions[data['high_education']]);
      _formKey.currentState?.fields['status']!
          .didChange(maritalOption[data['marital_status']]);

      _formKey.currentState?.fields['career']!
          .didChange(data['career'].map<String>((val) {
        return val.toString();
      }).toList());
    }
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
                ListTile(
                  contentPadding: const EdgeInsets.only(right: 16),
                  // tileColor: const Color(0xFFEAEAEA),
                  title: Column(
                    children: [
                      Text(
                        codename,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF656363)),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        elderaddr,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF656363)),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  "ข้อมูลทั่วไป",
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    // shrinkWrap: true,
                    children: [
                      FormBuilder(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "เพศ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            genderRadio(),
                            const SizedBox(height: 16),
                            const Text(
                              "อายุ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ageTextInput(),
                            const SizedBox(height: 16),
                            const Text(
                              "น้ำหนัก",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            weightTextInput(),
                            const SizedBox(height: 16),
                            const Text(
                              "ส่วนสูง",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            heightTextInput(),
                            const SizedBox(height: 16),
                            const Text(
                              "รายได้",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            incomeDropdown(),
                            const Divider(),
                            const SizedBox(height: 24),
                            const Text(
                              "เลือกอาชีพปัจจุบัน (เลือกได้มากกว่า 1 อาชีพ)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            careerChip(),
                            const SizedBox(height: 24),
                            const Text(
                              "การศึกษาสูงสุด",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            educationDropdown(),
                            const SizedBox(height: 16),
                            const Text(
                              "สถานะ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            marriageRadio(),
                            const SizedBox(height: 16),
                            const Text(
                              "จำนวนสมาชิกในครอบครัวที่อยู่ปัจจุบัน",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            housememberTextInput(),
                            const SizedBox(height: 16),
                            const Text(
                              "จำนวนบุตรที่มีชีวิต (ถ้ามี)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            alivememberTextInput(),
                            const SizedBox(height: 16),
                            const Text(
                              "อายุงาน",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            workperiodTextInput(),
                            const SizedBox(height: 16),
                            const Text(
                              "ระยะเวลาการทำงานวันละ (ชั่วโมง)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            workhourDropdown(),
                            const SizedBox(height: 24),
                            actionButton(),
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
        ),
      ),
    );
  }

  Future<void> addAssessmentProfile() async {
    SharedPreferences prefs = await _prefs;
    var url = Uri.parse("$apiURL/addpersonalassessment");

    var body = jsonEncode({
      'elder_id': widget.elderid,
      'assessor_id': prefs.getInt("userid"),
      'gender':
          genderOption.indexOf(_formKey.currentState!.fields['gender']!.value),
      'age': int.parse(_formKey.currentState!.fields['age']!.value),
      'weight': int.parse(_formKey.currentState!.fields['weight']!.value),
      'height': int.parse(_formKey.currentState!.fields['height']!.value),
      'income':
          incomeOptions.indexOf(_formKey.currentState!.fields['income']!.value),
      'education': educationOptions
          .indexOf(_formKey.currentState!.fields['education']!.value),
      'marital':
          maritalOption.indexOf(_formKey.currentState!.fields['status']!.value),
      'member': int.parse(_formKey.currentState!.fields['house_member']!.value),
      'children': int.parse(_formKey.currentState!.fields['children']!.value),
      'year_working':
          int.parse(_formKey.currentState!.fields['work_period']!.value),
      'period_working':
          int.parse(_formKey.currentState!.fields['work_hour']!.value),
      'career': _formKey.currentState!.fields['career']!.value,
    });

    var response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
      },
      body: body,
    );
    // print(response.body);
  }

  Widget actionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.arrow_back_ios_new),
          label: const Text("กลับไปหน้าแรก"),
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
            if (_formKey.currentState!.validate()) {
              addAssessmentProfile();
              // if (!mounted) return;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdminAssessmentPartOne(elderid: widget.elderid),
                  ));
            }
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

  FormBuilderDropdown<String> workhourDropdown() {
    return FormBuilderDropdown<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'work_hour',
      decoration: InputDecoration(
        border: InputBorder.none,
        suffix: _educationHasError
            ? const Icon(Icons.error, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
        hintText: 'เลือกระยะเวลาการทำงาน',
      ),
      validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required(errorText: "กรุณาระยะเวลการทำงาน")]),
      items: List<String>.generate(25, (index) => index.toString())
          .map(
            (val) => DropdownMenuItem(
              alignment: AlignmentDirectional.center,
              value: val,
              child: Text(val),
            ),
          )
          .toList(),
      onChanged: (val) {
        setState(() {
          _educationHasError =
              !(_formKey.currentState?.fields['work_hour']?.validate() ??
                  false);
        });
      },
      initialValue: "8",
      valueTransformer: (val) => val?.toString(),
    );
  }

  FormBuilderTextField workperiodTextInput() {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'work_period',
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixText: "ปี",
        suffixIcon: _workPeriodHasError
            ? const Icon(Icons.error, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
      ),
      onChanged: (val) {
        setState(() {
          _workPeriodHasError =
              !(_formKey.currentState?.fields['work_period']?.validate() ??
                  false);
        });
      },
      // valueTransformer: (text) => num.tryParse(text),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "ใส่อายุงาน"),
        FormBuilderValidators.numeric(errorText: "ใส่เฉพาะตัวเลข"),
      ]),
      keyboardType: TextInputType.number,
    );
  }

  FormBuilderTextField alivememberTextInput() {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'children',
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixText: "คน",
        suffixIcon: _aliveMemberHasError
            ? const Icon(Icons.error, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
      ),
      onChanged: (val) {
        setState(() {
          _aliveMemberHasError =
              !(_formKey.currentState?.fields['children']?.validate() ?? false);
        });
      },
      // valueTransformer: (text) => num.tryParse(text),
      initialValue: "0",
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "ใส่จำนวนบุตรที่มีชีิวิต"),
        FormBuilderValidators.numeric(errorText: "ใส่เฉพาะตัวเลข"),
      ]),
      keyboardType: TextInputType.number,
    );
  }

  FormBuilderTextField housememberTextInput() {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'house_member',
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixText: "คน",
        suffixIcon: _houseMemberHasError
            ? const Icon(Icons.error, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
      ),
      onChanged: (val) {
        setState(() {
          _houseMemberHasError =
              !(_formKey.currentState?.fields['house_member']?.validate() ??
                  false);
        });
      },
      // valueTransformer: (text) => num.tryParse(text),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "ใส่จำนวนสมาชิกในครอบครัว"),
        FormBuilderValidators.numeric(errorText: "ใส่เฉพาะตัวเลข"),
      ]),
      keyboardType: TextInputType.number,
    );
  }

  FormBuilderRadioGroup<String> marriageRadio() {
    return FormBuilderRadioGroup<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(border: InputBorder.none),
      initialValue: null,
      name: 'status',
      onChanged: _onChangedGender,
      validator:
          FormBuilderValidators.compose([FormBuilderValidators.required()]),
      options: maritalOption
          .map((status) => FormBuilderFieldOption(
                value: status,
                child: Text(status),
              ))
          .toList(growable: false),
      controlAffinity: ControlAffinity.leading,
    );
  }

  FormBuilderDropdown<String> educationDropdown() {
    return FormBuilderDropdown<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'education',
      decoration: InputDecoration(
        border: InputBorder.none,
        suffix: _educationHasError
            ? const Icon(Icons.error, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
        hintText: 'เลือกการศึกษาสูงสุด',
      ),
      validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required(errorText: "กรุณาการศึกษาสูงสุด")]),
      items: educationOptions
          .map((education) => DropdownMenuItem(
                alignment: AlignmentDirectional.center,
                value: education,
                child: Text(education),
              ))
          .toList(),
      onChanged: (val) {
        setState(() {
          _educationHasError =
              !(_formKey.currentState?.fields['education']?.validate() ??
                  false);
        });
      },
      valueTransformer: (val) => val?.toString(),
    );
  }

  FormBuilderFilterChip<String> careerChip() {
    return FormBuilderFilterChip<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(border: InputBorder.none),
      name: 'career',
      selectedColor: const Color(0xFFFE965F),
      spacing: 4,
      runSpacing: 10,
      options: const [
        FormBuilderChipOption(
          value: '1',
          child: Text("รับจ้างภาคการเกษตร"),
        ),
        FormBuilderChipOption(
          value: '2',
          child: Text("ทำสวน/ทำไร่"),
        ),
        FormBuilderChipOption(
          value: '3',
          child: Text("เลี้ยงสัตว์"),
        ),
        FormBuilderChipOption(
          value: '4',
          child: Text("ลูกจ้าง/พนักงานชั่วคราว"),
        ),
        FormBuilderChipOption(
          value: '5',
          child: Text("รับจ้างตกแต่ง/จัดสวน"),
        ),
        FormBuilderChipOption(
          value: '7',
          child: Text("ทำอาหาร/ทำขนม"),
        ),
        FormBuilderChipOption(
          value: '6',
          child: Text("ทำงานฝีมือ/งานศิลปะ/หัตถกรรม/จักรสาน"),
        ),
        FormBuilderChipOption(
          value: '8',
          child: Text("ขายของชำ/ร้านค้าส่ง/ปลีก"),
        ),
        FormBuilderChipOption(
          value: '9',
          child: Text("รับจ้างทำความสะอาดทั่วไป"),
        ),
        FormBuilderChipOption(
          value: '10',
          child: Text("ซ่อมแซม/ช่างก่อสร้าง"),
        ),
        FormBuilderChipOption(
          value: '11',
          child: Text("ซ่อม/ตัดเย็บเสื้อผ้า"),
        ),
        FormBuilderChipOption(
          value: '12',
          child: Text("ขับรถรับจ้าง/รถโดยสาร"),
        ),
        FormBuilderChipOption(
          value: '13',
          child: Text("รับจ้างเลี้ยงเด็ก"),
        ),
        FormBuilderChipOption(
          value: '14',
          child: Text("ช่างเสริมสวย/ตัดผม"),
        ),
        FormBuilderChipOption(
          value: '15',
          child: Text("งานบริการ"),
        ),
      ],
      onChanged: _onChangedCareer,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.minLength(1,
            errorText: "กรุณาเลือกอาชีพปัจจุบันอย่างน้อย 1 อาชีพ"),
      ]),
    );
  }

  FormBuilderDropdown<String> incomeDropdown() {
    return FormBuilderDropdown<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'income',
      decoration: InputDecoration(
        border: InputBorder.none,
        suffix: _incomeHasError
            ? const Icon(Icons.error, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
        hintText: 'เลือกรายได้',
      ),
      validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required(errorText: "กรุณาเลือกรายได้")]),
      items: incomeOptions
          .map((income) => DropdownMenuItem(
                alignment: AlignmentDirectional.center,
                value: income,
                child: Text(income),
              ))
          .toList(),
      onChanged: (val) {
        setState(() {
          _incomeHasError =
              !(_formKey.currentState?.fields['income']?.validate() ?? false);
        });
      },
      valueTransformer: (val) => val?.toString(),
    );
  }

  FormBuilderTextField heightTextInput() {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'height',
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixText: "เซนติเมตร",
        suffixIcon: _heightHasError
            ? const Icon(Icons.error, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
      ),
      onChanged: (val) {
        setState(() {
          _heightHasError =
              !(_formKey.currentState?.fields['height']?.validate() ?? false);
        });
      },
      // valueTransformer: (text) => num.tryParse(text),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "ใส่ส่วนสูง"),
        FormBuilderValidators.numeric(errorText: "ใส่เฉพาะตัวเลข"),
      ]),
      // initialValue: '12',
      keyboardType: TextInputType.number,
    );
  }

  FormBuilderTextField weightTextInput() {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'weight',
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixText: "กิโลกรัม",
        suffixIcon: _weightHasError
            ? const Icon(Icons.error, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
      ),
      onChanged: (val) {
        setState(() {
          _weightHasError =
              !(_formKey.currentState?.fields['weight']?.validate() ?? false);
        });
      },
      // valueTransformer: (text) => num.tryParse(text),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "ใส่น้ำหนัก"),
        FormBuilderValidators.numeric(errorText: "ใส่เฉพาะตัวเลข"),
        FormBuilderValidators.min(1),
        FormBuilderValidators.max(250),
      ]),
      // initialValue: '12',
      keyboardType: TextInputType.number,
    );
  }

  FormBuilderTextField ageTextInput() {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: 'age',
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixText: "ปี",
        suffixIcon: _ageHasError
            ? const Icon(Icons.error, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
      ),
      onChanged: (value) {
        setState(() {
          _ageHasError =
              !(_formKey.currentState?.fields['age']?.validate() ?? false);
        });
      },
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "ใส่อายุ"),
        FormBuilderValidators.numeric(errorText: "ใส่เฉพาะตัวเลข"),
        FormBuilderValidators.min(45, errorText: "ใส่อายุมากกว่า 45 ปี"),
        FormBuilderValidators.max(250),
      ]),
      keyboardType: TextInputType.number,
    );
  }

  FormBuilderRadioGroup<String> genderRadio() {
    return FormBuilderRadioGroup<String>(
      decoration: const InputDecoration(border: InputBorder.none),
      initialValue: genderOption[0],
      name: 'gender',
      onChanged: _onChangedGender,
      validator:
          FormBuilderValidators.compose([FormBuilderValidators.required()]),
      options: genderOption
          .map((gender) => FormBuilderFieldOption(
                value: gender,
                child: Text(gender),
              ))
          .toList(growable: false),
      controlAffinity: ControlAffinity.leading,
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
