import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  
}