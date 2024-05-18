import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmyclients_app/src/admin/domain/controllers/client_controller.dart';
import 'package:trackmyclients_app/src/admin/domain/models/client.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/call/call_pickup.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/features/chat/bottom_chat_field.dart';

import '../../../domain/controllers/call_controller.dart';
import '../../widgets/features/chat/chat_list.dart';

class ChatScreen extends ConsumerWidget {
  final String id;
  const ChatScreen({required this.id, super.key});

  void makeCall(
      WidgetRef ref, BuildContext context, String name, String profilePic) {
    ref.read(callControllerProvider).makeCall(
          context,
          name,
          id,
          profilePic,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late String name;
    late String profilePic;

    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: StreamBuilder<Client>(
              stream: ref.read(clientControllerProvider).clientDataById(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                name = snapshot.data!.name!;
                profilePic = snapshot.data!.profilePic!;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: profilePic,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          snapshot.data!.isOnline!
                              ? Row(
                                  children: [
                                    SizedBox(
                                      height: 9,
                                      width: 9,
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        radius: 33,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Online',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'offline',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
          actions: [
            IconButton(
              onPressed: () => makeCall(ref, context, name, profilePic),
              icon: const FaIcon(FontAwesomeIcons.video),
            ),
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.phone),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(recieverUserId: id),
            ),
            BottomChatField(recieverUserId: id),
          ],
        ),
      ),
    );
  }
}
