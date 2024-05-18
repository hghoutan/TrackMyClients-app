import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackmyclients_app/src/admin/domain/models/client.dart';
import 'package:trackmyclients_app/src/client/domain/repositories/client_auth_repository.dart';

final clientAuthControllerProvider = Provider((ref) {
  final clientAuthRepository = ref.watch(clientAuthRepositoryProvider);
  return ClientAuthController(
      clientAuthRepository: clientAuthRepository, ref: ref);
});

final clientDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(clientAuthControllerProvider);
  return authController.getClientData();
});

class ClientAuthController {
  final ClientAuthRepository clientAuthRepository;
  final ProviderRef ref;
  ClientAuthController({
    required this.clientAuthRepository,
    required this.ref,
  });

  Future<bool> signInWithEmailAndPassword(
      String aui, String email, String password) async {
    return await clientAuthRepository.signInWithEmailAndPassword(
        aui, email, password);
  }

  Future<Client?> getClientData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminUid = prefs.getString('adminUid');
    Client? client = await clientAuthRepository.getCurrentClientData(adminUid);
    return client;
  }

  void setUserState(String auid, bool isOnline) {
    clientAuthRepository.setUserState(auid, isOnline);
  }
}
