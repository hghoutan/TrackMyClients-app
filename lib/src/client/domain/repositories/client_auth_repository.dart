import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackmyclients_app/src/admin/domain/models/client.dart';
import 'package:trackmyclients_app/src/admin/domain/repositories/firebase_notification_repository.dart';

final clientAuthRepositoryProvider = Provider(
  (ref) => ClientAuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class ClientAuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ClientAuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<bool> signInWithEmailAndPassword(
      String aui, String email, String password) async {
    try {
      final notificationService = NotificationsService();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final customUserRef = firestore
          .collection('users')
          .doc(aui)
          .collection('clients')
          .where('email', isEqualTo: email);

      final customUser = await customUserRef.get();
      if (customUser.docs.isNotEmpty) {
        final userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        final user = userCredential.user;

        // save admin uid for using it later
        prefs.setString('adminUid', aui);
        notificationService.getToken(aui: aui);
        // Verify the custom user's password
        // final storedPassword = customUser.docs;
        // if (storedPassword!= password) {
        //   throw Exception('Invalid password');
        // }
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
    // Find the custom user in your collection
  }

  Future<ClientData?> getCurrentClientData(String? adminUid) async {
    try {
      var clientData = await firestore
          .collection('users')
          .doc(adminUid)
          .collection('clients')
          .doc(auth.currentUser!.uid)
          .get();

      ClientData? client;
      if (clientData.data() != null) {
        client = ClientData.fromMap(clientData.data()!);
      }
      return client;
    } catch (e) {
      return null;
    }
  }

  void setUserState(String aui, bool isOnline) async {
    try {
      await firestore
          .collection('users')
          .doc(aui)
          .collection('clients')
          .doc(auth.currentUser!.uid)
          .update({
        'isOnline': isOnline,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
