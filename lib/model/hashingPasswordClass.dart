
class UserPassHash {

  final String hash;
  final String key;

  UserPassHash({
    required this.hash, 
    required this.key
    });

  factory UserPassHash.fromJson(Map<String, dynamic> json) {
    return UserPassHash(
      hash: json['hash'] ?? '',
      key: json['key'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'key': key,
    };
  }
}

