import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/admin/domain/models/user.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/auth/admin_fill_info.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/auth/admin_login.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/home.dart';
import 'package:trackmyclients_app/src/utils/functions/next_screen.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isEmailVerified() => auth.currentUser?.emailVerified ?? false;

  Future<UserData?> getCurrentUserData() async {
    try {
      var userData =
          await firestore.collection('users').doc(auth.currentUser?.uid).get();

      UserData? user;
      if (userData.data() != null) {
        user = UserData.fromMap(userData.data()!);
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  // phone number otp verification
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          print('Phone number verification failed.');
        },
        codeSent: (verificationId, forceResendingToken) {},
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      print('Error verifying phone number: $e');
    }
  }

  // user email/password sign In
  Future<String> signIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Login successful';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        return 'Wrong password provided for that user.';
      } else {
        return 'An unknown error occurred.';
      }
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  // user email/password sign up
  Future<String> signUp(
      BuildContext context, UserData userData, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: userData.email!, password: password);
      String uid = credential.user!.uid;
      _users.doc(uid).set(userData.toMap());
      auth.currentUser!.sendEmailVerification();
      nextScreenAnimation(context, const AdminLoginScreen());
      return 'User created.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return 'An unknown error occurred.';
      }
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  // reset password by email
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return 'Password reset email sent.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else {
        return 'An unknown error occurred.';
      }
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  Future<String> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        // Check if the user's email is verified
        if (!user.emailVerified) {
          await auth.signOut();
          return 'Please verify your email address before logging in.';
        } else {
          try {
            UserData userData = UserData.fromMap(
                (await _users.doc(user.uid).get()).data()
                    as Map<String, dynamic>);
            if (userData.isValid()) {
              nextScreenReplaceAnimation(context, const HomeScreen());
              return 'Google sign-in successful.';
            }
          } catch (e) {
            UserData userData = UserData(id: user.uid, email: user.email);
            nextScreenAnimation(
                context, AdminFillInfoScreen(userData: userData));
          }
          return 'Google sign-in successful.';
        }
      } else {
        return 'An unknown error occurred.';
      }
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  void updateUserData(BuildContext context, UserData userData) async {
    try {
      await _users.doc(userData.id).set(userData.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }

  
}
