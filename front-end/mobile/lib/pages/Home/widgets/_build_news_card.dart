import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String? title;
  final String? category;
  final String? sourceName;
  final String? urlImage; // This should be the image URL or asset path
  final Color color; // You can still keep this if you need a fallback color

  const NewsCard({
    super.key,
    required this.title,
    required this.category,
    required this.sourceName,
    required this.urlImage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _buildOfferCard(title, category, sourceName, urlImage);
  }

  Widget _buildOfferCard(
      String? title,
      String? category,
      String? sourceName,
      String? urlImage,
      ) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: urlImage != null ? NetworkImage(urlImage) : const AssetImage('assets/logo.png'),
          fit: BoxFit.cover, // Adjust how the image fits the container
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.black54, // Optional: Add a semi-transparent overlay for better text visibility
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildCategoryTag(category!),
            const SizedBox(height: 8),
            Text(
              sourceName!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTag(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
