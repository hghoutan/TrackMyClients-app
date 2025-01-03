import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/client/domain/controllers/client_auth_controller.dart';
import 'package:trackmyclients_app/src/client/domain/repositories/client_chat_repository.dart';

import '../../../admin/domain/models/message.dart';
import '../../../utils/enums/message_enum.dart';

final clientChatControllerProvider = Provider((ref) {
  final clientChatRepository = ref.watch(clientChatRepositoryProvider);
  return ClientChatController(
    clientChatRepository: clientChatRepository,
    ref: ref,
  );
});


class ClientChatController {
  final ClientChatRepository clientChatRepository;
  final ProviderRef ref;
  ClientChatController({
    required this.clientChatRepository,
    required this.ref,
  });
  
  Stream<List<Message>> chatStream(String recieverUserId) {
    return clientChatRepository.getChatStream(recieverUserId);
  }
   void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
  ) {
    ref.read(clientDataAuthProvider).whenData(
          (value) => clientChatRepository.sendTextMessage(
            context: context,
            message: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
          ),
        );
  }
  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
  ) {
    ref.read(clientDataAuthProvider).whenData(
          (value) => clientChatRepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderClientData: value!,
            messageEnum: messageEnum,
            ref: ref,
            
          ),
        );
  }
  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) {
    clientChatRepository.setChatMessageSeen(
      context,
      recieverUserId,
      messageId,
    );
  }

}
