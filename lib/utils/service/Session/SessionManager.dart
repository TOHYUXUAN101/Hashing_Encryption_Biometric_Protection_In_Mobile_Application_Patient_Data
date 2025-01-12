import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hospitize/main.dart';
import 'package:hospitize/model/userLoginSessionToken.dart';
import 'package:hospitize/utils/service/Hashing/hashlib.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitize/view/UserLogin.dart';

class SessionManager {
  // Instance of secure storage
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Timer? logoutTimer;

  // Create a new session token
  static String createSession() {
    final sessionToken = HashAlgorithm.generateRandomString(32);
    return sessionToken;
  }

  // Store session in local storage (Secure Storage)
  static Future<void> storeSessionInLocal( String userID, String sessionToken,) async {
  await _secureStorage.write(key: 'sessionToken', value: sessionToken);
  await _secureStorage.write(key: 'userID', value: userID);
}

  // Store session in Firestore
  static Future<void> storeSessionInFireStore(String userID, String sessionToken) async {
    try {
      await _firestore.collection('User').doc(userID).set({
        'sessionToken': sessionToken,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error storing session in Firestore: $e');
    }
  }

  // Destroy session in local storage
  static Future<void> destroySessionInLocal() async {
    await _secureStorage.delete(key: 'sessionToken');
  }

  // Update session in Firestore
  static Future<bool> updateSessionInFireStore({
    required String userID, required String sessionToken
  }) async {
    try {
      await _firestore.collection('User').doc(userID).update({
        'sessionToken': sessionToken,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating session in Firestore: $e');
      return false;
    }
  }

  // Check if session exists in local storage
  static Future<bool> checkSessionInLocal() async {
    String? sessionToken = await _secureStorage.read(key: 'sessionToken');
    return sessionToken != null;
  }

  // Get both sessionToken and userID from local storage
  static Future<UserLoginSessions?> getSessionFromLocal() async {
    String? sessionToken = await _secureStorage.read(key: 'sessionToken');
    String? userID = await _secureStorage.read(key: 'userID');
   
    if (sessionToken != null && userID != null) {
      return UserLoginSessions(sessionToken: sessionToken, uID: userID);
    }
    
    return null;
  }


  // compare session from Firestore iteraction
  static Future<bool> compareSessionInFireStore(String sessionToken) async {
    CollectionReference user = _firestore.collection('User');

    QuerySnapshot snapshot = await user.get();

    for (var doc in snapshot.docs) {
      String docUserSessionToken = doc['sessionToken'];

      if(docUserSessionToken == sessionToken){
        return true;
      }
    }

    return false;
  }

  static void logoutAfterDuration({
    required BuildContext context,
    required UserLoginSessions loginSession,
  }) {
    logoutTimer?.cancel();

    logoutTimer = Timer(Duration(seconds: 40), () {
      SessionManager.destroySessionInLocal();
      SessionManager.updateSessionInFireStore(userID: loginSession.uID, sessionToken: "");
      navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserLoginPage()),(route) => false);
    });
  }

  static void onLogout({required BuildContext context, required String uID}){
    logoutTimer?.cancel();
    SessionManager.destroySessionInLocal();
    SessionManager.updateSessionInFireStore(userID: uID, sessionToken: "");
    navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserLoginPage()), (route) => false);
    FocusScope.of(context).unfocus();
  }
}
