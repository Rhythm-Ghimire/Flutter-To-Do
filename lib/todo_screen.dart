import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'todo_model.dart';
import 'add_edit_dialog.dart';
import 'delete_dialog.dart';
import 'status_dialog.dart';
import 'search_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Todo> _todos = [];
  int _currentIndex = 0; // 0=Uncompleted, 1=Completed, 2=All Tasks

  static const double CHECKBOX_COL_WIDTH = 85.0;
  static const double ACTIONS_COL_WIDTH = 100.0;

  @override
  void initState() {
    super.initState();
    _refreshTodos();
  }

  Future<void> _refreshTodos() async {
    List<Todo> data;
    switch (_currentIndex) {
      case 0: data = await _dbHelper.getTodos(isCompleted: false); break;
      case 1: data = await _dbHelper.getTodos(isCompleted: true); break;
      default: data = await _dbHelper.getTodos(); break;
    }
    setState(() => _todos = data);
  }

  Widget _buildHeaderRow() {
    final isAllTasks = _currentIndex == 2;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        border: Border(bottom: BorderSide(color: Colors.indigo.shade200)),
      ),
      child: Row(
        children: [
          if (!isAllTasks) SizedBox(
            width: CHECKBOX_COL_WIDTH,
            child: Text(
              _currentIndex == 0 ? "Mark Done" : "Unmark",
              style: _headerStyle(),
            ),
          ),
          if (!isAllTasks) const SizedBox(width: 8),
          Expanded(child: Text("Task Description", style: _headerStyle())),
          if (isAllTasks) Container(
            width: 100,
            alignment: Alignment.center,
            child: Text("Status", style: _headerStyle()),
          ),
          Container(
            width: ACTIONS_COL_WIDTH,
            alignment: Alignment.center,
            child: Text("Actions", style: _headerStyle()),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.indigo.shade800,
  );

  Widget _buildTodoItem(Todo todo) {
    final isAllTasks = _currentIndex == 2;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: todo.isCompleted ? Colors.green.shade50 : Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (!isAllTasks) SizedBox(
            width: CHECKBOX_COL_WIDTH,
            child: Checkbox(
              value: todo.isCompleted,
              onChanged: (_) => StatusDialog.show(
                context: context,
                dbHelper: _dbHelper,
                todo: todo,
                onStatusChanged: _refreshTodos,
              ),
            ),
          ),
          if (!isAllTasks) const SizedBox(width: 8),
          Expanded(
            child: Text(
              todo.title,
              style: TextStyle(
                fontSize: 15,
                color: todo.isCompleted ? Colors.grey.shade600 : Colors.grey.shade900,
                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isAllTasks) Container(
            width: 100,
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: todo.isCompleted ? Colors.green.shade100 : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                todo.isCompleted ? 'Completed' : 'Incomplete',
                style: TextStyle(
                  fontSize: 12,
                  color: todo.isCompleted ? Colors.green.shade800 : Colors.orange.shade800,
                ),
              ),
            ),
          ),
          SizedBox(
            width: ACTIONS_COL_WIDTH,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  onPressed: () => AddEditDialog.show(
                    context: context,
                    dbHelper: _dbHelper,
                    todo: todo,
                    onSaved: _refreshTodos,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => DeleteDialog.show(
                    context: context,
                    dbHelper: _dbHelper,
                    todo: todo,
                    onDeleted: _refreshTodos,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final messages = [
      ['No uncompleted tasks', 'Add a task to get started!', Icons.task_alt],
      ['No completed tasks', 'Complete some tasks first!', Icons.check_circle],
      ['No tasks yet', 'Create your first task!', Icons.list],
    ];
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(messages[_currentIndex][2] as IconData, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(messages[_currentIndex][0] as String, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(messages[_currentIndex][1] as String, style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: TodoSearchDelegate(_dbHelper)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => AddEditDialog.show(
          context: context,
          dbHelper: _dbHelper,
          onSaved: _refreshTodos,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _refreshTodos();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pending_actions), label: 'Uncompleted'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outlined), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All Tasks'),
        ],
      ),
      body: Column(
        children: [
          _buildHeaderRow(),
            
          Expanded(
            child: _todos.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    itemCount: _todos.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
                    itemBuilder: (context, index) => _buildTodoItem(_todos[index]),
                  ),
          ),
        ],
      ),
    );
  }
}