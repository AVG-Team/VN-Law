import 'package:flutter/material.dart';

class ServiceIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Widget destination;

  const ServiceIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: _buildServiceIcon(icon, color),
    );
  }

  Widget _buildServiceIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

}