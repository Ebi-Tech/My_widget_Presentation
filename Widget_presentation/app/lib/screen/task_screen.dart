import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Map<String, String>> tasks = [
    {'title': 'Buy groceries', 'due': '2024-01-20'},
    {'title': 'Finish report', 'due': '2024-01-22'},
    {'title': 'Call plumber', 'due': '2024-01-25'},
  ];

  void _addTask() {
    setState(() {
      tasks.add({'title': 'New Task ${tasks.length + 1}', 'due': '2024-01-30'});
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _editTask(int index, String newTitle) {
    setState(() {
      tasks[index]['title'] = newTitle;
    });
  }

  // version switch
  bool usePopupMenu = true; 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(usePopupMenu 
          ? 'Task Manager (Version 1: PopupMenuButton)' 
          : 'Task Manager (Version 2: Two Buttons)'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskItem(
            task: tasks[index],
            index: index,
            onDelete: () => _deleteTask(index),
            onEdit: (newTitle) => _editTask(index, newTitle),
            usePopupMenu: usePopupMenu,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  final Map<String, String> task;
  final int index;
  final VoidCallback onDelete;
  final Function(String) onEdit;
  final bool usePopupMenu;

  const TaskItem({
    super.key,
    required this.task,
    required this.index,
    required this.onDelete,
    required this.onEdit,
    required this.usePopupMenu,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task['title']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: const Icon(Icons.task, color: Colors.blue),
        title: Text(widget.task['title']!),
        subtitle: Text('Due: ${widget.task['due']}'),
        
        trailing: widget.usePopupMenu 
        
      
          // PopupMenuButton Version
          ? PopupMenuButton<String>(
              icon: const Icon(Icons.settings),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditDialog();
                } else if (value == 'delete') {
                  widget.onDelete();
                }
              },
            )
          
          // Space-consuming Vesrsion
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: _controller,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onEdit(_controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
