import 'package:flutter/material.dart';
import 'package:item_tracker/constant.dart';

final maxCategoryNameLength = 10;
final maxItemNameLength = 20;

void showTextFieldDialog({
  required BuildContext context,
  required String title,
  String initialValue = '',
  required String confirmLabel,
  required ValueChanged<String> onConfirm,
  required bool isCategory,
}) {
  final int maxNameLength = isCategory ? maxCategoryNameLength : maxItemNameLength;
  final TextEditingController controller = TextEditingController(text: initialValue);
  final ValueNotifier<String?> errorText = ValueNotifier(null);
  final valid = RegExp('^[a-zA-Z0-9 _-]{1,$maxNameLength}\$');

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
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: brownColor,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    maxLength: maxNameLength,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Enter new ${isCategory ? "category" : "item"} name",
                      hintStyle: const TextStyle(color: Colors.grey),
                      counterText: "",
                      errorText: null, // we show error manually
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: brownColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (error != null)
                    Text(
                      error,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const FittedBox(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: brownColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      final newName = controller.text.trim();
                      if (newName.isEmpty) {
                        errorText.value = "Name can't be empty";
                      } else if (!valid.hasMatch(newName)) {
                        errorText.value =
                        "Only letters, numbers, - and _ allowed (max $maxNameLength)";
                      } else {
                        onConfirm(newName);
                        Navigator.pop(context);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: FittedBox(
                      child: Text(
                        confirmLabel,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: orangeColor,
                        ),
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
}