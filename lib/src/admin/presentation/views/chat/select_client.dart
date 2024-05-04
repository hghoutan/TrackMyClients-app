import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/admin/domain/models/client.dart';
import 'package:trackmyclients_app/src/admin/presentation/views/chat/chat_screen.dart';
import 'package:trackmyclients_app/src/utils/functions/next_screen.dart';

import '../../../domain/controllers/client_controller.dart';

class SelectClientsScreen extends ConsumerWidget {
  const SelectClientsScreen({super.key});

  void selectClien(BuildContext context, String id) {
    nextScreenAnimation(context, ChatScreen(id: id),rootNavgation: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select client'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<ClientData>>(
              stream: ref.read(clientControllerProvider).fetchAllClients(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  const Center(child: CircularProgressIndicator());
                }
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final client = snapshot.data![index];
                    return InkWell(
                      onTap: () => selectClien(context, client.id!),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: ListTile(
                          title: Text(
                            client.name!,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 18
                            )
                          ),
                          leading: client.profilePic == null
                              ? null
                              : CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(client.profilePic!),
                                  radius: 30,
                                ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) =>
                    const Divider(
                      color: Colors.black12,
                      indent: 85,
                      height: 0,
                      thickness: .5,
                    )
                );
              }
            ),
    );
  }
}
