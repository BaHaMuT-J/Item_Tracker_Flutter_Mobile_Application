import 'package:flutter/material.dart';
import 'package:item_tracker/colors.dart';

class Category {
  final String name;
  final List<String> children;

  Category({required this.name, required this.children});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [
    Category(name: "Game", children: ["Stellar Blade", "Elden Ring"]),
    Category(name: "Sport", children: ["Badminton racket"]),
    Category(name: "Book", children: ["One Piece", "Naruto", "Dragonball"]),
    Category(name: "Model", children: ["Luffy Gear 4th"]),
    Category(name: "Lego", children: []),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: weakOrangeColor,
      appBar: AppBar(
        backgroundColor: orangeColor,
        title: Row(
          children: [
            Image.asset(
              'assets/treasure-chest.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 12), // space between icon and text
            const Text(
              "Item Tracker",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: brownColor,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: categories.map((category) {
            return Card(
              color: creamColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: brownColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/pencil.png',
                        width: 30, // adjust size here
                        height: 30,
                      ),
                      onPressed: () {
                        // Handle edit action
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/bin.png',
                        width: 30, // adjust size here
                        height: 30,
                      ),
                      onPressed: () {
                        // Handle delete action
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
