import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../api_service/connectivity/no_internet_screen.dart';
import 'legal_document_provider.dart';
import 'legal_document_item.dart';
import 'package:VNLAW/utils/loading.dart';

class LegalDocumentScreen extends StatefulWidget {
  const LegalDocumentScreen({super.key});

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LegalDocumentProvider()..fetchDocuments(),
      child: NoInternetScreen(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Văn bản quy phạm pháp luật'),
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(context.watch<LegalDocumentProvider>().showFilter ? Icons.filter_alt_off : Icons.filter_alt),
                    onPressed: () {
                      context.read<LegalDocumentProvider>().toggleFilter();
                    },
                  );
                },
              ),
            ],
          ),
          body: Consumer<LegalDocumentProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  // Filter Section
                  AnimatedOpacity(
                    opacity: provider.showFilter ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: provider.showFilter
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Tìm kiếm văn bản...',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              provider.setSearchQuery(value);
                            },
                            onSubmitted: (value) {
                              provider.applyFilters();
                            },
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: provider.selectedType,
                            isExpanded: true,
                            items: provider.documentTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                provider.setSelectedType(value);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: provider.sortOrder,
                            isExpanded: true,
                            items: ['Mới nhất', 'Cũ nhất', 'Tên văn bản'].map((String order) {
                              return DropdownMenuItem<String>(
                                value: order,
                                child: Text(order),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                provider.setSortOrder(value);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<int>(
                            value: provider.pageSize,
                            items: [5, 10, 12, 15, 20, 25].map((int size) {
                              return DropdownMenuItem<int>(
                                value: size,
                                child: Text('$size'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                provider.setPageSize(value);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: provider.applyFilters,
                            child: const Text('Áp dụng bộ lọc', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                  // Document List
                  Expanded(
                    child: provider.isLoading
                        ? const LoadingWidget()
                        : ListView.builder(
                      itemCount: provider.documents.length,
                      itemBuilder: (context, index) {
                        // Xóa print trong sản phẩm cuối để cải thiện hiệu suất
                        final doc = provider.documents[index];
                        return FadeTransition(
                          opacity: _animation,
                          child: LegalDocumentItem(legalDocument: doc),
                        );
                      },
                    ),
                  ),
                  // Pagination
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: provider.currentPage > 1 ? provider.previousPage : null,
                      ),
                      Text('Trang ${provider.currentPage} / ${provider.totalPages}'),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: provider.currentPage < provider.totalPages ? provider.nextPage : null,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}