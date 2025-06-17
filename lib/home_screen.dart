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
        final TextEditingController controller = TextEditingController(text: oldName);
        final ValueNotifier<String?> errorText = ValueNotifier(null);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: weakOrangeColor,
            contentPadding: const EdgeInsets.all(24),
            content: SizedBox(
              width: 400,
              child: ValueListenableBuilder<String?>(
                valueListenable: errorText,
                builder: (context, error, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Rename category '$oldName'",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: brownColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      maxLength: maxNameLength,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Enter new category name",
                        hintStyle: const TextStyle(color: Colors.grey),
                        counterText: "",
                        errorText: error,
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: brownColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: brownColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () {
                            final newName = controller.text.trim();
                            final valid = RegExp(r'^[a-zA-Z0-9_-]{1,10}$');

                            if (newName.isEmpty) {
                              errorText.value = "Name can't be empty";
                            } else if (!valid.hasMatch(newName)) {
                              errorText.value = "Only letters, numbers, - and _ allowed (max $maxNameLength)";
                            } else {
                              onRename(newName);
                              Navigator.pop(context);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text(
                            "Rename",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: orangeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
