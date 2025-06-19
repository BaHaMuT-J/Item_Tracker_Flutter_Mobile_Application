import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:item_tracker/AddItemButton.dart';
import 'package:item_tracker/CreateCardPainter.dart';
import 'package:item_tracker/DeleteButton.dart';
import 'package:item_tracker/category_screen.dart';
import 'package:item_tracker/constant.dart';
import 'package:item_tracker/showTextFieldDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [
    Category(
      name: "Game",
      children: [
        CategoryItem(name: "Stellar Blade", icon: Icons.star_border_outlined),
        CategoryItem(name: "Elden Ring", icon: Icons.star_border_outlined),
      ],
    ),
    Category(
      name: "Sport",
      children: [
        CategoryItem(name: "Badminton racket", icon: Icons.star_border_outlined),
      ],
    ),
    Category(
      name: "Book",
      children: [
        CategoryItem(name: "One Piece", icon: Icons.star_border_outlined),
        CategoryItem(name: "Naruto", icon: Icons.star_border_outlined),
        CategoryItem(name: "Dragonball", icon: Icons.star_border_outlined),
      ],
    ),
    Category(
      name: "Model",
      children: [
        CategoryItem(name: "Luffy Gear 4th", icon: Icons.star_border_outlined),
      ],
    ),
    Category(
      name: "Lego",
      children: [],
    ),
  ];


  Future<void> saveCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> newCategoriesJson = categories.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList('categories', newCategoriesJson);
  }

  Future<void> loadCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? categoriesJson = prefs.getStringList('categories');

    if (categoriesJson != null) {
      setState(() {
        categories = categoriesJson
            .map((category) => Category.fromJson(jsonDecode(category)))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AddItemButton(
              title: "Add New Category",
              onAdd: (newName) {
                setState(() {
                  categories.insert(0, Category(name: newName, children: []));
                });
                saveCategories();
              },
              isCategory: true,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: categories.length,
                buildDefaultDragHandles: false,
                proxyDecorator: (child, index, animation) {
                  return Material(
                    color: Colors.transparent,
                    elevation: 16,
                    child: child,
                  );
                },
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    key: ValueKey(category.name),
                    color: creamColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(category: category),
                        ),
                      ).then((_) => saveCategories()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            ReorderableDragStartListener(
                              index: index,
                              child: const Icon(
                                Icons.drag_handle,
                                color: brownColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: brownColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            RenameCategoryButton(
                              oldName: category.name,
                              onRename: (newName) {
                                setState(() => category.name = newName);
                                saveCategories();
                              },
                            ),
                            DeleteButton(
                              title: "Delete Category",
                              itemToDelete: category.name,
                              onTap: () {
                                setState(() => categories.removeAt(index));
                                saveCategories();
                                Navigator.pop(context);
                              },
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final moved = categories.removeAt(oldIndex);
                    categories.insert(newIndex, moved);
                  });
                  saveCategories();
                },
              ),
            ),
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
          title: "Rename Category '$oldName'",
          initialValue: oldName,
          confirmLabel: "Rename",
          onConfirm: onRename,
          isCategory: true,
        );
      },
    );
  }
}
