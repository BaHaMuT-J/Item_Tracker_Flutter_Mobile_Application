import 'package:flutter/material.dart';
import 'package:item_tracker/category_screen.dart';
import 'package:item_tracker/constant.dart';

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
    // Category(name: "Snack", children: ["Lays"]),
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
            const SizedBox(width: 12),
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
          childAspectRatio: 2,
          children: [
            AddCategoryButton(
              onTap: () {
                // Handle add new category
              },
            ),
            ...categories.map((category) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(category: category),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
                child: Card(
                  color: creamColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                            width: 30,
                            height: 30,
                          ),
                          onPressed: () {
                            // Handle edit action
                          },
                        ),
                        DeleteButton(
                          title: "Delete Category",
                          itemToDelete: category.name,
                          onTap: () {
                            setState(() {
                              categories.remove(category);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class AddCategoryButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AddCategoryButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: CreateCardPainter(),
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 40,
                color: brownColor,
              ),
              const SizedBox(height: 8),
              Text(
                "Add New Category",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: brownColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
