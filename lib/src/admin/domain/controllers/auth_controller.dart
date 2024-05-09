import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/admin/domain/models/user.dart';

import '../repositories/auth_repository.dart';

final authControllerProvider = ChangeNotifierProvider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController with ChangeNotifier {
  final AuthRepository authRepository;
  final ChangeNotifierProviderRef<Object?> ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserData?> getUserData() async {
    UserData? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.verifyPhoneNumber(phoneNumber);
  }

  bool isEmailVerified() {
    return authRepository.isEmailVerified();
  }

  Future<String> signIn(BuildContext context, String email, String password) {
    return authRepository.signIn(context, email, password);
  }

  Future<String> signUp(
      BuildContext context, UserData userData, String password) {
    return authRepository.signUp(context, userData, password);
  }

  Future<String> sendPasswordResetEmail(String email) {
    return authRepository.sendPasswordResetEmail(email);
  }

  Future<String> signInWithGoogle(BuildContext context) {
    return authRepository.signInWithGoogle(context);
  }

  void updateUserData(BuildContext context, UserData userData) {
    return authRepository.updateUserData(context, userData);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }

  Future<void> signOut() async {
    await authRepository.signOut();
    // notifyListeners();
  }
}
