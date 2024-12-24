import 'package:flutter/material.dart';
import 'package:hospitize/main.dart';
import 'package:hospitize/model/UserDataRetrievedModel.dart';
import 'package:hospitize/model/hashingPasswordClass.dart';
import 'package:hospitize/utils/constant/color.dart';
import 'package:hospitize/utils/constant/screenUtils.dart';
import 'package:hospitize/utils/service/Biometric/Biometric.dart';
import 'package:hospitize/utils/service/Firebase/Firestore.dart';
import 'package:hospitize/utils/service/FormUtil/FormValidator.dart';
import 'package:hospitize/utils/service/hashing/hashlib.dart';
import 'package:hospitize/utils/widget/button.dart';
import 'package:hospitize/utils/widget/userInput.dart';
import 'package:hospitize/view/UserLogin.dart';

class UserSignUpPage extends StatefulWidget {
  const UserSignUpPage({super.key});

  @override
  State<UserSignUpPage> createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends State<UserSignUpPage> {

  late TextEditingController userMailController;
  late TextEditingController userPassController;
  bool isPasswordVisible = false;
  late FocusNode emailFocusNode = FocusNode();
  late FocusNode passwordFocusNode = FocusNode();
  UserDataRetrieve? retrieveData;
  bool reRegister = false;

  @override
  void initState() {
    super.initState();
    userMailController = TextEditingController();
    userPassController = TextEditingController();
  }

  @override
  void dispose(){
    //Dispose controller
    userMailController.dispose();
    userPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        emailFocusNode.unfocus();
        passwordFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorManager.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 160),
              Image.asset(
                "lib/assets/logo.png",
                width: 200, 
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30)
              ),
              ReusableInputField(
                labelText: 'Email', 
                controller: userMailController,
                focusNode: emailFocusNode,
              ),
              ReusableInputField(
                labelText: 'Password', 
                controller: userPassController, 
                focusNode: passwordFocusNode,
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
              ReusableButton(
                btnText: 'Sign Up', 
                isNotTransparentButton: true,
                fontColor: ColorManager.white,
                onBtnSubmit: () async {
                  if(FormValidator.validateEmailField(context: context, emailControllerText: userMailController.text)){
                     
                     if(FormValidator.validatePasswordComplexity(context: context, uPass: userPassController.text)){
                      UserPassHash hashValue = HashAlgorithm.hashPassword(userInput: userPassController.text);
                      
                      do{
                        if(await FireStore.checkExistingUser(context: context, userEmail: userMailController.text)){
                          if(await FireStore.register(context: context, userEmail: userMailController.text, userHashed: hashValue)){
                            BiometricHelper biometricHelper = BiometricHelper();
                            if (await biometricHelper.isDeviceSupported()) {
                              bool isAuthenticated = await biometricHelper.authenticate(
                                reason: "Authenticate to complete registration",
                                biometricOnly: true,
                              );
              
                              if(isAuthenticated){
                                retrieveData = await FireStore.getUserCredential(context: context, userEmail: userMailController.text);
                                if(retrieveData == null){
                                  debugPrint("Error Getting Data");
                                }else{
                                  if(await FireStore.validateUser(context: context, uID: retrieveData!.uID, isValidate: true)){
                                    reRegister = false;
                                    FocusScope.of(context).unfocus();
                                    navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserLoginPage()), (route) => false);
                                  }
                                }
                              }else {
                                ScreenUtils.showCupertinoAlertDialog(
                                  context,
                                  "Biometric Validation Failed",
                                  "Please re-Register and Validate User Account by Biometric Again"
                                );
                                retrieveData = await FireStore.getUserCredential(context: context, userEmail: userMailController.text);
                                FireStore.deleteUserData(context: context, uID: retrieveData!.uID);
                                reRegister = false;
                              }
                            } else {
                              ScreenUtils.showCupertinoAlertDialog(
                                context,
                                "Error",
                                "Biometric authentication is not supported on this device.",
                              );
                            }
                          }
                        }else{
                          if (await FireStore.isUserValidated(context: context, userEmail: userMailController.text) == false){
                            retrieveData = await FireStore.getUserCredential(context: context, userEmail: userMailController.text);
                            FireStore.deleteUserData(context: context, uID: retrieveData!.uID);
                            reRegister = true;
                          }
                        }
                      }while(reRegister);
                    }
                  }
                }
              ),
              ReusableButton(
                btnText: 'Already Registered?', 
                isNotTransparentButton: false,
                fontColor: ColorManager.grey,
                onBtnSubmit: () { 
                  navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserLoginPage()), (route) => false);
                  FocusScope.of(context).unfocus();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}