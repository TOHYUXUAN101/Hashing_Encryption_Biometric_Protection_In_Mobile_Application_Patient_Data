
class UserAllDataEncrypted {

  final String uNameEnc;
  final String uBirthEnc;
  final String uMail;
  final String uSSNEnc;
  final String? encKey;
  final String? encIv;

  UserAllDataEncrypted({
    required this.uNameEnc, 
    required this.uBirthEnc,
    required this.uMail,
    required this.uSSNEnc,
    this.encKey,
    this.encIv
    });

  factory UserAllDataEncrypted.fromJson(Map<String, dynamic> json) {
    return UserAllDataEncrypted(
      uNameEnc: json['uNameEnc'] ?? '',
      uBirthEnc: json['uBirthEnc'] ?? '',
      uMail: json['uMail'] ?? '',
      uSSNEnc: json['uSSNEnc'] ?? '',
      encKey: json['encKey'] ?? '',
      encIv: json['encIv'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uNameEnc': uNameEnc,
      'uBirthEnc': uBirthEnc,
      'uMail': uMail,
      'uSSNEnc': uSSNEnc,
      'encKey': encKey,
      'encIv': encIv,
    };
  }
}

