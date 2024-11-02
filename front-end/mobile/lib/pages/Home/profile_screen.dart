// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/google_sign_in_service.dart';
import 'package:flutter/services.dart';

import '../WelcomePage/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String uid;
  final GoogleSignInService _googleSignInService =
  GoogleSignInService(); // Service defined here
  ProfileScreen(
      {super.key, required this.name, required this.email, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name; // Set Google name
    _emailController.text = widget.email; // Set Google email
    _idController.text = widget.uid;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile picture
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(File(_profileImage!.path))
                              : null,
                          child: _profileImage == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Text fields
                  _buildTextField(_nameController, 'Tên', Icons.person),
                  const SizedBox(height: 10),
                  _buildTextField(_emailController, 'Email', Icons.email),
                  const SizedBox(height: 10),
                  _buildTextField(
                      _idController, 'ID người dùng', Icons.account_box),
                ],
              ),
            ),
          ),

          // Button Section: Logout at bottom center, matching TextField width
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: SizedBox(
              width: double.infinity, // Ensures width matches TextField
              child: OutlinedButton(
                onPressed: () async {
                  await widget._googleSignInService.signOut(); // Wait for sign-out to complete
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Colors.redAccent, width: 1.5), // Red border
                  padding:
                      const EdgeInsets.all(16.0), // Same padding as text fields
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  backgroundColor: Colors.transparent,
                ),
                child: const Text(
                  'Đăng xuất',
                  style: TextStyle(
                    color: Colors.redAccent, // Red text
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Helper method to build a styled text field
  Widget _buildTextField(
      TextEditingController? controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      readOnly: true, // Optional: Make it non-editable if it's only for display and copy
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0), // Smaller padding for the icon
          child: GestureDetector(
            onTap: () {
              if (controller?.text.isNotEmpty ?? false) {
                Clipboard.setData(ClipboardData(text: controller!.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã sao chép')),
                );
              }
            },
            child: Icon(
              Icons.copy,
              size: 18, // Smaller size for a subtler look
              color: Colors.grey.shade600, // Softer grey color
            ),
          ),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 116, 192, 252).withOpacity(0.5),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 116, 192, 252).withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
            width: 1.5,
          ),
        ),
      ),
      onTap: () {
        if (controller?.text.isNotEmpty ?? false) {
          Clipboard.setData(ClipboardData(text: controller!.text));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã sao chép')),
          );
        }
      },
    );
  }


}
