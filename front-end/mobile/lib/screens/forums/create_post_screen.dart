import 'package:VNLAW/screens/forums/services/post_service.dart';
import 'package:flutter/material.dart';

import '../../data/models/user_info.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  CreatePostScreenState createState() => CreatePostScreenState();
}

class CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  UserInfo? _userInfo;

  @override
  Future<void> initState() async {
    super.initState();
    _initializeUserInfo();
  }

  Future<void> _initializeUserInfo() async {
    final userInfo = await UserInfo.initialize();
    setState(() {
      _userInfo = userInfo;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await PostService.createPost(_title, _content, _userInfo!.accessToken);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tạo bài thất bại: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo Bài Viết')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
                onChanged: (value) => _title = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nội dung'),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập nội dung' : null,
                onChanged: (value) => _content = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Đăng Bài'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}