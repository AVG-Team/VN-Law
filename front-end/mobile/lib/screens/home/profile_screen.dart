import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/api_service/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../utils/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _profileImage;
  String? userName;
  String? userEmail;
  String? profileImage = "assets/user_avatar.png";
  String? role;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return NetworkImage(imagePath);
    } else if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }

  void getUserData() async {
    print("Getting user data");

    // Thực hiện các tác vụ bất đồng bộ trước
    String? name = await SPUtill.getValue(SPUtill.keyName);
    String? email = await SPUtill.getValue(SPUtill.keyEmail);
    String? image = await SPUtill.getValue(SPUtill.keyProfileImage);
    bool isAdmin = await SPUtill.getBoolValue(SPUtill.keyIsAdmin) ?? false;

    // Sau đó mới gọi setState để cập nhật UI
    setState(() {
      userName = name;
      userEmail = email;
      profileImage = image;
      role = isAdmin ? "Admin" : "User";
    });
  }

  @override
  void initState() {
    super.initState();
    print("1234");
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ApiService.logOutFunctionality(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _getImageProvider(profileImage!),
                    child: (profileImage == null)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoTile('Tên', userName ?? 'N/A'),
            _buildInfoTile('Email', userEmail ?? 'N/A'),
            _buildInfoTile('Role', role ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã sao chép')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}