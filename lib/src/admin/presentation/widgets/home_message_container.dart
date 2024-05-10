import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/models/chat.dart';

class HomeMessageContainer extends StatelessWidget {
  final ChatContact chat;
  final String timeSent;
  final bool active;
  const HomeMessageContainer(
      {required this.active, required this.chat, super.key, required this.timeSent});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
          color: const Color(0xfff0f0f0),
          borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
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
                imageUrl: chat.profilePic,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Client: ${chat.name}',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      Text(
                        timeSent,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          chat.lastMessage,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                color: Colors.black,
                                fontWeight:
                                    active ? FontWeight.w700 : FontWeight.w400,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      active
                          ? Container(
                              height: 10,
                              width: 10,
                              padding: const EdgeInsets.only(left: 4.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
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
    );
  }
}
