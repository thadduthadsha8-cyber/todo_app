
import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import 'todo_list_page.dart';
import 'add_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<String> notifications = [
    'Welcome to Task Master!',
    'You have pending tasks.',
    'Keep working towards your goals.',
  ];

  void goToPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void openNotifications() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Notifications'),
          content: SizedBox(
            width: double.maxFinite,
            height: 220,
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.blue,
                  ),
                  title: Text(notifications[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomePage(),
      buildTasksPage(),
      buildAddPage(),
      buildProfilePage(),
    ];

    const titles = [
      'My Tasks',
      'Tasks',
      'Add New To-Do',
      'Profile',
    ];

    return PopScope(
      canPop: selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && selectedIndex != 0) {
          goToPage(0);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F7FB),
          elevation: 0,
          leading: selectedIndex == 0
              ? null
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => goToPage(0),
                ),
          title: Text(
            titles[selectedIndex],
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: openNotifications,
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          onTap: goToPage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist_rounded),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // PAGE 2 - HOME
  Widget buildHomePage() {
    return ValueListenableBuilder<List<TodoTask>>(
      valueListenable: TodoStore.tasks,
      builder: (context, tasks, child) {
        final totalTasks = tasks.length;
        final pendingTasks =
            tasks.where((task) => task.status == 'Pending').length;
        final completedTasks =
            tasks.where((task) => task.status == 'Complete').length;

        final recentTasks = tasks.reversed.take(3).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 35,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Hello, User 👋',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'user@example.com',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Tasks',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$totalTasks',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Keep going. You are doing great!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Task Overview',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: buildCountCard(
                      'Pending',
                      pendingTasks,
                      Colors.orange,
                      const Color(0xFFFFF0D9),
                      Icons.access_time_rounded,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: buildCountCard(
                      'Complete',
                      completedTasks,
                      Colors.green,
                      const Color(0xFFDCFCE7),
                      Icons.check_circle_outline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => goToPage(2),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New To-Do'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Recent Tasks',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (recentTasks.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text('No tasks added yet'),
                    ),
                  ),
                )
              else
                ...recentTasks.map((task) {
                  final isComplete = task.status == 'Complete';

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        isComplete
                            ? Icons.check_circle
                            : Icons.pending_actions,
                        color: isComplete
                            ? Colors.green
                            : Colors.orange,
                      ),
                      title: Text(task.title),
                      subtitle: Text(
                        '${task.name} • ${task.status}',
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                      onTap: () => goToPage(1),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  // TASK COUNT CARD
  Widget buildCountCard(
    String title,
    int count,
    Color color,
    Color background,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 14),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // PAGE 4 - TASK LIST
  Widget buildTasksPage() {
    return const TodoListPage();
  }

  // PAGE 3 - ADD TODO
  Widget buildAddPage() {
    return const AddTodoPage();
  }

  // PAGE 5 - PROFILE
  Widget buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFFDBEAFE),
            child: Icon(
              Icons.person,
              size: 65,
              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'User Name',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'user@example.com',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.blue,
                  ),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Edit Profile coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.settings_outlined,
                    color: Colors.blue,
                  ),
                  title: const Text('Settings'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),
                  title: const Text('About App'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Task Master',
                      applicationVersion: '1.0.0',
                      applicationLegalese: 'My Flutter To-Do App',
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton.icon(
              onPressed: () => goToPage(0),
              icon: const Icon(Icons.home_outlined),
              label: const Text('Back to Home'),
            ),
          ),
        ],
      ),
    );
  }
}
