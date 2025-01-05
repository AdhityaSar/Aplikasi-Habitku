import 'package:flutter/material.dart';
import 'my_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  // Fungsi untuk toggle tema
  void _toggleTheme(bool isDark) {
    print('Theme changed to: ${isDark ? 'Dark' : 'Light'}'); // Debugging
    setState(() {
      _isDarkMode = isDark; // Memperbarui state
      print('_isDarkMode updated to: $_isDarkMode'); // Debugging tambahan
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Tema terang
      darkTheme: ThemeData.dark(), // Tema gelap
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light, // Sesuaikan dengan status tema
      home: MyNavbar(
        onThemeChanged: _toggleTheme, // Callback untuk mengubah tema
        isDarkMode: _isDarkMode, // Status tema saat ini
      ),
    );
  }
}