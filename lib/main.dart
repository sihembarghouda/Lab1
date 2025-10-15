import 'package:flutter/material.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:notes_app/screens/notes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/notes': (context) => const NotesScreen(),
      },
    );
  }
}