import 'dart:convert';

import 'package:flutter/material.dart';

import '../../api_url.dart';
import '../../auth.dart';
import 'package:http/http.dart' as http;

import '../../models/friendApply.dart';
import '../../models/friendApplyInfo.dart';

class FriendAlarmScreen extends StatefulWidget {
  const FriendAlarmScreen({super.key});

  @override
  State<FriendAlarmScreen> createState() => _FriendAlarmScreenState();
}

class _FriendAlarmScreenState extends State<FriendAlarmScreen> {
  List<FriendApplyInfo> appliesResult = [];

  @override
  void initState() {
    super.initState();
    // 화면이 로드될 때 친구 요청 목록을 불러옴
    fetchFriendApplyInfo();
  }

  Future<void> fetchFriendApplyInfo() async {
    String? token = await readAccess();

    final response = await http.get(
      Uri.parse('${ApiUrl.baseUrl}/api/friend/apply'), // 사용자 ID 없이 호출
      headers: {
        'access': '$token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);

      setState(() {
        List<dynamic> jsonData = jsonMap['result'];
        appliesResult =
            jsonData.map((data) => FriendApplyInfo.fromJson(data)).toList();
      });
    } else if(response.statusCode == 401) {
      bool success = await reissueToken(context);
      if(success) {
        await fetchFriendApplyInfo();
      } else {
        print('토큰 재발급 실패');
      }
    }

  }

  Future<void> acceptFriendApply(String applyId) async {
    String? token = await readAccess();

    final response = await http.post(
      Uri.parse('${ApiUrl.baseUrl}/api/friend/apply/$applyId'), // ApplyId를 URI에 포함
      headers: {
        'access': '$token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // 수락한 친구 요청을 목록에서 제거
      setState(() {
        appliesResult.removeWhere((apply) => apply.applyId.toString() == applyId);
      });
    } else if(response.statusCode == 401) {
      bool success = await reissueToken(context);
      if(success) {
        await acceptFriendApply(applyId);
      } else {
        print('토큰 재발급 실패');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _friendalarmAppbar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: appliesResult.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xff22172A),
                          width: 0.3,
                        ),
                      ),
                    ),
                    height: deviceHeight * 0.2, // 타일 크기 조정
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 30, // 프로필 이미지 크기 설정
                            ),
                            SizedBox(width: 15), // 프로필 이미지와 텍스트 간격
                            Text(
                              appliesResult[index].friendName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40), // 프로필과 수락 버튼 간격
                        Align(
                          alignment: Alignment.center, // 버튼을 가운데 정렬
                          child: SizedBox(
                            width: double.infinity, // 버튼의 너비를 늘림
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0), // 좌우 여백 설정
                              child: GestureDetector(
                                onTap: () {
                                  _showAcceptDialog(context, appliesResult[index].friendName, appliesResult[index].applyId);
                                },
                                child: Container(
                                  width: double.infinity, // 버튼 가로 크기를 최대한으로 설정
                                  padding: EdgeInsets.symmetric(vertical: 10), // 세로 크기를 줄임
                                  decoration: BoxDecoration(
                                    color: Colors.black, // 버튼 배경색 검정
                                    borderRadius: BorderRadius.circular(20), // 라운드 처리
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "수락",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white, // 텍스트 색상 흰색
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 수락 버튼 눌렀을 때 팝업 창으로 알림
  void _showAcceptDialog(BuildContext context, String friendName, int applyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("알림"),
        content: Text("$friendName의 친구 요청을 수락했습니다."),
        actions: [
          TextButton(
            onPressed: () {
              acceptFriendApply(applyId.toString()); // applyId를 String으로 변환하여 전달
              Navigator.of(context).pop();
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget _friendalarmAppbar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    scrolledUnderElevation: 0,
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context, true);
      },
    ),
    title: Text(
      "받은 친구 요청",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    ),
    centerTitle: true,
  );
}