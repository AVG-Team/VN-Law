import 'package:video_player/video_player.dart';

class VideoLoader {
  // Tạo instance duy nhất của VideoLoader
  static final VideoLoader _instance = VideoLoader._internal();

  // Biến lưu trữ VideoPlayerController
  late VideoPlayerController _controller;

  // Factory constructor để trả về instance duy nhất
  factory VideoLoader() {
    return _instance;
  }

  // Hàm khởi tạo private
  VideoLoader._internal() {
    _controller = VideoPlayerController.asset('assets/loading.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true); // Thiết lập video lặp lại
        _controller.play(); // Tự động phát video khi khởi tạo
      });
  }

  // Getter để truy cập controller từ bên ngoài
  VideoPlayerController get controller => _controller;
}