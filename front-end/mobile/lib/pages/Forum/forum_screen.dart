import 'package:flutter/material.dart';
import 'package:mobile/pages/Forum/widgets/pin_post.dart';
import 'package:mobile/pages/Forum/widgets/posts.dart';
import 'package:mobile/pages/Forum/widgets/upload_post.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderCustom>(
      builder: (context, auth, child) {
        final user = auth.userModel;
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 116, 192, 252),
          body: SafeArea(
            child: ListView(
              children: <Widget>[
                Container(
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 116, 192, 252),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Hi ${user?.displayName}",
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Create post",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14.0,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 40), // Giảm khoảng cách trên và dưới
                                      child: Dialog(
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const UploadPostWidget(),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                    ),
                  ),
                  child: const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "Pinned Posts",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Pin(),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                          child: Text(
                            "Posts",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Posts(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
