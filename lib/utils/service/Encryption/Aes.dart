import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:hospitize/model/AllUserData.dart';
import 'package:hospitize/model/EncryptedAllUserData.dart';
import 'package:hospitize/utils/service/Hashing/hashlib.dart';

class AesAlgo {
  static Object? EncryptDecrypt({
    UserAllData? allData,
    UserAllDataEncrypted? allEncryptData,
    bool encryptMode = false,
    bool decryptMode = false,
    bool isGenerateNewKey = false
  }){
    encrypt.Key? key;
    encrypt.IV? iv;
    encrypt.Encrypter? encrypter;
    encrypt.Encrypter? decrypter;

    if(isGenerateNewKey){
      final salt = HashAlgorithm.generateRandomString(32);
      key = encrypt.Key.fromUtf8(salt);
      iv = encrypt.IV.fromLength(16);
    }
    debugPrint("Generated IV: ${iv?.base64}");

    if(encryptMode){
      if(allData != null && key != null && iv != null){

        encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

        if(allData.uName != '' && allData.uBirth != '' && allData.uSSN != ''){
          final uNameEnc = encrypter.encrypt(allData.uName, iv: iv);
          final uBirthEnc = encrypter.encrypt(allData.uBirth, iv: iv);
          final uSSNEnc = encrypter.encrypt(allData.uSSN, iv: iv);

          return UserAllDataEncrypted(uNameEnc: uNameEnc.base64, uMail: allData.uMail, uBirthEnc: uBirthEnc.base64, uSSNEnc: uSSNEnc.base64, encKey: key.base64, encIv: iv.base64);
        }
      }
    }else if(decryptMode){
      if(allEncryptData !=null)
      {
        final key = encrypt.Key.fromBase64(allEncryptData.encKey ?? '');
        final iv = encrypt.IV.fromBase64(allEncryptData.encIv ?? '');

        decrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

        if(allEncryptData.uNameEnc != '' && allEncryptData.uBirthEnc != '' && allEncryptData.uSSNEnc != ''){
          final uNameEnc = encrypt.Key.fromBase64(allEncryptData.uNameEnc);
          final uBirthEnc = encrypt.Key.fromBase64(allEncryptData.uBirthEnc);
          final uSSNEnc = encrypt.Key.fromBase64(allEncryptData.uSSNEnc);

          final uNameDec = decrypter.decrypt(uNameEnc, iv: iv);
          final uBirthDec = decrypter.decrypt(uBirthEnc, iv: iv);
          final uSSNDec = decrypter.decrypt(uSSNEnc, iv: iv);

          return UserAllData(uName: uNameDec, uMail: allEncryptData.uMail, uBirth: uBirthDec, uSSN: uSSNDec);
        }else{
          return UserAllData(uName: '', uMail: allEncryptData.uMail, uBirth: '', uSSN: '');
        }
      }
    }
    return null;
  }
}