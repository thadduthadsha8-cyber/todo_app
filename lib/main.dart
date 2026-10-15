
import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
import 'models/todo_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TodoStore.loadTasks();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Master',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
