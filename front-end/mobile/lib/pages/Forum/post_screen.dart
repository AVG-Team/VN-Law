import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post_model.dart';
import 'package:http/http.dart' as http;

import '../../services/auth_provider.dart';

class PostScreen extends StatefulWidget {
  final Question question;
  const PostScreen({
    super.key,
    required this.question,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final AuthProviderCustom _authProvider;
  late DatabaseReference _postsRef;

  void initState() {
    super.initState();
    _postsRef = FirebaseDatabase.instance.ref('posts');
    _authProvider = Provider.of<AuthProviderCustom>(context, listen: false);
    fetchQuestions();
  }

  List<Question> _posts = [];
  Future<void> fetchQuestions() async {
    _postsRef.onValue.listen((DatabaseEvent event) {
      final dynamic data = event.snapshot.value;
      print("Fetched data: $data");

      if (data != null && data is Map) {
        List<Question> loadedQuestions = [];
        data.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
            try {
              Map<String, dynamic> questionMap = Map<String, dynamic>.from(
                  value.map((k, v) => MapEntry(k.toString(), v)));

              // Truyền key vào fromJson
              Question question =
                  Question.fromJson(questionMap, key.toString());
              loadedQuestions.add(question);
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
    // Kiểm tra xem createdAt có hợp lệ không
    if (createdAt == null || createdAt.isEmpty) {
      return 'Ngày không hợp lệ';
    }

    try {
      DateTime dateTime =
          DateTime.parse(createdAt); // Nếu bạn lưu ngày dưới dạng chuỗi ISO
      final now = DateTime.now();

      // Tính toán sự khác biệt giữa hai thời điểm
      final differenceInSeconds = now.difference(dateTime).inSeconds;

      if (differenceInSeconds < 60) {
        return "Bây giờ";
      } else if (differenceInSeconds < 3600) {
        final minutes = (differenceInSeconds / 60).floor();
        return "$minutes phút";
      } else if (differenceInSeconds < 86400) {
        final hours = (differenceInSeconds / 3600).floor();
        return "$hours giờ";
      } else {
        final days = (differenceInSeconds / 86400).floor();
        return "$days ngày";
      }
    } catch (e) {
      return 'Ngày không hợp lệ';
    }
  }

  Future<void> pinPost(String nodeKey) async {
    final DatabaseReference ref =
        FirebaseDatabase.instance.ref("posts/$nodeKey");

    try {
      await ref.update({"pin": 1});
      print("Post pinned successfully.");
    } catch (error) {
      print("Failed to pin post: $error");
      throw error;
    }
  }

  Future<void> deletePost(String nodeKey) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("posts/$nodeKey");

    try {
      await ref.remove();
      print("Xóa thành công mục có ID: $nodeKey");
      setState(() {
        questions.removeWhere((question) => question.nodeKey == nodeKey);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.greenAccent),
              SizedBox(width: 8),
              Text(
                "Post deleted successfully!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context); // Quay lại màn hình trước
    } catch (error) {
      print("Lỗi khi xóa: $error");
    }
    fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_left,
                        size: 20,
                        color: Colors.black,
                      )),
                  const SizedBox(width: 5.0),
                  const Text(
                    "View Post",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26.withOpacity(0.05),
                        offset: const Offset(0.0, 6.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.10)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 60,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage(widget.question.imageURL),
                                radius: 22,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      widget.question.nameUser.length > 10
                                          ? '${widget.question.nameUser.substring(0, 10)}...'
                                          : widget.question.nameUser,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .4,
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      formatDate(widget.question.createdAt),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          if (_authProvider.userModel?.uid ==
                                  widget.question.idUser ||
                              _authProvider.userModel!.isAdmin)
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert,
                                  color: Colors.grey.withOpacity(0.6)),
                              itemBuilder: (BuildContext context) {
                                return [
                                  if (_authProvider.userModel?.uid ==
                                          widget.question.idUser ||
                                      _authProvider.userModel!.isAdmin)
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete,
                                              color: Colors.redAccent),
                                          SizedBox(width: 8),
                                          Text(
                                            'Delete',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (_authProvider.userModel!.isAdmin)
                                    const PopupMenuItem<String>(
                                      value: 'pin',
                                      child: Row(
                                        children: [
                                          Icon(Icons.push_pin,
                                              color: Colors.blueAccent),
                                          SizedBox(width: 8),
                                          Text(
                                            'Pin',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  // Add other menu items if needed
                                ];
                              },
                              onSelected: (String value) {
                                if (value == 'delete') {
                                  deletePost(widget.question.nodeKey);
                                } else if (value == 'pin') {
                                  pinPost(widget.question.nodeKey);
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        widget.question.question,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      widget.question.content,
                      style: const TextStyle(
                          color: Colors.black, fontSize: 17, letterSpacing: .2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.thumb_up,
                                color: Colors.grey.withOpacity(0.5),
                                size: 22,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                "${widget.question.votes} like",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(width: 15.0),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.comment,
                                color: Colors.grey.withOpacity(0.5),
                                size: 18,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                "Bình luận",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 20.0, bottom: 10.0),
              child: Text(
                "Replies",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Column(
              children: widget.question.replies
                  .map((reply) => Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26.withOpacity(0.03),
                              offset: const Offset(0.0, 6.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.10)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 60,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage:
                                            AssetImage(reply.author.imageUrl),
                                        radius: 18,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              reply.author.name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: .4),
                                            ),
                                            const SizedBox(height: 2.0),
                                            Text(
                                              widget.question.createdAt,
                                              style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.4)),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                reply.content,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.25),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Centering the row contents
                            ),
                          ],
                        ),
                      )))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
