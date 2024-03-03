import 'dart:convert';
import 'dart:io';

import 'package:elra/pages/admin_pages/admin_homepage.dart';
import 'package:elra/pages/volunteer_pages/volunteer_homepage.dart';
import 'package:elra/variables.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController =
      TextEditingController(text: "admin1");
  final TextEditingController passController =
      TextEditingController(text: "212224236");

  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFEB958), Color(0xFFFE965F), Color(0xFFFD937D)],
          ),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  logo(),
                  username(),
                  const SizedBox(height: 12),
                  password(),
                  const SizedBox(height: 18),
                  loginBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.15,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo App
          Text(
            "แอปพลิเคชันประเมินความปลอดภัยของแรงงานผู้สูงอายุ",
            softWrap: true,
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget username() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: usernameController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณาระบุชื่อผู้ใช้งาน";
          }
          return null;
        },
        decoration: const InputDecoration(
          hintText: "ชื่อผู้ใช้งาน",
          filled: true,
          fillColor: Color(0xFFFFFFFF),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          contentPadding: EdgeInsets.all(20),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget password() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: passController,
        validator: (value) {
          if (value!.isEmpty) {
            return "กรุณาระบุรหัสผ่าน";
          }
          return null;
        },
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
            hintText: "รหัสผ่าน",
            filled: true,
            fillColor: const Color(0xFFFFFFFF),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            contentPadding: const EdgeInsets.all(20),
            prefixIcon: const Icon(
              Icons.key,
              color: Colors.black87,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
            )),
      ),
    );
  }

  Widget loginBtn() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "เข้าสู่ระบบ",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          CircleAvatar(
            backgroundColor: const Color(0xFFF4F4F4),
            minRadius: 40,
            child: IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var json = jsonEncode({
                    "username": usernameController.text,
                    "password": passController.text,
                  });

                  var url = Uri.parse("$apiURL/login");
                  // var url = Uri.parse(
                  //     "https://elrabackend.pungpingcoding.online/api/login");

                  var response = await http.post(url, body: json, headers: {
                    HttpHeaders.contentTypeHeader: 'application/json'
                  });

                  // print(response.statusCode);
                  // print(response.body);

                  if (response.statusCode == 200) {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    var userJson = jsonDecode(response.body)['user'];
                    var tokenJson = jsonDecode(response.body)['token'];

                    print(tokenJson);

                    await pref.setInt('userid', userJson['id']);
                    await pref.setString('name', userJson['name']);
                    await pref.setInt('usertype', userJson['user_type']);
                    await pref.setString('token', tokenJson);
                    if (!mounted) return;
                    // Check User Type
                    if (userJson['user_type'] == 0) {
                      // Navigate to Admin HomePage
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminHomePage(),
                          ));
                    } else if (userJson['user_type'] == 1) {
                      // Navigate to Volunteer HomePage
                      var user2Json = jsonDecode(response.body)['user2'];
                      await pref.setInt('moo', user2Json['moo']);
                      await pref.setString('tambon', user2Json['tambon']);
                      await pref.setString('amphoe', user2Json['amphoe']);

                      if (!mounted) return;
                      // setState(() {});

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VolunteerHomePage(),
                          ));
                    }
                  }
                }
              },
              icon: const Icon(Icons.arrow_forward),
              iconSize: 32,
              color: const Color(0xFFFD937D),
            ),
          )
        ],
      ),
      // child: ElevatedButton(
      //   style: ButtonStyle(
      //     backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2274E6)),
      //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //         RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(24),
      //     )),
      //   ),
      //   onPressed: () async {
      //     if (_formKey.currentState!.validate()) {
      //       // Check User Type
      //       // Navigate to Admin HomePage

      //       // Navigate to Volunteer HomePage
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const VolunteerHomePage(),
      //           ));

      //       // User? user = await AuthService.signInWithEmail(
      //       //     email: emailController.text, password: passController.text);
      //       // if (!mounted) return;
      //       // if (user != null) {
      //       //   Navigator.of(context).push(MaterialPageRoute(
      //       //     builder: (context) => const UserHomePage(),
      //       //   ));
      //       // }
      //     }
      //   },
      //   child: const Text('เข้าสู่ระบบ'),
      // ),
    );
  }
}
