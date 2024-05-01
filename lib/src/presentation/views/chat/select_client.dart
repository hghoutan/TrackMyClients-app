import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackmyclients_app/src/domain/models/client.dart';
import 'package:trackmyclients_app/src/domain/repositories/client_repository.dart';
import 'package:trackmyclients_app/src/presentation/views/chat/chat_screen.dart';
import 'package:trackmyclients_app/src/utils/functions/next_screen.dart';

class SelectClientsScreen extends ConsumerWidget {
  const SelectClientsScreen({super.key});

  void selectClien(BuildContext context, ClientData clientInfo) {
    nextScreenAnimation(context, ChatScreen(client: clientInfo),rootNavgation: true);
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
      body: ref.watch(getClientsProvider).when(
            data: (clientList) => ListView.separated(
              itemCount: clientList.length,
              itemBuilder: (context, index) {
                final client = clientList[index];
                return InkWell(
                  onTap: () => selectClien(context, client),
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
                              backgroundImage: NetworkImage(client.profilePic!),
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
            ),
            error: (err, trace) => const SizedBox(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
