import 'package:flutter/material.dart';
import 'package:trackmyclients_app/src/presentation/views/chat/chat_screen.dart';
import 'package:trackmyclients_app/src/utils/functions/next_screen.dart';

import '../../../../../info.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: info.length,
      separatorBuilder: (context, index) => const Divider(
        color: Colors.black12,
        indent: 85,
        height: 0,
        thickness: .5,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // nextScreenAnimation(context, const ChatScreen(),rootNavgation: true);
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
                    backgroundImage: NetworkImage(
                      info[index]['profilePic'].toString(),
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
                              'Client: ${info[index]['name']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            Text(
                              info[index]['time'].toString(),
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
                                info[index]['message'].toString(),
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
}
