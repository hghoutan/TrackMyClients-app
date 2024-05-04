import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/admin/domain/models/client.dart';

import '../repositories/client_repository.dart';

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
  
   Future<void> saveClientDataToFirebase(
      BuildContext context,String password ,ClientData clientData, File? profilePic) async {
      await authRepository.saveClientDataToFirebase(
        password: password,
        client: clientData,
        profilePic: profilePic,
        ref: ref,
        context: context,
      );
  }
  Stream<List<ClientData>> fetchAllClients(){
    return authRepository.fetchAllClients();
  }
  Stream<ClientData>? clientDataById(String id) {
    return authRepository.clientData(id);
  }
  

}
