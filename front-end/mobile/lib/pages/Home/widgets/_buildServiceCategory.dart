import 'package:flutter/material.dart';

class ServiceCategory extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final Widget destination;

  const ServiceCategory({
    Key? key,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.destination
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: _buildServiceCategory(title, icon, bgColor, iconColor),
    );
  }

  Widget _buildServiceCategory(
      String title,
      IconData icon,
      Color bgColor,
      Color iconColor,
      ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 34),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
