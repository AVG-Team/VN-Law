import 'package:flutter/material.dart';
import '../../../models/post_model.dart';
import '../post_screen.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: questions.map((question) => GestureDetector(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage(question.author.imageUrl),
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
                                  question.author.name,
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  question.author.role,
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.6),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  question.createdAt,
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      Icons.bookmark,
                      color: Colors.grey.withOpacity(0.6),
                      size: 26,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${question.content.substring(0, 80)}..",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 16,
                    letterSpacing: .3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.thumb_up,
                          color: Colors.grey.withOpacity(0.6),
                          size: 22,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          "${question.votes} votes",
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
                        const SizedBox(width: 4.0),
                        Text(
                          "${question.repliesCount} replies",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.visibility,
                          color: Colors.grey.withOpacity(0.6),
                          size: 18,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          "${question.views} views",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }
}
