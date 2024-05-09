import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/utils.dart';
import '../../presentation/views/call/call.dart';
import '../models/call.dart';


final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('calls').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
    Call senderCallData,
    BuildContext context,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('calls')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toMap());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelId: senderCallData.callId,
            call: senderCallData,
          ),
        ),
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }


  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

}