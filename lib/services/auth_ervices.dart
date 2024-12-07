// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/material.dart';
// import 'dart:developer';

// import 'package:ski/chatApp/api/apis.dart';

// class AuthServices {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   User? getCurrentUser() {
//     return _firebaseAuth.currentUser;
//   }

//   Future<UserCredential?> signInWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//       if (gUser == null) {
//         return null;
//       }

//       final GoogleSignInAuthentication gAuth = await gUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: gAuth.accessToken,
//         idToken: gAuth.idToken,
//       );

//       UserCredential userCredential =
//           await _firebaseAuth.signInWithCredential(credential);

//       if (await APIs.userExists()) {
//         log('User exists. Navigating to HomeScreen.');
//         // Navigate to HomeScreen here
//         // Example: Navigator.pushReplacementNamed(context, '/home');
//         return userCredential;
//       } else {
//         log('User does not exist. Creating new user.');
//         await APIs.createUser();
//         // Navigate to HomeScreen here
//         // Example: Navigator.pushReplacementNamed(context, '/home');
//         return userCredential;
//       }
//     } catch (e) {
//       log('Sign-In error: $e');
//       return null;
//     }
//   }

//   Future<UserCredential?> signUpWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//       if (gUser == null) {
//         return null;
//       }

//       final GoogleSignInAuthentication gAuth = await gUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: gAuth.accessToken,
//         idToken: gAuth.idToken,
//       );

//       UserCredential userCredential =
//           await _firebaseAuth.signInWithCredential(credential);

//       if (await APIs.userExists()) {
//         log('User exists. Navigating to HomeScreen.');
//         // Navigate to HomeScreen here
//         // Example: Navigator.pushReplacementNamed(context, '/home');
//         return userCredential;
//       } else {
//         log('User does not exist. Creating new user.');
//         await APIs.createUser();
//         // Navigate to HomeScreen here
//         // Example: Navigator.pushReplacementNamed(context, '/home');
//         return userCredential;
//       }
//     } catch (e) {
//       log('Sign-Up error: $e');
//       return null;
//     }
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import '../chatApp/api/apis.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (await APIs.userExists()) {
        log('User exists. Navigating to HomeScreen.');
        return userCredential;
      } else {
        log('User does not exist. Creating new user.');
        await APIs.createUser();
        return userCredential;
      }
    } catch (e) {
      log('Sign-In error: $e');
      return null;
    }
  }

  Future<UserCredential?> signUpWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (await APIs.userExists()) {
        log('User exists. Navigating to HomeScreen.');
        return userCredential;
      } else {
        log('User does not exist. Creating new user.');
        await APIs.createUser();
        return userCredential;
      }
    } catch (e) {
      log('Sign-Up error: $e');
      return null;
    }
  }

  Future<bool> userExists() async {
    return await APIs.userExists();
  }

  Future<void> createUser() async {
    await APIs.createUser();
  }
}
