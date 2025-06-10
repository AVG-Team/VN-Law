import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/models/legal_document.dart';
import '../../data/models/response/api_response_law_service.dart';
import '../../utils/app_const.dart';
import '../../utils/shared_preferences.dart';

class LegalDocumentProvider with ChangeNotifier {
  List<LegalDocument> _documents = [];
  int _currentPage = 1;
  int _totalPages = 1;
  int _pageSize = 10;
  bool _isLoading = false;
  bool _showFilter = false;
  String _searchQuery = '';
  String _selectedType = 'All';
  String _sortOrder = 'Mới nhất';
  String _accessToken = '';

  List<LegalDocument> get documents => _documents;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get pageSize => _pageSize;
  bool get isLoading => _isLoading;
  bool get showFilter => _showFilter;
  String get searchQuery => _searchQuery;
  String get selectedType => _selectedType;
  String get sortOrder => _sortOrder;

  final List<String> documentTypes = ['All', 'Luật', 'Nghị định', 'Quyết định', 'Thông tư', 'Chính trị'];

  // Load access token từ SharedPreferences
  Future<void> _loadAccessToken() async {
    try {
      _accessToken = await SPUtill.getValue(SPUtill.keyAuthToken) ?? '';
      print('Access token loaded: $_accessToken');
    } catch (e) {
      print('Error loading access token: $e');
    }
  }

  Map<String, String> _getHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_accessToken';
      print('Added Authorization header');
    } else {
      print('No access token available');
    }

    return headers;
  }
  Future<void> fetchDocuments() async {
    _isLoading = true;
    notifyListeners();
    await _loadAccessToken();
    if (_accessToken.isEmpty) {
      print('Access token is null, cannot fetch documents');
      _isLoading = false;
      notifyListeners();
      return;
    }

    String url = '${AppConst.apiLawUrl}/law/api/vbqppl/search?pageNo=${_currentPage - 1}&pageSize=$_pageSize';

    if (_searchQuery.isNotEmpty) {
      url += '&keyword=$_searchQuery';
    }

    if (_selectedType != 'All') {
      String typeParam = _selectedType.toLowerCase();
      url += '&type=$typeParam';
    }

    if (_sortOrder == 'Mới nhất') {
      url += '&sort=desc';
    } else if (_sortOrder == 'Cũ nhất') {
      url += '&sort=asc';
    } else if (_sortOrder == 'Tên văn bản') {
      url += '&sort=title';
    }

    print('Fetching URL: $url');

    try {
      final response = await http.get(
          Uri.parse(url),
          headers: _getHeaders()
      );
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final apiResponse = ApiResponse.fromJson(jsonDecode(decodedBody));
        print(apiResponse.toString());
        _documents = apiResponse.content;
        _totalPages = apiResponse.totalPages;
        print("Documents: ${_documents.length} items");
        print("Total Pages: $_totalPages");
      } else {
        print('Failed to fetch documents: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching documents: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void applyFilters() {
    _currentPage = 1;
    fetchDocuments();
  }

  void setPageSize(int size) {
    _pageSize = size;
    applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedType(String type) {
    _selectedType = type;
    applyFilters();
  }

  void setSortOrder(String order) {
    _sortOrder = order;
    applyFilters();
  }

  void toggleFilter() {
    _showFilter = !_showFilter;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < _totalPages) {
      _currentPage++;
      fetchDocuments();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      fetchDocuments();
    }
  }
}