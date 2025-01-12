
class UserLoginSessions {

  String uID;
  String sessionToken;

  UserLoginSessions({
    required this.uID, 
    required this.sessionToken
    });

  factory UserLoginSessions.fromJson(Map<String, dynamic> json) {
    return UserLoginSessions(
      uID: json['uID'] ?? '',
      sessionToken: json['sessionToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uID': uID,
      'sessionToken': sessionToken,
    };
  }
}

