import 'package:flutter/material.dart';

import '../../../../../utils/enums/message_enum.dart';
import 'display_text_image.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45, minWidth: 110),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          surfaceTintColor: Colors.white,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              type == MessageEnum.image ?
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
                child: DisplayTextImage(message: message, type: type, isClientSide: true,)
                  ,
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
