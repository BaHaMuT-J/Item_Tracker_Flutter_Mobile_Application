import 'package:flutter/material.dart';
import 'package:item_tracker/AddItemButton.dart';
import 'package:item_tracker/DeleteButton.dart';
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
  late List<CategoryItem> children;

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
                  children.insert(0, CategoryItem(name: newName, icon: Icons.star_border_outlined));
                  widget.category.children.insert(0, CategoryItem(name: newName, icon: Icons.star_border_outlined));
                });
              },
              isCategory: false,
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
                          IconButton(
                            icon: Icon(item.icon, color: brownColor),
                            onPressed: () async {
                              final IconData? selectedIcon = await showDialog<IconData>(
                                context: context,
                                builder: (context) => IconPickerDialog(currentIcon: item.icon),
                              );

                              if (selectedIcon != null) {
                                setState(() {
                                  children[index] = CategoryItem(name: item.name, icon: selectedIcon);
                                  widget.category.children[index] =
                                      CategoryItem(name: item.name, icon: selectedIcon);
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: brownColor,
                              ),
                            ),
                          ),
                          DeleteButton(
                            title: "Delete Item",
                            itemToDelete: item.name,
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

class IconPickerDialog extends StatelessWidget {
  final IconData currentIcon;

  const IconPickerDialog({super.key, required this.currentIcon});

  @override
  Widget build(BuildContext context) {
    final icons = <IconData>[
      Icons.star_border_outlined,
      Icons.star,
      Icons.check_circle,
      Icons.hourglass_empty,
      Icons.archive,
      Icons.label,
      Icons.shopping_cart,
      Icons.work,
    ];

    return AlertDialog(
      backgroundColor: creamColor,
      title: Text(
        "Pick an Icon",
        style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: brownColor
        )
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: icons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final icon = icons[index];
            return IconButton(
              icon: Icon(
                icon,
                color: icon == currentIcon ? orangeColor : brownColor,
              ),
              onPressed: () => Navigator.pop(context, icon),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Simply closes the dialog
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: brownColor,
            ),
          ),
        ),
      ],
    );
  }
}
