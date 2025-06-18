import 'package:flutter/material.dart';
import 'package:item_tracker/CreateCardPainter.dart';
import 'package:item_tracker/DeleteButton.dart';
import 'package:item_tracker/category_screen.dart';
import 'package:item_tracker/constant.dart';
import 'package:item_tracker/showDialog.dart';

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
              title: "Add New Category",
              onAdd: (newName) {
                setState(() {
                  final newCategory = Category(name: newName, children: []);
                  categories.insert(0, newCategory);
                });
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
                        RenameCategoryButton(
                          oldName: category.name,
                          onRename: (newName) {
                            setState(() {
                              category.name = newName;
                            });
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
  const AddCategoryButton({
    super.key,
    required this.title,
    required this.onAdd,
  });

  final String title;
  final ValueChanged<String> onAdd;
  final maxNameLength = 10;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showTextFieldDialog(
          context: context,
          title: title,
          confirmLabel: "Add",
          onConfirm: onAdd,
          isCategory: true,
        );
      },
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
                title,
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

class RenameCategoryButton extends StatelessWidget {
  final String oldName;
  final ValueChanged<String> onRename;
  final maxNameLength = 10;

  const RenameCategoryButton({
    super.key,
    required this.oldName,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/pencil.png',
        width: 30,
        height: 30,
      ),
      onPressed: () {
        showTextFieldDialog(
          context: context,
          title: "Rename category '$oldName'",
          initialValue: oldName,
          confirmLabel: "Rename",
          onConfirm: onRename,
          isCategory: true,
        );
      },
    );
  }
}
