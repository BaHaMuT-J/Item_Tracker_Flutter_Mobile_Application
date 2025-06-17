import 'package:flutter/material.dart';
import 'package:item_tracker/constant.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
    required this.category
  });

  final Category category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<String> children;

  @override
  void initState() {
    super.initState();
    children = List.from(widget.category.children);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: weakOrangeColor,
      appBar: AppBar(
        backgroundColor: orangeColor,
        title: Row(
          children: [
            Text(
              widget.category.name,
              style: const TextStyle(
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
              onTap: () {
                // Later logic
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: children.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = children[index];
                  return Card(
                    color: creamColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: brownColor,
                              ),
                            ),
                          ),
                          DeleteButton(
                            title: "Delete Item",
                            itemToDelete: widget.category.children[index],
                            onTap: () {
                              setState(() {
                                children.removeAt(index);
                                widget.category.children.removeAt(index);
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddItemButton extends StatelessWidget {
  const AddItemButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: CreateCardPainter(),
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 30,
                color: brownColor,
              ),
              const SizedBox(width: 8),
              Text(
                "Add New Item",
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

