import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TrailerScreen extends StatefulWidget {
  final String trailerUrl;

  const TrailerScreen({required this.trailerUrl, Key? key}) : super(key: key);

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.trailerUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _seekForward() {
    _controller.seekTo(_controller.value.position + Duration(seconds: 10));
  }

  void _seekBackward() {
    _controller.seekTo(_controller.value.position - Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Trailer", style: TextStyle(color: Colors.orangeAccent)),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(color: Colors.orangeAccent),
          ),
          Positioned(
            bottom: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.replay_10, color: Colors.white, size: 36),
                  onPressed: _seekBackward,
                ),
                IconButton(
                  icon: Icon(
                      _isPlaying ? Icons.pause_circle_filled : Icons.play_arrow,
                      color: Colors.white,
                      size: 48),
                  onPressed: _togglePlayPause,
                ),
                IconButton(
                  icon: Icon(Icons.forward_10, color: Colors.white, size: 36),
                  onPressed: _seekForward,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
