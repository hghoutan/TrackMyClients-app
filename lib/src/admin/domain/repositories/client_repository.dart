import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/utils.dart';
import '../models/client.dart';
import 'firebase_storage_repository.dart';
import '../../../../main.dart';

final clientRepositoryProvider = Provider(
  (ref) => ClientRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

final getClientsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(clientRepositoryProvider);
  return selectContactRepository.fetchAllClients();
});

class ClientRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ClientRepository({
    required this.auth,
    required this.firestore,
  });

  Future<void> saveClientDataToFirebase({
    required String password,
    required ClientData client,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      // the current user
      String currentUid = auth.currentUser!.uid;
      FirebaseAuth secondAuth = FirebaseAuth.instanceFor(app: SecondaryAppProvider.of(context));

      // the new user which is the client
      final userCredential = await secondAuth.createUserWithEmailAndPassword(
        email: client.email!,
        password: password,
      );

      // the id of the client
      String? clientId = userCredential.user?.uid;

      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      ClientData updatedClient = client.copyWith(
        userId: clientId,
        profilePic: photoUrl,
        id: clientId,
      );

      if (profilePic != null) {
        photoUrl = await ref
            .read(firebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$clientId',
              profilePic,
            );
        updatedClient = updatedClient.copyWith(profilePic: photoUrl);
      }

      await firestore
          .collection('users')
          .doc(currentUid)
          .collection('clients')
          .doc(clientId)
          .set(updatedClient.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<ClientData>> fetchAllClients() {
    try {
      return firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('clients')
          .snapshots()
          .asyncMap((event) {
        List<ClientData> clients = [];
        for (var document in event.docs) {
          ClientData clientData = ClientData.fromMap(document.data());
          clients.add(clientData);
        }
        return clients;
      });
    } catch (e) {
      throw Exception('Failed to fetch clients: $e');
    }
  }

  Stream<ClientData> clientData(String clientId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('clients')
        .doc(clientId)
        .snapshots()
        .map(
          (event) => ClientData.fromMap(
            event.data()!,
          ),
        );
  }
}
