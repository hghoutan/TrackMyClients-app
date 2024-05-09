import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/call.dart';
import '../repositories/call_repository.dart';
import 'auth_controller.dart';


final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall(BuildContext context, String receiverName, String receiverUid,
      String receiverProfilePic) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();

      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: '${value!.firstName} ${value.lastName}',
        callerPic: 'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: true,
      );

      Call recieverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: '${value.firstName} ${value.lastName}',
        callerPic: 'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: false,
      );
      
        callRepository.makeCall(senderCallData, context, recieverCallData);
      
    });
  }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) {
    callRepository.endCall(callerId, receiverId, context);
  }
}
//