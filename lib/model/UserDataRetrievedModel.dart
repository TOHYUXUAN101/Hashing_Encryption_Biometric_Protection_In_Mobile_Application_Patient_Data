
class UserDataRetrieve {

  final String uID;
  final String uMail;
  final String uKey;
  final String uPassHashed;
  final bool uIsValidated;
  final String uDeviceID;

  UserDataRetrieve({
    required this.uID, 
    required this.uMail, 
    required this.uKey,
    required this.uPassHashed,
    required this.uIsValidated,
    required this.uDeviceID
    });

  factory UserDataRetrieve.fromJson(Map<String, dynamic> json) {
    return UserDataRetrieve(
      uID: json['uID'] ?? '',
      uMail: json['uMail'] ?? '',
      uKey: json['uKey'] ?? '',
      uPassHashed: json['uPassHashed'] ?? '',
      uIsValidated: json['uIsValidated'] ?? '',
      uDeviceID: json['uDeviceID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uID': uID,
      'uMail': uMail,
      'ukey': uKey,
      'uPassHashed': uPassHashed,
      'uIsValidated': uIsValidated,
      'uDeviceID': uDeviceID,
    };
  }
}

