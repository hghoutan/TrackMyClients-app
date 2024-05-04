import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/admin/domain/models/user.dart';


final adminRepositoryProvider = Provider(
  (ref) => AdminRepository(
    firestore: FirebaseFirestore.instance,
  ),
);
class AdminRepository {
  final FirebaseFirestore firestore;

  AdminRepository({
    required this.firestore,
  });
  Stream<UserData> clientData(String adminId) {
    return firestore
        .collection('users')
        .doc(adminId)
        .snapshots()
        .map(
          (event) => UserData.fromMap(
            event.data()!,
          ),
        );
  }
}