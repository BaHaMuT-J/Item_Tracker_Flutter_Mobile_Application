import 'package:flutter/material.dart';
import 'package:item_tracker/constant.dart';

void showTextFieldDialog({
  required BuildContext context,
  required String title,
  String initialValue = '',
  required String confirmLabel,
  required ValueChanged<String> onConfirm,
  required bool isCategory,
  int maxNameLength = 10,
}) {
  final TextEditingController controller = TextEditingController(text: initialValue);
  final ValueNotifier<String?> errorText = ValueNotifier(null);
  final valid = RegExp(r'^[a-zA-Z0-9_-]{1,10}$');

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
              TextField(
                controller: controller,
                maxLength: maxNameLength,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Enter new ${isCategory ? "category" : "item"} name",
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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      confirmLabel,
                      style: const TextStyle(
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
}