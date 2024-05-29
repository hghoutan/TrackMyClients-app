import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmyclients_app/src/admin/presentation/widgets/features/chat/video_player.dart';

import '../../../../../utils/enums/message_enum.dart';

class DisplayTextImage extends StatefulWidget {
  final String message;
  final MessageEnum type;
  final bool isClientSide;
  const DisplayTextImage(
      {super.key,
      required this.message,
      required this.type,
      this.isClientSide = false});

  @override
  State<DisplayTextImage> createState() => _DisplayTextImageState();
}

class _DisplayTextImageState extends State<DisplayTextImage> {
  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return widget.type == MessageEnum.text
        ? Text(
            widget.message,
            style: TextStyle(
              fontSize: 16,
              color: widget.isClientSide ? null : Colors.white,
            ),
          )
        : widget.type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  constraints: const BoxConstraints(
                    minWidth: 100,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer.play(UrlSource(widget.message));
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                    child: Icon(
                      isPlaying ? FontAwesomeIcons.circlePause
                      : FontAwesomeIcons.circlePlay,
                      color: widget.isClientSide ? null : Colors.white,
                    ),
                  ),
                );
              })
            : widget.type == MessageEnum.video
                ? VideoPlayer(
                    videoUrl: widget.message,
                  )
                : CachedNetworkImage(
                    imageUrl: widget.message,
                  );
  }
}
