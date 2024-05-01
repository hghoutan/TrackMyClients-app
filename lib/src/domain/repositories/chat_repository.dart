import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackmyclients_app/src/domain/models/chat.dart';
import 'package:trackmyclients_app/src/domain/models/client.dart';
import 'package:trackmyclients_app/src/domain/models/user.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({required this.firestore, required this.auth});

  void sendTextMessage(
      {required BuildContext context,
      required String message,
      required String recieverUserId,
      required UserData senderUser}) async {
    try {
      DateTime timeSent = DateTime.now();

      var clientDataMap =
          await firestore.collection('clients').doc(recieverUserId).get();
      ClientData receiverClientData = ClientData.fromMap(clientDataMap.data()!);

      _saveDataToContactsSubcollection(
        senderUser,
        receiverClientData,
        message,
        timeSent,
        recieverUserId,
      );

    } catch (e) {}
  }
  
  void _saveDataToContactsSubcollection(
    UserData senderUserData,
    ClientData? recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    ChatContact recieverChatContact = ChatContact(
        name: "${senderUserData.firstName} ${senderUserData.lastName} ",
        profilePic: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8cmFuZG9tJTIwcGVvcGxlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
        contactId: senderUserData.id!,
        timeSent: timeSent,
        lastMessage: text,
    );
    await firestore
          .collection('clients')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
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
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set(
            senderChatContact.toMap(),
          );
    }
    // void _saveMessageToMessageSubcollection({
    //   required String recieverUserId,
    //   required String text,
    //   required DateTime timeSent,
    //   required String messageId,
    //   required String username,
    //   required MessageEnum messageType,
    //   required MessageReply? messageReply,
    //   required String senderUsername,
    //   required String? recieverUserName,
    //   required bool isGroupChat,
    // }) {

    // }
  }

