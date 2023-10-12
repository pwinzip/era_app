import 'package:elra/utils/drawer_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AssProfile extends StatefulWidget {
  const AssProfile({super.key, required this.uid});

  final String uid;

  @override
  State<AssProfile> createState() => _AssProfileState();
}

class _AssProfileState extends State<AssProfile> {
  final _advancedDrawerController = AdvancedDrawerController();
  final _formKey = GlobalKey<FormBuilderState>();
  bool _ageHasError = false;
  bool _workPeriodHasError = false;
  bool _houseMemberHasError = false;
  bool _aliveMemberHasError = false;
  bool _incomeHasError = false;
  bool _educationHasError = false;
  bool _weightHasError = false;
  bool _heightHasError = false;

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

  void _onChangedGender(dynamic val) {
    print("errrr");
    debugPrint(val.toString());
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
              // decoration:
              //     BoxDecoration(border: Border.all(style: BorderStyle.solid)),
              child: Column(
                // shrinkWrap: true,
                children: [
                  const Text(
                    "ข้อมูลทั่วไป",
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "ชื่อ นามสกุล",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "ที่อยู่",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        genderRadio(),
                        ageTextInput(),
                        weightTextInput(),
                        heightTextInput(),
                        incomeDropdown(),
                        careerChip(),
                        educationDropdown(),
                        marriageRadio(),
                        housememberTextInput(),
                        alivememberTextInput(),
                        workperiodTextInput(),
                        workhourDropdown(),
                        actionButton()
                      ],
                    ),
                  ),
                ],
              ),
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
        ElevatedButton(
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
          child: const Text("ย้อนกลับ"),
        ),
        ElevatedButton(
          onPressed: () {
            // save to database
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
          child: const Text("บันทึก"),
        ),
      ],
    );
  }

  FormBuilderDropdown<String> workhourDropdown() {
    return FormBuilderDropdown<String>(
      // autovalidateMode: AutovalidateMode.always,
      name: 'work_hour',
      decoration: InputDecoration(
        labelText: 'ระยะเวลาการทำงานวันละ (ชั่วโมง)',
        suffix: _educationHasError
            ? const Icon(Icons.error)
            : const Icon(Icons.check),
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
        labelText: 'อายุงาน',
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
      name: 'alive_member',
      decoration: InputDecoration(
        labelText: 'จำนวนบุตรที่มีชีวิต (ถ้ามี)',
        suffixText: "คน",
        suffixIcon: _aliveMemberHasError
            ? const Icon(Icons.error, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
      ),
      onChanged: (val) {
        setState(() {
          _aliveMemberHasError =
              !(_formKey.currentState?.fields['alive_member']?.validate() ??
                  false);
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
        labelText: 'จำนวนสมาชิกในครอบครัวที่อยู่ปัจจุบัน',
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
      decoration: const InputDecoration(
        labelText: 'สถานะ',
      ),
      initialValue: null,
      name: 'status',
      onChanged: _onChangedGender,
      validator:
          FormBuilderValidators.compose([FormBuilderValidators.required()]),
      options: ['โสด', 'สมรส', 'หย่าร้าง', 'คู่สมรมเสียชีวิต']
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
        labelText: 'การศึกษาสูงสุด',
        suffix: _educationHasError
            ? const Icon(Icons.error)
            : const Icon(Icons.check),
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
      decoration: const InputDecoration(
          labelText: 'เลือกอาชีพปัจจุบัน (เลือกได้มากกว่า 1 อาชีพ)'),
      name: 'career',
      selectedColor: const Color(0xFFFE965F),
      spacing: 4,
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
      onChanged: _onChangedGender,
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
        labelText: 'รายได้',
        suffix:
            _incomeHasError ? const Icon(Icons.error) : const Icon(Icons.check),
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
        labelText: 'ส่วนสูง',
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
        labelText: 'น้ำหนัก',
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
      // autovalidateMode: AutovalidateMode.always,
      name: 'age',
      decoration: InputDecoration(
        labelText: 'อายุ',
        suffixText: "ปี",
        suffixIcon: _ageHasError
            ? const Icon(Icons.error, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
      ),
      onChanged: (val) {
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
      decoration: const InputDecoration(
        labelText: 'เพศ',
      ),
      initialValue: "ชาย",
      name: 'gender',
      onChanged: _onChangedGender,
      validator:
          FormBuilderValidators.compose([FormBuilderValidators.required()]),
      options: ['ชาย', 'หญิง']
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
