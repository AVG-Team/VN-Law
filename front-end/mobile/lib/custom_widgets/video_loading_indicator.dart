import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoLoadingIndicator extends StatefulWidget {
  final String videoAssetPath;
  final double width;
  final double height;

  const VideoLoadingIndicator({
    super.key,
    required this.videoAssetPath,
    this.width = 100.0,
    this.height = 100.0,
  });

  @override
  State<VideoLoadingIndicator> createState() => _VideoLoadingIndicatorState();
}

class _VideoLoadingIndicatorState extends State<VideoLoadingIndicator> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với asset video
    _controller = VideoPlayerController.asset(widget.videoAssetPath);

    // Cấu hình video để tự động lặp lại
    _controller.setLooping(true);

    // Khởi tạo controller và bắt đầu phát video
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Đảm bảo các widget được rebuild sau khi video đã sẵn sàng
      if (mounted) setState(() {});
      _controller.play();
    });
  }

  @override
  void dispose() {
    // Giải phóng tài nguyên khi widget bị hủy
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: VideoPlayer(_controller),
        );
      },
    );
  }
}
