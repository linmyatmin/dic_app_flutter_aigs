import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoViewer extends StatefulWidget {
  // const VideoViewer({super.key});
  const VideoViewer({Key? key, required this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    // _initializeVideoPlayerFuture =
    //     _videoPlayerController.initialize().then((_) {
    //   _videoPlayerController.play();
    //   _videoPlayerController.setLooping(true);
    //   setState(() {});
    // });

    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true);

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // return AspectRatio(
            //   aspectRatio: _videoPlayerController.value.aspectRatio,
            //   child: VideoPlayer(_videoPlayerController),
            // );
            return AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: Chewie(controller: _chewieController),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
