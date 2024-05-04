import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/enums/message_enum.dart';

class DisplayTextImage extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final bool isClientSide;
  const DisplayTextImage({
    super.key,
    required this.message,
    required this.type,
    this.isClientSide = false
  });

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    // final AudioPlayer audioPlayer = AudioPlayer();

    return type == MessageEnum.text
        ? Text(
            message,
            style:  TextStyle(
              fontSize: 16,
              color: isClientSide ? null : Colors.white,
            ),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  constraints: const BoxConstraints(
                    minWidth: 100,
                  ),
                  onPressed: () async {
                    // if (isPlaying) {
                    //   await audioPlayer.pause();
                    //   setState(() {
                    //     isPlaying = false;
                    //   });
                    // } else {
                    //   await audioPlayer.play(UrlSource(message));
                    //   setState(() {
                    //     isPlaying = true;
                    //   });
                    // }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                  ),
                );
              })
            // : type == MessageEnum.video
            //     ? VideoPlayerItem(
            //         videoUrl: message,
            //       )
            : Image.network(
                message,
            );
  }
}
