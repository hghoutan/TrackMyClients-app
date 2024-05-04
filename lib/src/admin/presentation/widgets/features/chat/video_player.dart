import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  const VideoPlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late CachedVideoPlayerPlusController videoPlayerController;
  bool isPlay = false;
  final ValueNotifier<double> aspectRatio = ValueNotifier<double>(16 / 9);


  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(widget.videoUrl),
      invalidateCacheIfOlderThan: const Duration(days: 69),
    )..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });

    // for aspect ratio 
    videoPlayerController.addListener(() {
      final double videoWidth = videoPlayerController.value.size.width;
      final double videoHeight = videoPlayerController.value.size.height;
      final double aspectRatioValue = videoWidth / videoHeight;
      aspectRatio.value = aspectRatioValue;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio.value,
      child: Stack(
        children: [
          CachedVideoPlayerPlus(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlay) {
                  videoPlayerController.pause();
                } else {
                  videoPlayerController.play();
                }
                setState(() {
                  isPlay = !isPlay;
                });
              },
              icon: Icon(
                isPlay
                    ? FontAwesomeIcons.circlePause
                    : FontAwesomeIcons.circlePlay,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
