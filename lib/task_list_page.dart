import 'package:flutter/material.dart';
import 'task.dart';
import 'task_form_page.dart';
import 'settings_page.dart';

class TaskListPage extends StatefulWidget {
  final Function(bool) onToggleTheme;

  TaskListPage({required this.onToggleTheme});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "My Tiny World",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SettingsPage(onToggleTheme: widget.onToggleTheme),
                ),
              );
            },
          )
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No tasks yet",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap + to add a new task",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            )
          : ReorderableListView(
              padding: EdgeInsets.all(16),
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex--;
                final item = tasks.removeAt(oldIndex);
                tasks.insert(newIndex, item);
                setState(() {});
              },
              children: tasks.map((task) {
                return Dismissible(
                  key: ValueKey(task.id),
                  background: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 24),
                    child: Icon(Icons.edit_outlined, color: Colors.white, size: 28),
                  ),
                  secondaryBackground: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 24),
                    child: Icon(Icons.delete_outline, color: Colors.white, size: 28),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskFormPage(
                            task: task,
                            onSave: (_) => setState(() {}),
                          ),
                        ),
                      );
                      return false;
                    } else {
                      setState(() => tasks.remove(task));
                      return true;
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark 
                            ? [Color(0xFF2D4A3E), Color(0xFF1F3329)]
                            : [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: isDark 
                              ? Colors.black.withOpacity(0.3)
                              : Colors.green.shade200.withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskFormPage(
                                task: task,
                                onSave: (_) => setState(() {}),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isDark 
                                      ? Colors.green.shade700.withOpacity(0.3)
                                      : Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.task_alt,
                                  color: isDark 
                                      ? Colors.green.shade300
                                      : Colors.green.shade700,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDark 
                                            ? Colors.white
                                            : Colors.green.shade900,
                                      ),
                                    ),
                                    if (task.description.isNotEmpty) ...[
                                      SizedBox(height: 4),
                                      Text(
                                        task.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark 
                                              ? Colors.grey.shade400
                                              : Colors.green.shade700,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.drag_indicator,
                                color: isDark 
                                    ? Colors.grey.shade600
                                    : Colors.green.shade400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskFormPage(
                onSave: (task) {
                  setState(() => tasks.add(task));
                },
              ),
            ),
          );
        },
        icon: Icon(Icons.add),
        label: Text("Add Task"),
        elevation: 4,
      ),
    );
  }
}