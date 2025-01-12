import 'package:flutter/material.dart';
import 'package:hospitize/model/AllUserData.dart';
import 'package:hospitize/model/EncryptedAllUserData.dart';
import 'package:hospitize/model/userLoginSessionToken.dart';
import 'package:hospitize/utils/constant/color.dart';
import 'package:hospitize/utils/service/Biometric/Biometric.dart';
import 'package:hospitize/utils/service/Encryption/Aes.dart';
import 'package:hospitize/utils/service/Firebase/Firestore.dart';
import 'package:hospitize/utils/service/FormUtil/FormValidator.dart';
import 'package:hospitize/utils/service/Session/SessionManager.dart';
import 'package:hospitize/utils/widget/button.dart';
import 'package:hospitize/utils/widget/userInput.dart';

class HomePage extends StatefulWidget {
  final UserLoginSessions session;

  const HomePage({super.key, required this.session});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late TextEditingController uNameController;
  late TextEditingController uMailController;
  late TextEditingController uBirthController;
  late TextEditingController uSSNController;
  late FocusNode uNameFocusnode = FocusNode();
  late FocusNode uMailFocusnode = FocusNode();
  late FocusNode uBirthFocusnode = FocusNode();
  late FocusNode uSSNFocusnode = FocusNode();
  late bool isReadOnly = true;
  late bool isObsecure = true;
  late bool isEditEnabled = true;
  late bool isSaveEnabled = false;
  late UserAllData allData = UserAllData(uName: '', uBirth: '', uMail: '', uSSN: '');
  late UserAllDataEncrypted allEncryptData = UserAllDataEncrypted(uNameEnc: '', uBirthEnc: '', uMail: '', uSSNEnc: '');

  @override
  void initState(){
    super.initState();
    uNameController = TextEditingController();
    uMailController = TextEditingController();
    uBirthController = TextEditingController();
    uSSNController = TextEditingController();

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

      try{
        allEncryptData = (await FireStore.getUserAllCredential(context: context, userID: widget.session.uID))!;
        allData = AesAlgo.EncryptDecrypt(allEncryptData: allEncryptData, decryptMode: true) as UserAllData;
        
        setState(() {
          uNameController.text = allData.uName;
          uMailController.text = allData.uMail;
          uSSNController.text = allData.uSSN;
          uBirthController.text = allData.uBirth;
        });
      } catch(e) {
        debugPrint("Error during session fetching data: $e");
      } finally {
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
    });
  }

  @override
  void dispose(){
    super.dispose();
    uNameController.dispose();
    uMailController.dispose();
    uBirthController.dispose();
    uSSNController.dispose();
  }

  Future<bool?> _biometricAuthentication() async {
    BiometricHelper biometricHelper = BiometricHelper();
    if (await biometricHelper.isDeviceSupported()) {
      bool isAuthenticated = await biometricHelper.authenticate(
        reason: "Authenticate to complete login",
        biometricOnly: true,
      );
      return isAuthenticated;
    }
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReusableInputField(
              labelText: "Name", 
              controller: uNameController, 
              focusNode: uNameFocusnode,
              isReadOnly: isReadOnly,
              obscureText: isObsecure,
            ),
            ReusableInputField(
              labelText: "Mail", 
              controller: uMailController, 
              focusNode: uMailFocusnode,
              isReadOnly: isReadOnly,
              obscureText: isObsecure,
            ),
            ReusableInputField(
              labelText: "Birth", 
              controller: uBirthController, 
              focusNode: uBirthFocusnode,
              isReadOnly: isReadOnly,
              obscureText: isObsecure,
              isCalendar: true,
              onDateSelected: (dateSelected) {},
            ),
            ReusableInputField(
              labelText: "SSN(IC)", 
              controller: uSSNController, 
              focusNode: uSSNFocusnode,
              isReadOnly: isReadOnly,
              obscureText: isObsecure,
              isInputFormatter: true,
            ),
            ReusableButton(
              btnText: "Edit",
              isEnabled: isEditEnabled,
              onBtnSubmit: () async {
                bool? isAuthenticate = await _biometricAuthentication();
                if(isAuthenticate!=null){
                  if(isAuthenticate){
                    setState(() {
                      isReadOnly = false;
                      isObsecure = false;
                      isEditEnabled = false;
                      isSaveEnabled = true;
                    });
                  }
                }
              }, 
              isNotTransparentButton: true, 
              fontColor: isEditEnabled ? ColorManager.black : ColorManager.grey
            ),
            ReusableButton(
              btnText: "Save",
              isEnabled: isSaveEnabled, 
              onBtnSubmit: () async {
                if(FormValidator.validateEmailField(context: context, emailControllerText: uMailController.text)){
                  allData = UserAllData(uName: uNameController.text, uBirth: uBirthController.text, uMail: uMailController.text, uSSN: uSSNController.text);
                  uNameController.text = allData.uName;
                  uMailController.text = allData.uMail;
                  uSSNController.text = allData.uSSN;
                  uBirthController.text = allData.uBirth;
                
                  allEncryptData = AesAlgo.EncryptDecrypt(allData: allData, encryptMode: true, isGenerateNewKey: true) as UserAllDataEncrypted;
                  FireStore.updateUserData(userID: widget.session.uID, allEncData: allEncryptData);
                  setState(() {
                    isReadOnly = true;
                    isSaveEnabled = false;
                    isEditEnabled = true;
                    isObsecure = true;
                  });
                }
              }, 
              isNotTransparentButton: true, 
              fontColor: isSaveEnabled ? ColorManager.black : ColorManager.grey
            ),
            ReusableButton(
              btnText: "Logout", 
              onBtnSubmit: () {
                SessionManager.onLogout(context: context, uID: widget.session.uID);
              }, 
              isNotTransparentButton: true, 
              fontColor: ColorManager.black
            )
          ],
        ),
      ),
    );
  }
}