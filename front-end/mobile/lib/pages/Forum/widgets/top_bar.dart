import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final List<String> contents = [
    "Popular",
    "Recommended",
    "New Topic",
    "Latest",
    "Trending"
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.only(top: 40, bottom: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contents.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20.0),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 116, 192, 252),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  contents[index],
                  style: TextStyle(
                      fontSize: 16.0,
                      color: _selectedIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.black38,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}