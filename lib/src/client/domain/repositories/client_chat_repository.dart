import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/admin/domain/models/chat.dart';
import 'package:trackmyclients_app/src/admin/domain/models/client.dart';
import 'package:trackmyclients_app/src/admin/domain/models/user.dart';
import 'package:uuid/uuid.dart';

import '../../../admin/domain/models/message.dart';
import '../../../utils/enums/message_enum.dart';

final clientChatRepositoryProvider = Provider(
  (ref) => ClientChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ClientChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ClientChatRepository({required this.firestore, required this.auth});

  // Stream<List<ChatContact>> getChatContacts() {
  //   return firestore
  //       .collection('users')
  //       .doc(auth.currentUser!.uid)
  //       .collection('chats')
  //       .orderBy('timeSent', descending: true)
  //       .snapshots()
  //       .asyncMap((event) async {
  //     List<ChatContact> contacts = [];
  //     for (var document in event.docs) {
  //       var chatContact = ChatContact.fromMap(document.data());
  //       var clientData = await firestore
  //           .collection('users')
  //           .doc(auth.currentUser!.uid)
  //           .collection('clients')
  //           .doc(chatContact.contactId)
  //           .get();
  //       var client = ClientData.fromMap(clientData.data()!);

  //       contacts.add(
  //         ChatContact(
  //           name: client.name!,
  //           profilePic: client.profilePic!,
  //           contactId: chatContact.contactId,
  //           timeSent: chatContact.timeSent,
  //           lastMessage: chatContact.lastMessage,
  //         ),
  //       );
  //     }
  //     return contacts;
  //   });
  // }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void sendTextMessage(
      {required BuildContext context,
      required String message,
      required String recieverUserId,
      required ClientData senderUser,
      
      }) async {
    try {
      DateTime timeSent = DateTime.now();

      var clientDataMap = await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('clients')
          .doc(auth.currentUser!.uid)
          .get();
      ClientData receiverClientData = ClientData.fromMap(clientDataMap.data()!);
      String messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
        senderUser,
        receiverClientData,
        message,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: message,
        timeSent: timeSent,
        messageId: messageId,
        messageType: MessageEnum.text,
        username: senderUser.name!,
        recieverUserName: receiverClientData.name,
      );
    } catch (e) {}
  }

  void _saveDataToContactsSubcollection(
    ClientData senderUserData,
    ClientData? recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    ChatContact recieverChatContact = ChatContact(
      name: senderUserData.name!,
      profilePic:
          senderUserData.profilePic!,
      contactId: senderUserData.id!,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('clients')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(
          recieverChatContact.toMap(),
        );
    // users -> current user id  => chats -> reciever user id -> set data
    var senderChatContact = ChatContact(
      name: recieverUserData!.name!,
      profilePic: recieverUserData.profilePic!,
      contactId: recieverUserData.id!,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required String? recieverUserName,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    // users -> sender id -> reciever id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
    // users -> reciever id  -> sender id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('clients')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }
}
