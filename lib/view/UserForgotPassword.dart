import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospitize/main.dart';
import 'package:hospitize/model/UserDataRetrievedModel.dart';
import 'package:hospitize/model/hashingPasswordClass.dart';
import 'package:hospitize/utils/constant/color.dart';
import 'package:hospitize/utils/constant/screenUtils.dart';
import 'package:hospitize/utils/service/Biometric/Biometric.dart';
import 'package:hospitize/utils/service/Firebase/Firestore.dart';
import 'package:hospitize/utils/service/FormUtil/FormValidator.dart';
import 'package:hospitize/utils/service/Hashing/hashlib.dart';
import 'package:hospitize/utils/widget/button.dart';
import 'package:hospitize/utils/widget/userInput.dart';
import 'package:hospitize/view/UserLogin.dart';

class UserForgotPassPage extends StatefulWidget {
  const UserForgotPassPage({super.key});

  @override
  State<UserForgotPassPage> createState() => _UserForgotPassPageState();
}

class _UserForgotPassPageState extends State<UserForgotPassPage> {
  late TextEditingController userMailController;
  late TextEditingController userNewPassController;
  late TextEditingController userRepeatNewPassController;
  bool isPasswordVisible = false;
  bool isRepeatPasswordVisible = false;
  bool isPasswordNotReuse = true;
  late FocusNode emailFocusNode = FocusNode();
  late FocusNode newPasswordFocusNode = FocusNode();
  late FocusNode repeatNewPasswordFocusNode = FocusNode();
  UserDataRetrieve? retrieveData;

  @override
  void initState() {
    super.initState();
    userMailController = TextEditingController();
    userNewPassController = TextEditingController();
    userRepeatNewPassController = TextEditingController();
  }

  @override
  void dispose(){
    //Dispose controller
    userMailController.dispose();
    userNewPassController.dispose();
    userRepeatNewPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Text(
                "Modified Password", 
                textAlign: TextAlign.center, 
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            ReusableInputField(
              labelText: 'Email', 
              controller: userMailController,
              focusNode: emailFocusNode,
            ),
            ReusableInputField(
              labelText: 'Password', 
              controller: userNewPassController, 
              focusNode: newPasswordFocusNode,
              obscureText: !isPasswordVisible, 
              suffixIcon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onIconTap: (){
                setState((){
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            ReusableInputField(
              labelText: 'Password Confirmation', 
              controller: userRepeatNewPassController, 
              focusNode: repeatNewPasswordFocusNode,
              obscureText: !isRepeatPasswordVisible, 
              suffixIcon: Icon(
                isRepeatPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onIconTap: (){
                setState((){
                  isRepeatPasswordVisible = !isRepeatPasswordVisible;
                });
              },
            ),
            ReusableButton(
              btnText: "Submit", 
              onBtnSubmit: () async {
                if(FormValidator.validateEmailField(context: context, emailControllerText: userMailController.text)){
                  if(FormValidator.validatePasswordComplexity(context: context, uPass: userNewPassController.text) && FormValidator.validatePasswordComplexity(context: context, uPass: userRepeatNewPassController.text)){
                    if(FormValidator.validatePasswordMatching(context: context, uNewPass: userNewPassController.text, uRepeatNewPass: userRepeatNewPassController.text)){
                      
                      BiometricHelper biometricHelper = BiometricHelper();
                      if (await biometricHelper.isDeviceSupported()) {
                        bool isAuthenticated = await biometricHelper.authenticate(
                          reason: "Authenticate to complete login",
                          biometricOnly: true,
                        );
                        // if authenticate->>hash the password and update to fireStore
                        if(isAuthenticated){
                          if(await FireStore.checkExistingUser(context: context, userEmail: userMailController.text)){
                            ScreenUtils.showCupertinoAlertDialog(
                              context, 
                              "Error",
                              "User Not Exist"
                            );
                          }else{
                            retrieveData = await FireStore.getUserCredential(context: context, userEmail: userMailController.text);
                            if(retrieveData == null){
                              ScreenUtils.showCupertinoAlertDialog(
                                context, 
                                "Error",
                                "Error Getting Data"
                              );
                            }else{
                              String hashValueOri = HashAlgorithm.hashLoginPassword(userInput: userNewPassController.text, hashKey: retrieveData!.uKey);
                              isPasswordNotReuse = FireStore.checkReusePassword(context: context, oldPassHashBySameKey: retrieveData!.uPassHashed, newPassHashBySameKey: hashValueOri);
                              
                              if(isPasswordNotReuse){
                                UserPassHash hashValue = HashAlgorithm.hashPassword(userInput: userNewPassController.text);
                                FireStore.updateUserPassword(context: context, userID: retrieveData!.uID, newPassHash: hashValue.hash, newPassHashKey: hashValue.key);
                                
                                Fluttertoast.showToast(
                                  msg: "Success Change Password",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: ColorManager.green,
                                  textColor: ColorManager.black,
                                  fontSize: 16.0
                                );

                                navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserLoginPage()), (route) => false);
                              }
                            }
                          }
                        }
                      }else{
                        Fluttertoast.showToast(
                          msg: "Failed authenticate user",  // Toast message
                          toastLength: Toast.LENGTH_LONG,      // Toast duration
                          gravity: ToastGravity.BOTTOM,         // Position of the toast
                          timeInSecForIosWeb: 1,                // iOS Web time duration
                          backgroundColor: ColorManager.red,       // Background color
                          textColor: const Color.fromARGB(255, 255, 255, 255),             // Text color
                          fontSize: 16.0                       // Text size
                        );
                      }
                    }
                  }
                }
              }, 
              isNotTransparentButton: true, 
              fontColor: ColorManager.white
            ),
            ReusableButton(
              btnText: "Back to Login Page", 
              onBtnSubmit: () {
                navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserLoginPage()), (route) => false);
              }, 
              isNotTransparentButton: false, 
              fontColor: ColorManager.grey
            )
          ],
        ),
      ),
    );
  }
}