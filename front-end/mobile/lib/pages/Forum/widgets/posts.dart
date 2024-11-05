import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
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
  String? _userRole;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    _loadUserRole();
  }

  Future<UserModel?> getUserWithRole() async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return null;

      // Lấy dữ liệu user từ Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        if (kDebugMode) {
          print('User does not exist in Firestore');
        }
        return null;
      }

      // Nếu user đã tồn tại, convert từ Firestore document
      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user with role: $e');
      }
      return null;
    }
  }

  Future<void> _loadUserRole() async {
    try {
      UserModel? userModel = await getUserWithRole();
      if (userModel != null) {
        if (mounted) {
          setState(() {
            _userRole = userModel.roleText;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải thông tin người dùng: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> fetchQuestions() async {
    _postsRef.onValue.listen((DatabaseEvent event) {
      final dynamic data = event.snapshot.value;
      print("Fetched data: $data");

      if (data != null && data is Map) {
        List<Question> loadedQuestions = [];
        Map<Question, String> loadedNodeKeys = {};
        data.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
            try {
              Map<String, dynamic> questionMap = Map<String, dynamic>.from(
                  value.map((k, v) => MapEntry(k.toString(), v)));

              // Truyền key vào fromJson
              Question question =
                  Question.fromJson(questionMap, key.toString());
              loadedQuestions.add(question);
              loadedNodeKeys[question] = key.toString();
            } catch (e) {
              print("Error processing question $key: $e");
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
        print("No data available or data is not a Map");
      }
    }, onError: (error) {
      print("Error fetching data: $error");
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
      final user = auth.userModel;
      return Column(
        children: questions.map((question) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostScreen(
                      question: question, currentUserId: user?.uid ?? 'N/A'),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
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
                                      question.nameUser.length > 10
                                          ? '${question.nameUser.substring(0, 10)}...'
                                          : question.nameUser,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .4,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      formatDate(question.createdAt),
                                      // Gọi hàm formatDate để định dạng ngày
                                      style: TextStyle(
                                        color: Colors.grey.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _userRole ?? "Thành viên",
                                      style: TextStyle(
                                        color: Colors.blue.withOpacity(0.6),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
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
        }).toList(),
      );
    });
  }
}
