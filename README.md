# Hashing_Encryption_Biometric_MFAProtection_In_Mobile_Application_Patient_Data
# Language : Flutter ||| Database : Firebase Firestore

**A manual form of Security Features implemented: **
- Hashing (SHA3_512 - Availability)
  - Hash the user password. Login will based on the hash value of password.

- Encryption (AES256-32bitkey - Confidentiality)
  - Encrypted before patient data is parse into FireStore.
  - Decrypted after fetch patient data from FireStore and before present in User Interface.

- Biometric (Multifactor Authentication)
  - Auto Selected Based On Devices Biometric Security Priority Level.
  - Biometric in this app is a must, either fingerprint or face ID, else you unable to use the app.

- Sessions Management
  - (Client Side Implemented) --> !!!(Server Side like FireCloud need to pay, so I just implement client side)!!!
    - Client Side Will Auto Destroy Login Session within 1 hours (code demonstrated in 40secs).
    - Server Side Will Auto Destroy Login Session within 1 hours (FireCloud = only theoritical due need payment).

- Prevent Reverse Engineer Vulnerability
  - The app will be implement developer mode detector by MethodChannel to each Native platform(Android, iOS).
  - This countermeasure is also in theoritical so you guys can run my code in debug mode in real devices.

- Prevent Identity Spoofing
  - Validate Email Address (I do it at manual form for authentication and I didnt use the Firebase Authentication, so if implement by alternative extension will be take time) 

- Password Complexity Policy
  - Minimum 8 character
  - Must include at least 1 Upper case character
  - Must include at least 1 Lower case character
  - Must include at least 1 special character
  - Must include at least 1 number
    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
**Demo of the Security Feature**
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
**LOGIN PAGE (HASHING)**


 
