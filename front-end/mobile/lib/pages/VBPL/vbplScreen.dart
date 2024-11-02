import 'package:flutter/material.dart';

// Data model cho TreeView
class TreeNode {
  final String id;
  final String title;
  final IconData? icon;
  final List<TreeNode> children;
  final String content;

  TreeNode({
    required this.id,
    required this.title,
    this.icon,
    this.children = const [],
    this.content = '',
  });
}

class VbplScreen extends StatefulWidget {
  const VbplScreen({super.key});

  @override
  State<VbplScreen> createState() => _VbplScreenState();
}

class _VbplScreenState extends State<VbplScreen> {
  bool _isSidebarOpen = true;
  String _selectedNodeId = '';
  final Map<String, bool> _expandedNodes = {};

  // Sample data
  final List<TreeNode> treeData = [
    TreeNode(
      id: '1',
      title: 'Bộ luật dân sự',
      icon: Icons.book,
      content: 'Nội dung bộ luật dân sự...',
      children: [
        TreeNode(
          id: '1.1',
          title: 'Chương I: Những quy định chung',
          content: 'Nội dung chương I...',
          children: [
            TreeNode(
              id: '1.1.1',
              title: 'Điều 1: Phạm vi điều chỉnh',
              content: 'Bộ luật này quy định địa vị pháp lý, chuẩn mực pháp lý về cách ứng xử của cá nhân, pháp nhân...',
            ),
          ],
        ),
        TreeNode(
          id: '1.2',
          title: 'Chương II: Quyền sở hữu',
          content: 'Nội dung chương II...',
        ),
      ],
    ),
    TreeNode(
      id: '2',
      title: 'Bộ luật hình sự',
      icon: Icons.gavel,
      content: 'Nội dung bộ luật hình sự...',
      children: [
        TreeNode(
          id: '2.1',
          title: 'Phần chung',
          content: 'Nội dung phần chung...',
        ),
      ],
    ),
  ];

  TreeNode? _findNodeById(String id, List<TreeNode> nodes) {
    for (var node in nodes) {
      if (node.id == id) return node;
      if (node.children.isNotEmpty) {
        final found = _findNodeById(id, node.children);
        if (found != null) return found;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isSidebarOpen ? Icons.menu_open : Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSidebarOpen = !_isSidebarOpen;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Tra cứu văn bản pháp luật',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    // Sidebar
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _isSidebarOpen ? 300 : 0,
                      child: _isSidebarOpen
                          ? Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Search Box
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Tìm kiếm...',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            // TreeView
                            Expanded(
                              child: SingleChildScrollView(
                                child: _buildTreeView(treeData),
                              ),
                            ),
                          ],
                        ),
                      )
                          : null,
                    ),

                    // Content Area
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_selectedNodeId.isNotEmpty) ...[
                              Text(
                                _findNodeById(_selectedNodeId, treeData)?.title ?? '',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _findNodeById(_selectedNodeId, treeData)?.content ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ] else
                              const Center(
                                child: Text(
                                  'Vui lòng chọn một mục để xem nội dung',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTreeView(List<TreeNode> nodes, {double indent = 0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nodes.map((node) {
        bool isExpanded = _expandedNodes[node.id] ?? false;

        return Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _selectedNodeId = node.id;
                  if (node.children.isNotEmpty) {
                    _expandedNodes[node.id] = !isExpanded;
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: indent,
                  right: 16,
                  top: 12,
                  bottom: 12,
                ),
                color: _selectedNodeId == node.id
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.transparent,
                child: Row(
                  children: [
                    if (node.children.isNotEmpty)
                      Icon(
                        isExpanded ? Icons.expand_more : Icons.chevron_right,
                        size: 20,
                        color: Colors.grey,
                      ),
                    if (node.icon != null) ...[
                      const SizedBox(width: 8),
                      Icon(node.icon, size: 20, color: Colors.blue),
                    ],
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        node.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _selectedNodeId == node.id
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (node.children.isNotEmpty && isExpanded)
              _buildTreeView(node.children, indent: indent + 24),
          ],
        );
      }).toList(),
    );
  }
}