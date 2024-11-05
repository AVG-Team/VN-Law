import 'package:flutter/material.dart';
class NewsCard extends StatelessWidget{

  final String discount;
  final String description;
  final Color color;

  const NewsCard({
    super.key,
    required this.discount,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _buildOfferCard(discount, description, color);
  }

  Widget _buildOfferCard(
      String discount,
      String description,
      Color color,
      ) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            discount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

}