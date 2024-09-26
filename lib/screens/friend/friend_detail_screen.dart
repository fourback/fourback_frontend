import 'package:flutter/material.dart';

class FriendDetailScreen extends StatelessWidget {
  final String friendName;
  final String school;
  final String major;

  const FriendDetailScreen({
    super.key,
    required this.friendName,
    required this.school,
    required this.major,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '프로필',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.3, // 30% of the screen height
                child: Center(
                  child: Stack(
                    children: [
                      // 임시 프로필 이미지 표시
                      CircleAvatar(
                        radius: 80, // 160x160 크기 설정
                        backgroundColor: Colors.grey[300], // 임시 배경색
                        child: Icon(
                          Icons.person, // 사람 아이콘 사용
                          size: 80,
                          color: Colors.white, // 아이콘 색상
                        ),
                      ),
                      // 이미지 선택 또는 삭제 버튼
                      Positioned(
                        bottom: 0, // 하단 중앙에 배치
                        right: 0,
                        child: IconButton(
                          onPressed: () {}, // 임시로 동작하지 않게 설정
                          icon: CircleAvatar(
                            radius: 20, // 아이콘 배경 크기
                            backgroundColor: Color(0xff242760),
                            child: Icon(
                              Icons.camera_alt, // 카메라 아이콘
                              color: Colors.white,
                              size: 24, // 아이콘 크기
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  //받아와야 할 데이터들
                  children: [
                    _buildInfoTile('이름', friendName),
                    _buildInfoTile('이메일', '이메일'),
                    _buildInfoTile('대학교/소속기관', '$school $major'),
                    _buildInfoTile('생년월일', '생년월일'),
                    _buildInfoTile('학과', '학과'),
                    _buildInfoTile('취미', '취미'),
                    _buildInfoTile('희망 직무', '희망 직무'),
                    _buildInfoTile('거주 지역', '거주 지역'),
                    _buildInfoTile('기술 스택', '기술 스택'),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor:
                              const Color.fromARGB(255, 211, 44, 44)),
                          child: const Text(
                            '친구 삭제',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.black),
                          child: const Text(
                            '채팅 시작하기',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to build each info tile with a border
  Widget _buildInfoTile(String title, String data) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, // 테두리 색상 설정
            width: 1.0, // 테두리 두께 설정
          ),
          borderRadius: BorderRadius.circular(8), // 둥근 모서리 설정
        ),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Text(data),
      ),
    );
  }
}