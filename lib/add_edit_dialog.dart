import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'todo_model.dart';

class AddEditDialog {
  static void show({
    required BuildContext context,
    required DBHelper dbHelper,
    Todo? todo,
    required VoidCallback onSaved,
  }) {
    final titleController = TextEditingController(text: todo?.title ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(todo == null ? 'Add Task' : 'Edit Task'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: titleController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Task'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (todo == null) {
                  await dbHelper.insertTodo(Todo(title: titleController.text.trim()));
                } else {
                  todo.title = titleController.text.trim();
                  await dbHelper.updateTodo(todo);
                }
                if (context.mounted) Navigator.pop(context);
                onSaved();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}