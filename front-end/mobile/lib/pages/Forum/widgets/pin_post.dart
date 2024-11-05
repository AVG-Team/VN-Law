import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/post_model.dart';
import '../../../services/auth_provider.dart';
import '../post_screen.dart'; // Ensure you import the Question model.

class Pin extends StatefulWidget {
  const Pin({super.key});

  @override
  State<Pin> createState() => _PinState();
}

class _PinState extends State<Pin> {
  List<Question> questions = [
    Question(
      question: "What is Flutter?",
      content: "Flutter is an open-source UI software development toolkit.",
      votes: 12,
      imageURL: "assets/author6.jpg", // Replace with your actual image path
      nameUser: "John Doe",
      idUser: '0123456789',
      createdAt: "2024-11-05 09:45:16.674839",
      replies: [],
      nodeKey: "", // Thêm nodeKey vào dữ liệu mẫu
      pin: 1
    ),
    // Add more Question instances as needed
  ];

  List<Color> colors = [
    Colors.purple,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.orangeAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderCustom>(builder: (context, auth, child) {
      final user = auth.userModel;
      return SizedBox(
        height: 170,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: questions.length,
          itemBuilder: (BuildContext context, int index) {
            final question = questions[index];
            return GestureDetector(
              onTap: () {
                // Navigate to PostScreen with the selected question
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostScreen(question: question, currentUserId: user?.uid ?? 'N/A'),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(left: 20.0),
                height: 180,
                width: 170,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        question.question,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${question.votes} likes",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18, letterSpacing: .7),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
