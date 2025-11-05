import 'package:flutter/material.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:notes_app/screens/notes_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized before loading async resources
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables
  await dotenv.load(fileName: '.env');
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
