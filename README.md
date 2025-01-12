# Hashing_Encryption_Biometric_MFAProtection_In_Mobile_Application_Patient_Data
# Language : Flutter ||| Database : Firebase Firestore
![image](https://github.com/user-attachments/assets/61ecf214-751b-4324-8fea-656412095cc7)


**A manual form of Security Features implemented:**
- Hashing (SHA3_512 - +Integrity -Availability)
  - Hash the user password. Login will based on the hash value of password.

- Encryption (AES256-32bitkey - +Confidentiality)
  - Encrypted before patient data is parse into FireStore.
  - Decrypted after fetch patient data from FireStore and before present in User Interface.

- Biometric (Multifactor Authentication)
  - Auto Selected Based On Devices Biometric Security Priority Level.
  - To validate the user
  - Biometric in this app is a must, either fingerprint or face ID, else you unable to use the app.

- Password Complexity Policy
  - Minimum 8 character
  - Must include at least 1 Upper case character
  - Must include at least 1 Lower case character
  - Must include at least 1 special character
  - Must include at least 1 number

- Sessions Management
  - (Client Side Implemented) --> !!!(Server Side like FireCloud need to pay, so I just implement client side)!!!
    - Client Side Will Auto Destroy Login Session within 1 hours (code demonstrated in 40secs).
    - Server Side Will Auto Destroy Login Session within 1 hours (FireCloud = only theoritical due need payment).

- Prevent Reverse Engineer Vulnerability
  - The app will be implement developer mode detector by MethodChannel to each Native platform(Android, iOS).
  - This countermeasure is also in theoritical so you guys can run my code in debug mode in real devices.

- Prevent Identity Spoofing
  - Validate Email Address (I do it at manual form for authentication and I didnt use the Firebase Authentication, so if implement by alternative extension will be take long time) 
    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
**Demo of the Security Features**
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

  **1.1 Sign Up**<br />
    1.1.1 If Biometric is not been enrolled<br />
      ![image](https://github.com/user-attachments/assets/26a91460-7b16-4b1c-82f1-06b4dc2f4dac)<br /><br />
    1.1.2 If Biometric have been enrolled and password match the password policy<br />
      ![image](https://github.com/user-attachments/assets/e0e84655-82fb-4f06-b185-ecfd5fd7bc40)<br /><br />
    1.1.3 Password will not been stored in original text, but is stored in hashed 512 bits long length form, so the adversary unable to guese or brute force due to computation source and time limitation.<br />
      ![image](https://github.com/user-attachments/assets/66187bcb-8df3-47a8-84ed-f9df789fc236)<br /><br />
    1.1.4 Device UID will been created for each account registered devices.
      ![image](https://github.com/user-attachments/assets/50c0dd9a-d930-4e8e-ba18-ea50242af236)<br /><br />
    1.1.5 After done verified user then will auto redirect user to Login Page<br /><br /><br />

 ** 1.2 Sign In**<br />
    1.2.1 If attacker is luckily having the correct password and email address, then the database will compare to device id and if wrong device id, it will email user for notice and verification purpose.<br />
      ![image](https://github.com/user-attachments/assets/f1b0fb77-d4fe-4cab-a8be-5959591a342c)<br /><br />
    1.2.2 If Biometric have been enrolled and both credentials is correct<br />
      ![image](https://github.com/user-attachments/assets/8926cf77-1034-4790-8ad7-0f835ccf69bb)<br /><br />
    1.2.2 User need to fill in their details once successful sign in<br />
      ![image](https://github.com/user-attachments/assets/63fa699b-4a8a-4cad-8686-8145c212efce)<br /><br />
    1.2.3 Once user get authenticated and signed in, token will be created to maintain user login session.<br />
        a. In this demo I set to 40 seconds only<br />
        b. Once session end, user will been forced to logout to re-authenticate again<br />
        ![image](https://github.com/user-attachments/assets/ca60b267-def9-4506-aba6-36a6154954b1)<br /><br />
        c. All user data will be in obsecure text, the text will change to clear text when user click EDIT, Besides, all data is encrypted by AES256<br />
        ![image](https://github.com/user-attachments/assets/d30e3f80-73df-48aa-a9e1-35863561ed5d)<br /><br />
        d. Bimetric autentication required when user want to EDIT<br />
        ![image](https://github.com/user-attachments/assets/446a0860-a536-4b33-abca-80e60a57c208)<br /><br />
        e. Once done autentication, user able to see and modified the data in clear text<br />
        ![image](https://github.com/user-attachments/assets/bf5df774-2376-4bd3-977d-2f8cee8d0979)<br /><br /><br />
   
   ** 1.3 Forget Password**
    1.3.1 The password also will been check and verified through hashing with biometric.<br />
    ![image](https://github.com/user-attachments/assets/4174e52d-2e02-49d1-9075-c3a8b0e563cb)<br /><br />
    ![image](https://github.com/user-attachments/assets/67761a68-baf6-41c4-beb4-eebb3ed44c20)<br /><br />
    ![image](https://github.com/user-attachments/assets/9db17781-a973-4fa2-9244-4fcaf7ccc218)<br /><br />



    
        
        

        

    
    




 
