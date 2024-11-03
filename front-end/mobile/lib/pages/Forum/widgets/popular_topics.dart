import 'package:flutter/material.dart';

class PopularTopics extends StatefulWidget {

  const PopularTopics({super.key});

  @override
  State<PopularTopics> createState() => _PopularTopicsState();
}

class _PopularTopicsState extends State<PopularTopics> {
  List<String> contents = [
    "C##" , "Laravel" ,"Node Js", "Nginx"
  ];

  List<Color> colors  = [
    Colors.purple, Colors.blueAccent, Colors.greenAccent, Colors.redAccent
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contents.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(left: 20.0),
            height: 180,
            width: 170,
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contents[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "30 posts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: .7
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}