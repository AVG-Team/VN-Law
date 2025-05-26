import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Data model for the legal document
class LegalDocument {
  final int id;
  final String? title;
  final String issueDate;
  final String effectiveDate;
  final String? effectiveEndDate;
  final String issuer;
  final String number;
  final int statusCode;
  final String? type;
  final String content;
  final String html;

  LegalDocument({
    required this.id,
    this.title,
    required this.issueDate,
    required this.effectiveDate,
    this.effectiveEndDate,
    required this.issuer,
    required this.number,
    required this.statusCode,
    this.type,
    required this.content,
    required this.html,
  });

  factory LegalDocument.fromJson(Map<String, dynamic> json) {
    return LegalDocument(
      id: json['id'],
      title: json['title'],
      issueDate: json['issueDate'],
      effectiveDate: json['effectiveDate'],
      effectiveEndDate: json['effectiveEndDate'],
      issuer: json['issuer'],
      number: json['number'],
      statusCode: json['statusCode'],
      type: json['type'],
      content: json['content'],
      html: json['html'],
    );
  }
}