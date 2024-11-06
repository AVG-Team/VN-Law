import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import '../../../models/post_model.dart';
import '../../../services/auth_provider.dart';

class UploadPostWidget extends StatefulWidget {
  const UploadPostWidget({super.key});

  @override
  State<UploadPostWidget> createState() => _UploadPostWidgetState();
}

class _UploadPostWidgetState extends State<UploadPostWidget> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref('posts');

  @override
  void dispose() {
    _questionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _uploadPost(String idUser, String nameUser) async {
    if (idUser.isNotEmpty &&
        _questionController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      DatabaseReference newPostRef = _postsRef.push();
      String nodeKey = newPostRef.key ?? '';

      final post = {
        'idUser': idUser,
        'nameUser': nameUser,
        'question': _questionController.text,
        'content': _contentController.text,
        'imageURL': "assets/author1.jpg",
        'votes': 0,
        'createdAt': DateTime.now().toString(),
        'replies': [],
        'nodeKey': newPostRef.key,
        'pin': 0,
      };

      try {
        await newPostRef.set(post);

        Question newQuestion = Question(
          question: _questionController.text,
          content: _contentController.text,
          idUser: idUser,
          nameUser: nameUser,
          imageURL: "assets/author1.jpg",
          votes: 0,
          createdAt: DateTime.now().toString(),
          nodeKey: nodeKey,
          pin: 0,
          votedUserIds: [],
        );

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.greenAccent),
                SizedBox(width: 8),
                Text(
                  "Post uploaded successfully!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        _questionController.clear();
        _contentController.clear();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Failed to upload post: $error",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 4), // Hiển thị lâu hơn
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amberAccent, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Please fill in all fields",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderCustom>(
      builder: (context, auth, child) {
        final user = auth.userModel;

        return Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Upload Post",
                        style: TextStyle(
                          color: Color.fromARGB(255, 116, 192, 252),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      labelText: "Question",
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 116, 192, 252)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Content",
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 116, 192, 252)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _uploadPost(user?.uid ?? 'Anonymous',
                          user?.displayName ?? 'Anonymous'),
                      icon: const Icon(Icons.upload, color: Colors.white),
                      label: const Text("Upload",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
