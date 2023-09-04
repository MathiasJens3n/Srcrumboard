import 'package:flutter/material.dart';
import 'screens/my_home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrumboard',
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Scrumboard'),
    );
  }
}
