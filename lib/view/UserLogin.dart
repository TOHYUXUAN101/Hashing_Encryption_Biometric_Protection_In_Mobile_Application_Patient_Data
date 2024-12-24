import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospitize/main.dart';
import 'package:hospitize/model/UserDataRetrievedModel.dart';
import 'package:hospitize/model/userLoginSessionToken.dart';
import 'package:hospitize/utils/constant/color.dart';
import 'package:hospitize/utils/constant/screenUtils.dart';
import 'package:hospitize/utils/service/Biometric/Biometric.dart';
import 'package:hospitize/utils/service/Firebase/Firestore.dart';
import 'package:hospitize/utils/service/Hashing/hashlib.dart';
import 'package:hospitize/utils/service/FormUtil/FormValidator.dart';
import 'package:hospitize/utils/service/Session/SessionManager.dart';
import 'package:hospitize/utils/widget/button.dart';
import 'package:hospitize/utils/widget/userInput.dart';
import 'package:hospitize/view/HomePage.dart';
import 'package:hospitize/view/UserForgotPassword.dart';
import 'package:hospitize/view/UserSignUp.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {

  late TextEditingController userMailController;
  late TextEditingController userPassController;
  bool isPasswordVisible = false;
  bool isLogin = false;
  bool isLogout = false;
  late bool isInitialLogin;
  late FocusNode emailFocusNode = FocusNode();
  late FocusNode passwordFocusNode = FocusNode();
  late UserLoginSessions? sessions;
  late String sessionToken;
  late UserLoginSessions loginSessions = UserLoginSessions(uID: '', sessionToken: '');

  @override
  void initState() {
    super.initState();
    //SessionManager.destroySessionInLocal();
    userMailController = TextEditingController();
    userPassController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      bool isSessionValid = await SessionManager.checkSessionInLocal();
      debugPrint("Here is the booleanSessions0---->$isSessionValid");

      if (isSessionValid) {
        sessions = await SessionManager.getSessionFromLocal();

        debugPrint("Here is the initialfetchSessions1---->${sessions?.uID}");
        debugPrint("Here is the initialfetchSessions2---->${sessions?.sessionToken}");

        loginSessions = UserLoginSessions(
          uID: sessions!.uID,
          sessionToken: sessions!.sessionToken,
        );

        isInitialLogin = await SessionManager.compareSessionInFireStore(sessions!.sessionToken);
        debugPrint("Here is the booleanSessions3---->$isInitialLogin");

        if (isInitialLogin) {
          SessionManager.logoutAfterDuration(context: context, loginSession: loginSessions);
          navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage(session: loginSessions)),(route) => false);
        } else {
          debugPrint('No session found');
        }
      } else {
        debugPrint('No session found');
      }

      if (isLogout) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => UserLoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Error during session validation: $e");
    } finally {
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  });

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
                btnText: 'Sign In', 
                isNotTransparentButton: true,
                fontColor: ColorManager.white,
                onBtnSubmit: () async {
                  if(FormValidator.validateEmailField(context: context, emailControllerText: userMailController.text)){
                    if(FormValidator.validatePasswordComplexity(context: context, uPass: userPassController.text)){
                      UserDataRetrieve? retrieveData = await FireStore.getUserCredential(context: context, userEmail: userMailController.text);
                      if(retrieveData == null){
                        ScreenUtils.showCupertinoAlertDialog(
                          context, 
                          "Error",
                          "Error Getting Data"
                        );
                      }else{
                        
                          String hashValue = HashAlgorithm.hashLoginPassword(userInput: userPassController.text, hashKey: retrieveData.uKey);
                          isLogin = FireStore.signIn(context: context, userEmail: userMailController.text, userNewlyHashed: hashValue, userPreviouslyHashed: retrieveData.uPassHashed, userIsValidated: retrieveData.uIsValidated);
                          
                          if(isLogin){
                            BiometricHelper biometricHelper = BiometricHelper();
                            if (await biometricHelper.isDeviceSupported()) {
                                bool isAuthenticated = await biometricHelper.authenticate(
                                  reason: "Authenticate to complete login",
                                  biometricOnly: true,
                                );
                                if(isAuthenticated){
                                  Fluttertoast.showToast(
                                    msg: "User successfully login",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: ColorManager.green,
                                    textColor: ColorManager.black,
                                    fontSize: 16.0
                                  );

                                  sessionToken = SessionManager.createSession();
                                  SessionManager.storeSessionInLocal(retrieveData.uID, sessionToken);
                                  SessionManager.storeSessionInFireStore(retrieveData.uID, sessionToken);
                                  
                                  loginSessions = UserLoginSessions(uID: retrieveData.uID, sessionToken: sessionToken);

                                  SessionManager.logoutAfterDuration(context: context, loginSession: loginSessions);

                                  navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage(session: loginSessions)), (route) => false);
                                  
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

                            } else {
                              ScreenUtils.showCupertinoAlertDialog(
                                context,
                                "Error",
                                "Biometric authentication is not supported on this device.",
                              );
                            }
                          }
                        
                        FocusScope.of(context).unfocus();
                      }
                    }
                  }
                },
              ),
              ReusableButton(
                btnText: 'Forget Password?', 
                isNotTransparentButton: false,
                fontColor: ColorManager.grey,
                onBtnSubmit: () { 
                  navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserForgotPassPage()), (route) => false);
                  FocusScope.of(context).unfocus();
                },
              ),
              ReusableButton(
                btnText: 'Havent Register Yet?', 
                isNotTransparentButton: false,
                fontColor: ColorManager.grey,
                onBtnSubmit: () { 
                  navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserSignUpPage()), (route) => false);
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