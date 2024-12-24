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
  - To validate the user
  - Biometric in this app is a must, either fingerprint or face ID, else you unable to use the app.

- Sessions Management
  - (Client Side Implemented) --> !!!(Server Side like FireCloud need to pay, so I just implement client side)!!!
    - Client Side Will Auto Destroy Login Session within 1 hours (code demonstrated in 40secs).
    - Server Side Will Auto Destroy Login Session within 1 hours (FireCloud = only theoritical due need payment).

- Prevent Reverse Engineer Vulnerability
  - The app will be implement developer mode detector by MethodChannel to each Native platform(Android, iOS).
  - This countermeasure is also in theoritical so you guys can run my code in debug mode in real devices.

- Prevent Identity Spoofing
  - Validate Email Address (I do it at manual form for authentication and I didnt use the Firebase Authentication, so if implement by alternative extension will be take long time) 

- Password Complexity Policy
  - Minimum 8 character
  - Must include at least 1 Upper case character
  - Must include at least 1 Lower case character
  - Must include at least 1 special character
  - Must include at least 1 number
    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
**Demo of the Security Features**
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
1.0 **LOGIN/REGISTER PAGE (HASHING + BIOMETRIC)**
  1.1 Sign Up 
    1.1.1 If Biometric is not been enrolled
      ![image](https://github.com/user-attachments/assets/26a91460-7b16-4b1c-82f1-06b4dc2f4dac)
    1.1.2 If Biometric have been enrolled and password match the password policy
      ![image](https://github.com/user-attachments/assets/e0e84655-82fb-4f06-b185-ecfd5fd7bc40)
    1.1.3 Password will not been stored in original text, but is stored in hashed 512 bits long length form, so the adversary unable to guese or brute force due to computation source and time limitation.
      ![image](https://github.com/user-attachments/assets/66187bcb-8df3-47a8-84ed-f9df789fc236)
    1.1.4 After done verified user then will auto redirect user to Login Page

  1.2 Sign In
    1.2.1 If Biometric have been enrolled and both credentials is correct
      ![image](https://github.com/user-attachments/assets/8926cf77-1034-4790-8ad7-0f835ccf69bb)
    1.2.2 User need to fill in their details once successful sign in
      ![image](https://github.com/user-attachments/assets/63fa699b-4a8a-4cad-8686-8145c212efce)
    1.2.3 Once user get authenticated and signed in, token will be created to maintain user login session. 
        a. In this demo I set to 40 seconds only
        b. Once session end, user will auto logout
        ![image](https://github.com/user-attachments/assets/ca60b267-def9-4506-aba6-36a6154954b1)
        c. All user data will be in obsecure text, the text will change to clear text when user click EDIT, Besides, all data is encrypted by AES256
        ![image](https://github.com/user-attachments/assets/d30e3f80-73df-48aa-a9e1-35863561ed5d)
        d. Bimetric autentication required when user want to EDIT
        ![image](https://github.com/user-attachments/assets/446a0860-a536-4b33-abca-80e60a57c208)
        e. Once done autentication, user able to see and modified the data in clear text
        ![image](https://github.com/user-attachments/assets/bf5df774-2376-4bd3-977d-2f8cee8d0979)
        
        

        

    
    




 
