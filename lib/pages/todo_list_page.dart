
import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  void _updateTask(BuildContext context, TodoTask task, int index) {
    final nameController = TextEditingController(text: task.name);
    final titleController = TextEditingController(text: task.title);
    final descriptionController =
        TextEditingController(text: task.description);

    String status = task.status;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Update Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: task.id,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Pending',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'Complete',
                          child: Text('Complete'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            status = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty ||
                        titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Name and Task Title are required',
                          ),
                        ),
                      );
                      return;
                    }

                    final updatedTask = task.copyWith(
                      name: nameController.text.trim(),
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      status: status,
                    );

                    TodoStore.updateTask(index, updatedTask);
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      nameController.dispose();
      titleController.dispose();
      descriptionController.dispose();
    });
  }

  void _deleteTask(
    BuildContext context,
    int index,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task?'),
          content: const Text(
            'Do you want to delete this task?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                TodoStore.deleteTask(index);
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<TodoTask>>(
      valueListenable: TodoStore.tasks,
      builder: (context, tasks, child) {
        if (tasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.checklist_rounded,
                  size: 65,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'No tasks available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final isComplete = task.status == 'Complete';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isComplete
                                ? Colors.green
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text('ID: ${task.id}'),
                    const SizedBox(height: 4),
                    Text('Name: ${task.name}'),
                    const SizedBox(height: 4),
                    Text('Description: ${task.description}'),
                    const SizedBox(height: 4),
                    Text(
                      'Due Date: ${task.dueDate.day}/'
                      '${task.dueDate.month}/'
                      '${task.dueDate.year}',
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            _updateTask(context, task, index);
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 18,
                          ),
                          label: const Text('Update'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () {
                            _deleteTask(context, index);
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                          ),
                          label: const Text('Delete'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
