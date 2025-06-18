import 'package:flutter/material.dart';
import 'package:item_tracker/CreateCardPainter.dart';
import 'package:item_tracker/constant.dart';
import 'package:item_tracker/showTextFieldDialog.dart';

class AddItemButton extends StatelessWidget {
  const AddItemButton({
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
          isCategory: false,
        );
      },
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