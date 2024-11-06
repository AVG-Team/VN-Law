import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile/constants/base_url.dart';

import 'launch_url.dart';

class TreeNode {
  final String id;
  final String title;
  final IconData? icon;
  final List<TreeNode> children;
  final bool isLeaf;
  final bool isExpanded;
  final String type;

  TreeNode({
    required this.id,
    required this.title,
    this.icon,
    this.children = const [],
    this.isLeaf = false,
    this.isExpanded = false,
    required this.type,
  });

  factory TreeNode.fromJson(Map<String, dynamic> json, String type) {
    return TreeNode(
      id: json['id'].toString(),
      title: _getTitleByType(json, type),
      children: [],
      isLeaf: type == 'chapter',
      type: type,
    );
  }

  static String _getTitleByType(Map<String, dynamic> json, String type) {
    switch (type) {
      case 'topic':
        return 'Chủ đề ${json['order']}: ${json['name']}';
      case 'subject':
        return 'Đề mục ${json['order']}: ${json['name']}';
      case 'chapter':
        return json['name'];
      default:
        return json['name'];
    }
  }
}

class VbplScreen extends StatefulWidget {
  const VbplScreen({super.key});

  @override
  State<VbplScreen> createState() => _VbplScreenState();
}

class _VbplScreenState extends State<VbplScreen> {
  bool _isSidebarOpen = false;
  List<TreeNode> treeData = [];
  bool isLoading = false;
  Set<String> expandedNodes = {};
  String? selectedNodeId;
  String? articleId;
  String? chapterName;
  Map<String, dynamic>? selectedChapter;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() => isLoading = true);
    try {
      await _fetchTopics();
      if (articleId != null) {
        await _fetchArticleData(articleId!);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchTopics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/law-service/topic'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Decode the response body as UTF-8 to handle special characters
        final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        // Check if response contains 'data' field
        if (jsonResponse.containsKey('data')) {
          final List<dynamic> topicList = jsonResponse['data'];
          setState(() {
            treeData = topicList
                .map((topic) => TreeNode.fromJson(topic, 'topic'))
                .toList();
          });
        } else {
          _showError("Invalid response format: missing data field");
        }
      } else {
        _showError("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Error fetching topics: $e");
    }
  }


  Future<void> _fetchArticleData(String id) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/law-service/article/tree/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept-Charset': 'UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _handleArticleData(data);
      }
    } catch (e) {
      _showError("Error fetching article data: $e");
    }
  }

  Future<void> _handleArticleData(Map<String, dynamic> data) async {
    final topic = data['topic'];
    final subject = data['subject'];
    final chapter = data['chapter'];
    final articles = data['articles'];

    setState(() {
      selectedChapter = {
        'id': chapter['id'],
        'name': chapter['name'],
        'articles': articles,
      };
      expandedNodes.add('topic_${topic['id']}');
      expandedNodes.add('subject_${subject['id']}');
      selectedNodeId = 'chapter_${chapter['id']}';
    });

    await _loadNodeChildren('topic_${topic['id']}');
    await _loadNodeChildren('subject_${subject['id']}');
  }

  Future<void> _loadNodeChildren(String nodeId) async {
    final nodeType = nodeId.split('_')[0];
    final id = nodeId.split('_')[1];

    String endpoint;
    String childType;

    switch (nodeType) {
      case 'topic':
        endpoint = '$baseUrl/law-service/subject/topic/$id';
        childType = 'subject';
        break;
      case 'subject':
        endpoint = '$baseUrl/law-service/chapter/subject/$id';
        childType = 'chapter';
        break;
      default:
        return;
    }

    try {
      final response = await http.get(Uri.parse(endpoint),headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept-Charset': 'UTF-8',
      },);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        if(jsonResponse.containsKey("data")) {
          final List<dynamic> children = jsonResponse['data'];
          _updateTreeDataWithChildren(
              nodeId,
              children.map((child) => TreeNode.fromJson(child, childType)).toList()
          );
        }
      }
    } catch (e) {
      _showError("Error loading children: $e");
    }
  }

  void _updateTreeDataWithChildren(String nodeId, List<TreeNode> newChildren) {
    setState(() {
      treeData = _updateChildren(treeData, nodeId, newChildren);
    });
  }

  List<TreeNode> _updateChildren(List<TreeNode> nodes, String targetId, List<TreeNode> newChildren) {
    return nodes.map((node) {
      if ('${node.type}_${node.id}' == targetId) {
        return TreeNode(
          id: node.id,
          title: node.title,
          icon: node.icon,
          children: newChildren,
          isLeaf: node.isLeaf,
          type: node.type,
        );
      } else if (node.children.isNotEmpty) {
        return TreeNode(
          id: node.id,
          title: node.title,
          icon: node.icon,
          children: _updateChildren(node.children, targetId, newChildren),
          isLeaf: node.isLeaf,
          type: node.type,
        );
      }
      return node;
    }).toList();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
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
                    _buildSidebar(),
                    _buildContentArea(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isSidebarOpen ? Icons.menu_open : Icons.menu,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
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
    );
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
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
            _buildSearchBox(),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(child: _buildTreeView(treeData)),
            ),
          ],
        ),
      )
          : null,
    );
  }

  Widget _buildSearchBox() {
    return Padding(
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
    );
  }

  Widget _buildTreeView(List<TreeNode> nodes) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        final node = nodes[index];
        final nodeId = '${node.type}_${node.id}';
        final isExpanded = expandedNodes.contains(nodeId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Thêm dòng này
          children: [
            InkWell(
              onTap: () => _handleNodeTap(node),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: selectedNodeId == nodeId
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.transparent,
                child: Row(
                  children: [
                    if (!node.isLeaf)
                      Icon(
                        isExpanded ? Icons.expand_more : Icons.chevron_right,
                        size: 20,
                        color: Colors.grey,
                      ),
                    if (node.icon != null) ...[
                      Icon(node.icon, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                    ],
                    Expanded(child: Text(node.title)),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _buildTreeView(node.children),
              ),
          ],
        );
      },
    );
  }

  Widget _buildContentArea() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedChapter != null) ...[
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              ...((selectedChapter!['articles'] as List).map((article) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article['content'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    // Link to view more details if available
                    GestureDetector(
                      onTap: () {
                        // Open the vbqpplLink if needed
                        launchUrl(Uri.parse(article['vbqpplLink']));
                      },
                      child: const Text(
                        " Xem thêm ",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Divider(height: 32, thickness: 1),
                  ],
                );
              }).toList()),
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
    );
  }


  Future<void> _fetchChapterArticles(String chapterId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/law-service/article/chapter/$chapterId'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        if (jsonResponse.containsKey('data') && jsonResponse['data'] is Map) {
          final data = jsonResponse['data'] as Map<String, dynamic>;

          setState(() {
            selectedChapter = {
              'id': chapterId,
              'name': data['name'] ?? "unknown chapter",
              'articles': data['content'] ?? [],
            };
          });
        } else {
          _showError("Error: Data field is missing or in incorrect format.");
        }
      } else {
        _showError("Error fetching chapter articles: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Error fetching chapter articles: $e");
    }
  }


  Future<void> _handleNodeTap(TreeNode node) async {
    final nodeId = '${node.type}_${node.id}';

    setState(() {
      selectedNodeId = nodeId;
      if (!node.isLeaf) {
        if (expandedNodes.contains(nodeId)) {
          expandedNodes.remove(nodeId);
        } else {
          expandedNodes.add(nodeId);
        }
      }
    });

    if (!node.isLeaf && node.children.isEmpty) {
      await _loadNodeChildren(nodeId);
    }

    if (node.isLeaf) {
        // Call the API to get the chapter data
        await _fetchChapterArticles(node.id);
    }
  }
}