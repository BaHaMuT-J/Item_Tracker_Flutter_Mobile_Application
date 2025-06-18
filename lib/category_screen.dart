import 'package:flutter/material.dart';
import 'package:item_tracker/AddItemButton.dart';
import 'package:item_tracker/CreateCardPainter.dart';
import 'package:item_tracker/DeleteButton.dart';
import 'package:item_tracker/constant.dart';
import 'package:item_tracker/showTextFieldDialog.dart';

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
              title: "Add New Item",
              onAdd: (newName) {
                setState(() {
                  children.insert(0, newName);
                  widget.category.children.insert(0, newName);
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: children.length,
                buildDefaultDragHandles: false,
                proxyDecorator: (child, index, animation) {
                  return Material(
                    color: Colors.transparent,
                    elevation: 16,
                    child: child,
                  );
                },
                itemBuilder: (context, index) {
                  final item = children[index];
                  return Card(
                    key: ValueKey(item),
                    color: creamColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                            itemToDelete: item,
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
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = children.removeAt(oldIndex);
                    children.insert(newIndex, item);
                    widget.category.children
                      ..removeAt(oldIndex)
                      ..insert(newIndex, item);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

