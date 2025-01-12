import 'dart:math';
import 'package:hashlib/hashlib.dart';
import 'package:hospitize/model/hashingPasswordClass.dart';

class HashAlgorithm {

  static String generateRandomString(int length){
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rand = Random.secure();
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      buffer.write(chars[rand.nextInt(chars.length)]);
    }

    return buffer.toString();
  }
  
  static UserPassHash hashPassword({
    required String userInput
    }){
    String input = userInput;
    String key = generateRandomString(32);

    final salt = key.codeUnits;

    String hashedValue = (HMAC(sha3_512).by(salt).string(input)).toString();

    //Store key and hashedValue to UserPassHash
    UserPassHash userPassHash = UserPassHash(hash: hashedValue, key: key);

    return userPassHash;
  }

  static String hashLoginPassword({
    required String userInput,
    required String hashKey
    }){
    String input = userInput;
    String key = hashKey;

    final salt = key.codeUnits;

    String hashedValue = (HMAC(sha3_512).by(salt).string(input)).toString();

    return hashedValue;
  }
}