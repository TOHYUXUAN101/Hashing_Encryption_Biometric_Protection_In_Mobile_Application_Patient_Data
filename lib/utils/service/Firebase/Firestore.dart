import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospitize/model/EncryptedAllUserData.dart';
import 'package:hospitize/model/UserDataRetrievedModel.dart';
import 'package:hospitize/model/hashingPasswordClass.dart';
import 'package:hospitize/utils/constant/color.dart';
import 'package:hospitize/utils/constant/screenUtils.dart';

class FireStore {
  static Future<bool> register({
    required BuildContext context, 
    required String userEmail, 
    required UserPassHash userHashed
  }) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference user = db.collection('User');

    try {
      
      DocumentReference docRef = await user.add({
        'UserEmail': userEmail,
        'UserPassHash': userHashed.hash,
        'UserPassHashkey': userHashed.key,
        'UserIsValidate': false,
        'UserName': '',
        'UserBirth': '',
        'UserSSN': '',
        'UserInfoEncKey':'',
        'UserInfoEncIV':''
      });

      await docRef.update({
        'UserID': docRef.id,
      });

      debugPrint("User registered with ID: ${docRef.id}");
      return true;
    } catch (error) {
      debugPrint("Failed to register user: $error");
      ScreenUtils.showCupertinoAlertDialog(
        context,
        "Error",
        "Failed to register user: $error",
      );

      return false;
    }
  }

  static Future<bool> validateUser({
    required BuildContext context,
    required String uID,
    bool isValidate = false,
  }) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference user = db.collection('User');

    try {
      await user.doc(uID).update({
        'UserIsValidate': isValidate,
      });

      debugPrint("User validated successfully.");
      Fluttertoast.showToast(
        msg: "User successfully registered",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorManager.green,
        textColor: ColorManager.black,
        fontSize: 16.0
      );
      return true;
    } catch (error) {
      debugPrint("Failed to validate user ID: $error");
      return false;
    }
  }

  static bool signIn({
    required BuildContext context, 
    required String userEmail, 
    required String userNewlyHashed,
    required String userPreviouslyHashed,
    required bool userIsValidated
  }){

    if(userNewlyHashed == userPreviouslyHashed && userIsValidated){
      return true;
    }
    else if(userNewlyHashed != userPreviouslyHashed){
      ScreenUtils.showCupertinoAlertDialog(
        context, 

        "Error",
        "Wrong Email or Password"
      );
      return false;
    }else{
      ScreenUtils.showCupertinoAlertDialog(
        context, 

        "Error",
        "User Not Validated By Biometric"
      );
      return false;
    }
  }

  static Future<UserDataRetrieve?> getUserCredential({
    required BuildContext context, 
    required String userEmail
  }) async {
      
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference userCollection = db.collection('User');
    
    try {
      QuerySnapshot snapshot = await userCollection.get();

      for (var doc in snapshot.docs) {
        String docUserEmail = doc['UserEmail'];
        debugPrint("here->> $docUserEmail");
        String docUserID = doc['UserID'];
        debugPrint("here->> $docUserID");
        if (docUserEmail == userEmail) {
          String docUserHashKey = doc['UserPassHashkey'];
          debugPrint("here->> $docUserHashKey");
          String docUserHash = doc['UserPassHash'];
          debugPrint("here->> $docUserHash");
          bool docUserValidated = doc['UserIsValidate'];
          debugPrint("here is null? ${docUserValidated.toString()}");
          
          UserDataRetrieve userDataRetrieve = UserDataRetrieve(uID: docUserID, uMail: docUserEmail, uKey: docUserHashKey, uPassHashed: docUserHash, uIsValidated: docUserValidated);

          return userDataRetrieve;
        }
      }

      ScreenUtils.showCupertinoAlertDialog(
        context, 
        "Error",
        "User Not Existed",
      );
      throw Exception('User with the email $userEmail not found.');
    } catch (e) {
      return null;
    }
  }

  static Future<bool> checkExistingUser({
    required BuildContext context, 
    required String userEmail
  }) async {
    
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference userCollection = db.collection('User');
    
    QuerySnapshot snapshot = await userCollection.get();

    for (var doc in snapshot.docs) {
      String docUserEmail = doc['UserEmail'];
        
      if(docUserEmail.isEmpty){
        return true;
      }

      if (docUserEmail == userEmail) {
        return false;
      }
    }
    return true;
  }

  static void deleteUserData({
    required BuildContext context,
    required String uID,
  }) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference userCollection = db.collection('User');

    try {
      // Attempt to delete the user document with the given uID
      await userCollection.doc(uID).delete();
      debugPrint("Deleted user data");
    } catch (e) {
      // Handle error and show an error message
      debugPrint("Error deleting user data: $e");
    }
  }

  static Future<void> updateUserData({required String userID, required UserAllDataEncrypted allEncData}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference userCollection = db.collection('User');
    
    await userCollection.doc(userID).update({
      'UserSSN': allEncData.uSSNEnc,
      'UserName': allEncData.uNameEnc,
      'UserBirth': allEncData.uBirthEnc,
      'UserInfoEncKey': allEncData.encKey,
      'UserInfoEncIV': allEncData.encIv,
      'UserEmail': allEncData.uMail
    });
  }

  static Future<UserAllDataEncrypted?> getUserAllCredential({
    required BuildContext context, 
    required String userID
  }) async {
      
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference userCollection = db.collection('User');
    String docUserInfoEncKey ='';
    String docUserInfoEncIv ='';
    QuerySnapshot querySnapshot = await userCollection.where('UserID', isEqualTo: userID).get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        String docUserEmail = doc['UserEmail'];
        String docUserName = doc['UserName'];
        String docUserBirth = doc['UserBirth'];
        String docUserSSN = doc['UserSSN'];
        
        if(doc['UserInfoEncKey'] != null && doc['UserInfoEncIV'] != null){
          docUserInfoEncKey = doc['UserInfoEncKey'];
          docUserInfoEncIv = doc['UserInfoEncIV'];
        }
        
        return UserAllDataEncrypted(
          uNameEnc: docUserName, 
          uBirthEnc: docUserBirth, 
          uMail: docUserEmail, 
          uSSNEnc: docUserSSN,
          encKey: docUserInfoEncKey,
          encIv: docUserInfoEncIv
        );
      }
    } else {
      return null;
    }
    return null;
    
    
  }

  static Future<void> updateUserPassword({
    required BuildContext context,
    required String userID,
    required String newPassHash,
    required String newPassHashKey,
  }) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference userCollection = db.collection('User');

    await userCollection.doc(userID).update({
      'UserPassHash': newPassHash,
      'UserPassHashkey': newPassHashKey,
    });
  }

  static bool checkReusePassword({
    required BuildContext context,
    required String oldPassHashBySameKey,
    required String newPassHashBySameKey
  }){
    if(oldPassHashBySameKey == newPassHashBySameKey){
      ScreenUtils.showCupertinoAlertDialog(
        context, 
        "Password Reuse Policy",
        "Password Must Not Same as Previous",
      );
      return false;
    }
    return true;
  }

  static Future<bool?> isUserValidated({
    required BuildContext context,
    required String userEmail,
  }) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference userCollection = db.collection('User');
    
    QuerySnapshot snapshot = await userCollection.get();

    for (var doc in snapshot.docs) {
      String docUserEmail = doc['UserEmail'];

      if (docUserEmail == userEmail) {
        bool docUserValidated = doc['UserIsValidate'];
        if(docUserValidated){
          ScreenUtils.showCupertinoAlertDialog(
            context, 
            "Email Account Already Used",
            "Change a new email to register"
          );
          return true;
        }else{
          return false;
        }
      }
    }
    return null;
  }
}