import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmyclients_app/src/admin/domain/models/admin.dart';
import 'package:trackmyclients_app/src/client/domain/controllers/admin_controller.dart';
import 'package:trackmyclients_app/src/client/domain/controllers/client_auth_controller.dart';

import '../../../admin/presentation/widgets/features/chat/bottom_chat_field.dart';
import '../../../admin/presentation/widgets/features/chat/chat_list.dart';

class ClientChatScreen extends ConsumerStatefulWidget {
  final String id;
  const ClientChatScreen({required this.id, super.key});

  @override
  ConsumerState<ClientChatScreen> createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends ConsumerState<ClientChatScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(clientAuthControllerProvider).setUserState(widget.id, true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(clientAuthControllerProvider).setUserState(widget.id, false);
        break;

      case AppLifecycleState.hidden:
        ref.read(clientAuthControllerProvider).setUserState(widget.id, false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // use it to establish data by loading it here
    ref.read(clientDataAuthProvider).whenData((value) => value);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: StreamBuilder<Admin>(
            stream: ref.read(adminControllerProvider).getclientData(widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
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
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/trackmyclients-app.appspot.com/o/profilePic%2FELmMPgAkv5e3ydOmOcodSnb1Xc72?alt=media&token=9cfca187-e17e-4fb3-a28c-6976ff2fb786',
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
                          '${snapshot.data!.firstName!} ${snapshot.data!.lastName!}',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        snapshot.data?.isOnline! == null
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
                            : snapshot.data!.isOnline!
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
            onPressed: () {},
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
            child: ChatList(
              recieverUserId: widget.id,
              isFromClientSide: true,
            ),
          ),
          BottomChatField(
            recieverUserId: widget.id,
            isFromClientSide: true,
          ),
        ],
      ),
    );
  }
}
