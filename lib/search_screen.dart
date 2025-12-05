import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'todo_model.dart';

// Custom search delegate for implementing search functionality
class TodoSearchDelegate extends SearchDelegate {
  final DBHelper dbHelper;  // Database helper for searching tasks
  
  TodoSearchDelegate(this.dbHelper);

  // Clear search query button (appears on the right side of app bar)
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () => query = '',  // Clear search text
    ),
  ];

  // Back button (appears on the left side of app bar)
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),  // Close search screen
  );

  // Build search results (same as suggestions in this case)
  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  // Build search suggestions as user types
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      // Fetch all tasks from database for searching
      future: dbHelper.getTodos(),
      builder: (context, snapshot) {
        // Show loading indicator while fetching data
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Filter tasks based on search query
        final results = snapshot.data!.where((todo) =>
            todo.title.toLowerCase().contains(query.toLowerCase())).toList();

        // Show empty state if no matches found
        if (results.isEmpty) {
          return const Center(child: Text("No matching tasks found"));
        }

        // Display search results as a list
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final todo = results[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                // Icon showing task status
                leading: CircleAvatar(
                  backgroundColor: todo.isCompleted ? Colors.green.shade100 : Colors.blue.shade100,
                  child: Icon(
                    todo.isCompleted ? Icons.check : Icons.access_time,
                    size: 20,
                  ),
                ),
                // Task title
                title: Text(todo.title),
                // Task status
                subtitle: Text(
                  todo.isCompleted ? "Completed" : "Incomplete",
                  style: TextStyle(color: todo.isCompleted ? Colors.green : Colors.blue),
                ),
                // Close search when a task is tapped
                onTap: () => close(context, null),
              ),
            );
          },
        );
      },
    );
  }
}