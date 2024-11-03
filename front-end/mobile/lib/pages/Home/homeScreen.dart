import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Black Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.grid_view_rounded, color: Colors.white),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(Icons.notifications_none, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Welcome Text in black section
                  const Text(
                    'Welcome 👋',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Nếu bạn cần trợ giúp về pháp luật?',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // White Section with Border
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Service Categories
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildServiceCategory(
                              'Tra Cứu\nPháp Luật',
                              Icons.search_rounded,
                              Colors.red[50]!,
                              Colors.red,
                            ),
                            _buildServiceCategory(
                              'Chatbot\nPháp Luật',
                              Icons.wechat_outlined,
                              Colors.orange[50]!,
                              Colors.orange,
                            ),
                            _buildServiceCategory(
                              'Văn Bản\nPháp Luật',
                              Icons.document_scanner_outlined,
                              Colors.blue[50]!,
                              Colors.blue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // News Section
                        const Text(
                          'Tin tức hằng ngày',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // News Tags
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildOfferTag('Mới Nhất', Colors.green, true),
                              _buildOfferTag('Pháp Luật', Colors.grey[300]!, false),
                              _buildOfferTag('Đời Sống', Colors.grey[300]!, false),
                              _buildOfferTag('An Ninh', Colors.grey[300]!, false),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // News Cards
                        SizedBox(
                          height: 120,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildOfferCard(
                                  '40% OFF',
                                  'On First Cleaning Service',
                                  Colors.green,
                                ),
                                const SizedBox(width: 16),
                                _buildOfferCard(
                                  '15% OFF',
                                  'Moving Service',
                                  Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Other Services
                        const Text(
                          'Các Dịch Vụ Khác',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Service Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildServiceIcon(Icons.cleaning_services, Colors.green),
                            _buildServiceIcon(Icons.person_outline, Colors.blue),
                            _buildServiceIcon(Icons.local_shipping_outlined, Colors.purple),
                            _buildServiceIcon(Icons.more_horiz, Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Rest of the widget builder methods remain the same
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