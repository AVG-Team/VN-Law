import 'package:flutter/material.dart';

import '../../chat/chat_screen.dart';
import '../../legal_document/legal_document_screen.dart';
import '../../vbql/vbpl_screen.dart';
import '../../profile_screen.dart';

class Sidebar extends StatelessWidget {
  final bool isSidebarOpen;
  final VoidCallback toggleSidebar;

  const Sidebar({
    super.key,
    required this.isSidebarOpen,
    required this.toggleSidebar,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isSidebarOpen ? 300 : 0,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: toggleSidebar,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.search_rounded),
                  title: const Text('Tra Cứu Pháp Luật'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VbplScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.wechat_outlined),
                  title: const Text('Chatbot Pháp Luật'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.document_scanner_outlined),
                  title: const Text('Văn Bản Pháp Luật'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LegalDocumentScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Thông Tin Cá Nhân'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}