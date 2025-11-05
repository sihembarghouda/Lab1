// lib/navigation/auth_navigator.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/providers/auth_provider.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:notes_app/screens/notes_screen.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Show loading indicator while checking auth status
    if (authProvider.loading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // If there is no AuthScreen implemented yet, show a simple placeholder
    if (!authProvider.isAuthenticated) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Authentication')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Authentication screen not implemented.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/home'),
                    child: const Text('Continue to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/notes': (context) => const NotesScreen(),
        },
      );
    }

    // Authenticated: show the normal app navigation
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/notes': (context) => const NotesScreen(),
      },
    );
  }
}
