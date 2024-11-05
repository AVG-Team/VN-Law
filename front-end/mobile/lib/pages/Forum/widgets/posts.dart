  import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
import 'package:mobile/models/user_model.dart';
  import 'package:provider/provider.dart';

  import '../../../models/post_model.dart';
  import '../../../services/auth_provider.dart';
  import '../post_screen.dart';

  class Posts extends StatefulWidget {
    const Posts({super.key});

    @override
    State<Posts> createState() => _PostsState();
  }

  class _PostsState extends State<Posts> {
    final DatabaseReference _postsRef = FirebaseDatabase.instance.ref('posts');
    List<Question> questions = [];

    @override
    void initState() {
      super.initState();
      fetchQuestions();
    }

    Future<void> fetchQuestions() async {
      _postsRef.onValue.listen((DatabaseEvent event) {
        final dynamic data = event.snapshot.value;

        if (data != null && data is Map) {
          List<Question> loadedQuestions = [];
          Map<Question, String> loadedNodeKeys = {};
          data.forEach((key, value) {
            if (value is Map<Object?, Object?>) {
              try {
                Map<String, dynamic> questionMap = Map<String, dynamic>.from(
                    value.map((k, v) => MapEntry(k.toString(), v)));

                Question question =
                    Question.fromJson(questionMap, key.toString());
                loadedQuestions.add(question);
                loadedNodeKeys[question] = key.toString();
              } catch (e) {
                if (kDebugMode) {
                  print("Error processing question $key: $e");
                }
              }
            }
          });

          // Sort questions by creation date
          loadedQuestions.sort((a, b) {
            return DateTime.parse(b.createdAt)
                .compareTo(DateTime.parse(a.createdAt));
          });

          setState(() {
            questions = loadedQuestions;
          });
        } else {
          if (kDebugMode) {
            print("No data available or data is not a Map");
          }
        }
      }, onError: (error) {
        if (kDebugMode) {
          print("Error fetching data: $error");
        }
      });
    }

    String formatDate(String createdAt) {
      DateTime dateTime =
          DateTime.parse(createdAt); // Nếu bạn lưu ngày dưới dạng chuỗi ISO
      final now = DateTime.now();

      // Tính toán sự khác biệt giữa hai thời điểm
      final differenceInSeconds = now.difference(dateTime).inSeconds;

      if (differenceInSeconds < 60) {
        return "Bây giờ"; // Dưới 1 phút
      } else if (differenceInSeconds < 3600) {
        // Dưới 1 giờ
        final minutes = (differenceInSeconds / 60).floor();
        return "$minutes phút"; // Ví dụ: "5 phút trước"
      } else if (differenceInSeconds < 86400) {
        // Dưới 1 ngày
        final hours = (differenceInSeconds / 3600).floor();
        return "$hours giờ"; // Ví dụ: "2 giờ trước"
      } else {
        final days = (differenceInSeconds / 86400).floor();
        return "$days ngày"; // Ví dụ: "3 ngày trước"
      }
    }

    @override
    Widget build(BuildContext context) {
      return Consumer<AuthProviderCustom>(builder: (context, auth, child) {
        return Column(
          children: questions.map((question) {
            return FutureBuilder<UserModel?>(
              future: question.getUserModelIdFromUserId(), // Gọi hàm bất đồng bộ
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Hoặc bạn có thể sử dụng loading spinner khác
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('User not found');
                }

                UserModel userModel = snapshot.data!;
                String? displayName = userModel.displayName;
                displayName ??= "Unknown User";

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostScreen(question: question),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26.withOpacity(0.05),
                          offset: const Offset(0.0, 6.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: AssetImage(question.imageURL),
                                    radius: 22,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.65,
                                        child: Text(
                                          question.question,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: .4,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            ( displayName.length > 10 )
                                                ? '$displayName...'
                                                : displayName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: .4,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            formatDate(question.createdAt), // Gọi hàm formatDate để định dạng ngày
                                            style: TextStyle(
                                              color: Colors.grey.withOpacity(0.6),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            userModel.roleText,
                                            style: TextStyle(
                                              color: Colors.blue.withOpacity(0.6),
                                              fontStyle: FontStyle.italic,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${question.content.length > 80 ? question.content.substring(0, 80) : question.content}..",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 16,
                              letterSpacing: .3,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.grey.withOpacity(0.6),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    "${question.votes} like",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.email,
                                    color: Colors.grey.withOpacity(0.6),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      });
    }
  }
