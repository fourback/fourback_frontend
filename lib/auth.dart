import 'package:bemajor_frontend/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '/api_url.dart';
import 'package:flutter/material.dart';



Future<String?> readAccess() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('USERID');
}

Future<String?> readRefresh() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('REFRESH');
}

void registerAccess(String access) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('USERID', access);
}

void registerRefresh(String refresh) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('REFRESH', refresh);
}

Future<void> removeAccess() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('USERID'); // USERID 토큰 삭제
}

Future<void> removeRefresh() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('REFRESH'); // REFRESH 토큰 삭제
}


Future<bool> reissueToken(BuildContext context) async { //토큰 재발급
  try {
    print("reissueToken");
    String? refreshToken = await readRefresh();
    String? accessToken = await readAccess();


    final reissueResponse = await http.post(
      Uri.parse('${ApiUrl.baseUrl}/reissue'),
      headers: {
        'refresh': '$refreshToken',
        'access': '$accessToken',
      },
    );

    if(reissueResponse.statusCode == 200) { //토큰 재발급 성공
      String? access;
      String? refresh;

      access = reissueResponse.headers['access'];
      refresh = reissueResponse.headers['refresh'];


      registerAccess(access!);
      registerRefresh(refresh!);
      print("재발급성공");
      return true;

    } else {
      print("상태 코드 : ${reissueResponse.statusCode}");
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
        );
      }
      return false;
    }
  } catch(e) {
    print('Error: $e');
    return false;
  }

}