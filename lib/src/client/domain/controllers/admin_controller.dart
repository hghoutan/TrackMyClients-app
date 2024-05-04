import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../admin/domain/models/user.dart';
import '../repositories/admin_repository.dart';

final adminControllerProvider = Provider((ref) {
  final authRepository = ref.watch(adminRepositoryProvider);
  return ClientController(authRepository: authRepository, ref: ref);
});

class ClientController {
  final AdminRepository authRepository;
  final ProviderRef ref;
  ClientController({
    required this.authRepository,
    required this.ref,
  });

  Stream<UserData> getclientData(String adminId) {
    return authRepository.clientData(adminId);
  }
}