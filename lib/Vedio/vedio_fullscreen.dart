import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoScreen extends StatelessWidget {
  final VideoPlayerController videoController;

  const FullScreenVideoScreen({super.key, required this.videoController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Vedio Player",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: videoController.value.aspectRatio,
          child: VideoPlayer(videoController),
        ),
      ),
    );
  }
}
