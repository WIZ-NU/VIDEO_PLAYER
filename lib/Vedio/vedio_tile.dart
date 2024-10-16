// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:vedio_app/Vedio/vedio_fullscreen.dart';
import 'package:video_player/video_player.dart';

class VideoTile extends StatefulWidget {
  final String videoAsset;

  const VideoTile({super.key, required this.videoAsset});

  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize().then((_) {
        setState(
            () {}); // Ensure the first frame is shown after the video is initialized
      }).catchError((error) {
        print('Error initializing video: $error');
      });
    _controller.addListener(_videoListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _videoListener() {
    final isPlaying = _controller.value.isPlaying;
    if (isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isPlaying) {
          _controller.play();
        } else {
          _controller.pause();
        }
      },
      child: Card(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(),
            if (!_isPlaying)
              const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  _controller.pause();
                  _openFullscreen(context);
                },
                child: const Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFullscreen(BuildContext context) {
    _controller.setVolume(5.0); // Enable audio playback
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenVideoScreen(
          videoController: _controller,
        ),
      ),
    );
    _controller.setVolume(1.0);
    _controller.setPlaybackSpeed(1.0);
    _controller.setLooping(true);
    _controller.play();
  }
}
