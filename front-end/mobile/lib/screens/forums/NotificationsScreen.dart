import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông Báo')),
      body: ListView.builder(
        itemCount: 5, // Giả lập 5 thông báo
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Thông báo ${index + 1}'),
            subtitle: const Text('Có người đã bình luận bài viết của bạn.'),
            trailing: const Text('10 phút trước'),
          );
        },
      ),
    );
  }
}