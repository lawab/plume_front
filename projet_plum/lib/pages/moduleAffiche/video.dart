import 'dart:async';

import 'package:fl_video/fl_video.dart';
import 'package:flutter/material.dart';

class Video extends StatefulWidget {
  final String lien;
  const Video({Key? key, required this.lien}) : super(key: key);

  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<Video> {
  void startTimer() {
    _videoPlayerController1 =
        VideoPlayerController.network('http://13.39.81.126:7002${widget.lien}');
  }

  static VideoPlayerController? _videoPlayerController1;
  static FlVideoPlayerController? _controller;

  @override
  void initState() {
    startTimer();
    super.initState();
    initializePlayer(_videoPlayerController1!);
  }

  static Future setdispose() async {
    _controller?.dispose();
    if (_videoPlayerController1!.value.isPlaying) {
      _videoPlayerController1!.pause();
    }
  }

  @override
  void dispose() {
    _videoPlayerController1!.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void initializePlayer(VideoPlayerController videoPlayerController) {
    _controller = FlVideoPlayerController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        controls: videoPlayerController == _videoPlayerController1
            ? MaterialControls(
                hideDuration: const Duration(minutes: 30),
                enablePlay: true,
                enableFullscreen: true,
                enableSpeed: true,
                enableVolume: true,
                enableSubtitle: true,
                enablePosition: true,
                onTap: (FlVideoTapEvent event,
                    FlVideoPlayerController controller) {
                  debugPrint(event.toString());
                },
                onDragProgress:
                    (FlVideoDragProgressEvent event, Duration duration) {
                  debugPrint('$event===$duration');
                })
            : CupertinoControls(
                hideDuration: const Duration(minutes: 30),
                enableSpeed: true,
                enableSkip: true,
                enableSubtitle: true,
                enableFullscreen: true,
                enableVolume: true,
                enablePlay: true,
                onTap: (FlVideoTapEvent event,
                    FlVideoPlayerController controller) {
                  debugPrint(event.toString());
                },
                onDragProgress:
                    (FlVideoDragProgressEvent event, Duration duration) {
                  debugPrint('$event===$duration');
                },
                remainingBuilder: (String position) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 6, 6),
                      child: Text(position,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.red)));
                },
                positionBuilder: (String position) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(6, 6, 0, 6),
                      child: Text(position,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.lightBlue)));
                },
              ),
        subtitle: Subtitles([
          Subtitle(
              index: 0,
              start: Duration.zero,
              end: const Duration(seconds: 10),
              text: ''),
          Subtitle(
              index: 0,
              start: const Duration(seconds: 10),
              end: const Duration(seconds: 20),
              text: ''),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: const Text('Fl Video Player')),
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        bottom: true,
        child: Column(children: <Widget>[
          Expanded(child: FlVideoPlayer(controller: _controller!)),
        ]),
      ),
    ));
  }
}

class ElevatedText extends StatelessWidget {
  const ElevatedText({Key? key, this.onPressed, required this.text})
      : super(key: key);
  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) =>
      ElevatedButton(onPressed: onPressed, child: Text(text));
}

class AppTheme {
  static final light = ThemeData(
      brightness: Brightness.light,
      disabledColor: Colors.grey.shade400,
      visualDensity: VisualDensity.adaptivePlatformDensity);

  static final dark = ThemeData(
      brightness: Brightness.dark,
      disabledColor: Colors.grey.shade400,
      visualDensity: VisualDensity.adaptivePlatformDensity);
}
