import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/utils.dart';
import '../models/client.dart';
import 'firebase_storage_repository.dart';

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
    required ClientData client,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      var uuid = const Uuid().v4();
      if (profilePic != null) {
        photoUrl = await ref
            .read(firebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uuid',
              profilePic,
            );
      }

      ClientData updatedClient = client.copyWith(
        id: uuid,
        userId: uid,
        profilePic: photoUrl,
      );
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('clients')
          .doc(uuid)
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
