/*class UserInfo {
  UserInfo({
    required this.userID,
  });

  final String userID;
}*/
class UserInfo {
  UserInfo(
      {required this.userName,
        required this.email,
        required this.birth,
        required this.belong,
        required this.department,
        required this.hobby,
        required this.objective,
        required this.address,
        required this.techStack});

  final String userName;
  final String email;
  final String birth;
  final String belong;
  final String department;
  final String hobby;
  final String objective;
  final String address;
  final String techStack;

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userName: json['userName'],
      email:json['email'],
      birth:json['birth'],
      belong:json['belong'],
      department:json['department'],
      hobby:json['hobby'],
      objective:json['objective'],
      address:json['address'],
      techStack:json['techStack'],
    );
  }
}



