import 'package:flutter/material.dart';

import '../../../../../utils/enums/message_enum.dart';
import 'display_text_image.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final bool isSeen;

  const MyMessageCard(
      {super.key,
      required this.message,
      required this.date,
      required this.type,
      required this.isSeen
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45, minWidth: 110,
            minHeight: 50
          ),
            
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Theme.of(context).colorScheme.primary,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              type != MessageEnum.text ?
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                clipBehavior: Clip.hardEdge,
                // padding: const EdgeInsets.all(8.0),
                child: DisplayTextImage(message: message, type: type),
              ) :
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ),
                child: DisplayTextImage(
                            message: message,
                            type: type,
                          ),
              ),
              Positioned(
                bottom: type == MessageEnum.image ? 10 : 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                     Icon(
                      isSeen ? Icons.done_all : Icons.done,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
