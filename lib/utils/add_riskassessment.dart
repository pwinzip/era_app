import 'dart:io';

import 'package:elra/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

Future<void> addRiskAssessment(
  int assid,
  String jsonBody,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(jsonBody);
  print(assid);
  var url = Uri.parse("$apiURL/addriskassessments/$assid");
  var response = await http.post(url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${prefs.getString("token")}"
      },
      body: jsonBody);
  print(response.statusCode);
}
