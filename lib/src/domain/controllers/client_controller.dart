import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/domain/models/client.dart';

import '../repositories/client_repository.dart';
import 'auth_controller.dart';

final clientControllerProvider = Provider((ref) {
  final authRepository = ref.watch(clientRepositoryProvider);
  return ClientController(authRepository: authRepository, ref: ref);
});



class ClientController {
  final ClientRepository authRepository;
  final ProviderRef ref;
  ClientController({
    required this.authRepository,
    required this.ref,
  });

   void saveClientDataToFirebase(
      BuildContext context, ClientData clientData, File? profilePic) {
      authRepository.saveClientDataToFirebase(
        client: clientData,
        profilePic: profilePic,
        ref: ref,
        context: context,
      );
  }
  Future<List<ClientData>> fetchAllClients() async {
    return authRepository.fetchAllClients();
  }
  Stream<ClientData>? clientDataById(String id) {
    return authRepository.clientData(id);
  }

}
