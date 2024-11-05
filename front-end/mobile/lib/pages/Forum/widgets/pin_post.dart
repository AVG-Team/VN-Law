import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/post_model.dart';
import '../../../services/auth_provider.dart';
import '../post_screen.dart'; // Ensure you import the Question model.
import 'package:firebase_database/firebase_database.dart';

class Pin extends StatefulWidget {
  const Pin({super.key});

  @override
  State<Pin> createState() => _PinState();
}

class _PinState extends State<Pin> {
  final DatabaseReference postsRef = FirebaseDatabase.instance.ref("posts");
  List<Question> pinnedQuestions = [];

  List<Color> colors = [
    Colors.purple,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.orangeAccent,
  ];

  @override
  void initState() {
    super.initState();
    _loadPinnedQuestions();
  }

  Future<void> _loadPinnedQuestions() async {
    postsRef.onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      final List<Question> loadedQuestions = [];

      if (dataSnapshot.value != null) {
        final postsMap = Map<String, dynamic>.from(dataSnapshot.value as Map);
        postsMap.forEach((key, value) {
          final post = Map<String, dynamic>.from(value);
          if (post['pin'] == 1) {  // Lọc chỉ các bài có `pin = 1`
            loadedQuestions.add(Question(
              question: post['question'] ?? 'N/A',
              content: post['content'] ?? 'N/A',
              votes: post['votes'] ?? 0,
              imageURL: post['imageURL'] ?? '',
              nameUser: post['nameUser'] ?? 'Anonymous',
              idUser: post['idUser'] ?? '',
              createdAt: post['createdAt'] ?? '',
              nodeKey: key,
              pin: post['pin'] ?? 0,
              replies: post['replies'] ?? [],
            ));
          }
        });
      }

      setState(() {
        pinnedQuestions = loadedQuestions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderCustom>(builder: (context, auth, child) {
      return SizedBox(
        height: 170,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: pinnedQuestions.length,
          itemBuilder: (BuildContext context, int index) {
            final question = pinnedQuestions[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostScreen(question: question),
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
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${question.votes} likes",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: .7,
                        ),
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
