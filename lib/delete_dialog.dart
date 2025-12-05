import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'todo_model.dart';

class DeleteDialog {
  static Future<bool> _showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  static void show({
    required BuildContext context,
    required DBHelper dbHelper,
    required Todo todo,
    required VoidCallback onDeleted,
  }) async {
    final confirm = await _showConfirmation(
      context: context,
      title: 'Delete Task?',
      message: 'Delete "${todo.title}"?',
    );

    if (confirm && context.mounted) {
      await dbHelper.deleteTodo(todo.id!);
      onDeleted();
    }
  }
}