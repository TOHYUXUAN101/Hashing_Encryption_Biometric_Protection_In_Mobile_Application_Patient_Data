# Hashing_Encryption_Biometric_MFAProtection_In_Mobile_Application_Patient_Data
A manual form of Security Features implemented: 
- Hashing(SHA3_512 - Availability)
- AES(256-32bitkey - Confidentiality)
  - Encrypted before user input data is parse into FireStore.
  - Decrypted after fetch user data from FireStore and before present in User Interface.
- Biometric(Auto Select Based On Devices Biometric Security Priority - Multifactor Authentication)
  - Biometric in this app is a must, either fingerprint or face ID, else you unable to use the app.
- Sessions Management
  - (Client Side) --> !!!(Server Side like FireCloud need to pay, so I just implement client side)!!!
    -Client Side Will Auto Destroy Login Session within 1 hours (code demonstrated in 40secs).
    -Server Side Will Auto Destroy Login Session within 1 hours (FireCloud = only theoritical due need payment).
- Prevent Reverse Engineer Vulnerability
  -  The app will be implement developer mode detector by MethodChannel to each Native platform(Android, iOS).
  -  This countermeasure is also in theoritical so you guys can run my code in debug mode in real devices. 
