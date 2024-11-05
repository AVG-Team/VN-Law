import 'package:flutter/material.dart';

class NewsTag extends StatelessWidget {

  final String text;
  final Color color;
  final bool isSelected;

  const NewsTag({
    super.key,
    required this.text,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _buildOfferTag(text, color, isSelected);
  }

  Widget _buildOfferTag(String text, Color color, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey[300]!,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

}