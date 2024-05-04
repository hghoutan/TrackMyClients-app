import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../info.dart';
import '../../../../domain/controllers/chat_controller.dart';
import '../../../../domain/models/chat.dart';
import '../../../../../utils/functions/next_screen.dart';
import '../../../views/chat/chat_screen.dart';

class ContactsList extends ConsumerStatefulWidget {
  const ContactsList({super.key});

  @override
  ConsumerState<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends ConsumerState<ContactsList> {
  final ScrollController messageController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatContact>>(
      stream: ref
                .read(chatControllerProvider).chatContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) => const Divider(
            color: Colors.black12,
            indent: 85,
            height: 0,
            thickness: .5,
          ),
          controller: messageController,
          itemBuilder: (context, index) {
            ChatContact messageData = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);
            return InkWell(
              onTap: () {
                nextScreenAnimation(context, ChatScreen(id: messageData.contactId),rootNavgation: true);
              },
              child: Container(
                height: 75,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          messageData.profilePic,
                        ),
                        radius: 30,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Client: ${messageData.name}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                Text(
                                  timeSent,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: !(info[index]['readed'] as bool)
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    messageData.lastMessage,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight:
                                              !(info[index]['readed'] as bool)
                                                  ? FontWeight.w700
                                                  : FontWeight.w400,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                !(info[index]['readed'] as bool)
                                    ? Container(
                                        height: 10,
                                        width: 10,
                                        padding: const EdgeInsets.only(left: 4.0),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            shape: BoxShape.circle),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }
}
