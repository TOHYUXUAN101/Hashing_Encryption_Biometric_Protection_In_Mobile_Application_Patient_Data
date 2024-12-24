
class UserAllData {

  final String uName;
  final String uBirth;
  final String uMail;
  final String uSSN;

  UserAllData({
    required this.uName, 
    required this.uBirth,
    required this.uMail,
    required this.uSSN
    });

  factory UserAllData.fromJson(Map<String, dynamic> json) {
    return UserAllData(
      uName: json['uName'] ?? '',
      uBirth: json['uBirth'] ?? '',
      uMail: json['uMail'] ?? '',
      uSSN: json['uSSN'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uName': uName,
      'uBirth': uBirth,
      'uMail': uMail,
      'uSSN': uSSN,
    };
  }
}

