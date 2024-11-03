import 'package:flutter/material.dart';
import 'package:mobile/pages/Home/profile_screen.dart';
import 'package:mobile/pages/Home/widgets/_buildNewsCard.dart';
import 'package:mobile/pages/Home/widgets/_buildNewsTag.dart';
import 'package:mobile/pages/LegalDocument/legalDocumentScreen.dart';
import 'package:mobile/pages/VBPL/vbplScreen.dart';
import 'widgets/_buildServiceCategory.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(Icons.notifications_none, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),


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
                        const Text(
                          'Welcome 👋',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Text(
                          'Nếu bạn cần trợ giúp về pháp luật?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Service Categories
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ServiceCategory(
                              title: 'Tra Cứu\nPháp Luật',
                              icon:  Icons.search_rounded,
                              bgColor: Colors.red[50]!,
                              iconColor: Colors.red,
                              destination: const VbplScreen()
                            ),
                            ServiceCategory(
                              title :'Chatbot\nPháp Luật',
                              icon : Icons.wechat_outlined,
                              bgColor : Colors.orange[50]!,
                              iconColor :Colors.orange,
                              destination: ProfileScreen(name: "admin", email: "admin@admin.com"), // todo chatScreen
                            ),
                            ServiceCategory(
                              title: 'Văn Bản\nPháp Luật',
                              icon: Icons.document_scanner_outlined,
                              bgColor :Colors.blue[50]!,
                              iconColor: Colors.blue,
                              destination: const LegalDocumentScreen(),
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
                              const NewsTag(
                                  text: 'Mới Nhất',
                                  color:Colors.lightBlueAccent,
                                  isSelected: true),
                              NewsTag(text: 'Pháp Luật',
                                  color: Colors.grey[300]!,
                                  isSelected: false),
                              NewsTag(text: 'Đời sống',
                                  color: Colors.grey[300]!,
                                  isSelected: false),
                              NewsTag(text: 'An Ninh',
                                  color: Colors.grey[300]!,
                                  isSelected: false),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // News Cards
                        const SizedBox(
                          height: 120,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                NewsCard(
                                  discount: '40% OFF',
                                  description: 'On First Cleaning Service',
                                  color : Colors.green,
                                ),
                                SizedBox(width: 16),
                                NewsCard(discount: "15% OFF",
                                    description: "Moving Service",
                                    color: Colors.blueAccent)
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
                            _buildServiceIcon(Icons.forum_outlined, Colors.green),
                            _buildServiceIcon(Icons.newspaper_outlined, Colors.blue),
                            _buildServiceIcon(Icons.info_outline, Colors.purple),
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