import 'package:aplikasi_habitku/theme/theme.dart';
import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/statspage.dart';
import 'pages/historypage.dart';
import 'pages/settingspage.dart';

class MyNavbar extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged; // Callback untuk mengubah tema
  final bool isDarkMode; // Status tema saat ini

  const MyNavbar({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<MyNavbar> createState() => _MyNavbarState();
}

class _MyNavbarState extends State<MyNavbar> {
  int _selectedIndex = 0;

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('MyNavbar - Current Theme: ${widget.isDarkMode ? "Dark" : "Light"}');

    // Inisialisasi halaman setiap kali build dijalankan
    final _pages = <Widget>[
      MyHomePage(),
      StatsPage(),
      Center(child: Text('Add Activity Page')), // Placeholder untuk Add Activity
      Historypage(),
      Settingspage(
        onThemeChanged: widget.onThemeChanged,
        isDarkMode: widget.isDarkMode,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(" "),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
        color: widget.isDarkMode ? Colors.black : Colors.white, // Background berubah sesuai mode
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? primary : (widget.isDarkMode ? Colors.white : Colors.black45), // Warna icon sesuai mode
                size: 30,
              ),
              onPressed: () => _onTappedItem(0),
            ),
            IconButton(
              icon: Icon(
                Icons.bar_chart,
                color: _selectedIndex == 1 ? primary : (widget.isDarkMode ? Colors.white : Colors.black45), // Warna icon sesuai mode
                size: 30,
              ),
              onPressed: () => _onTappedItem(1),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primary, // Warna background ikon tombol tambah
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () => _onTappedItem(2),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.history,
                color: _selectedIndex == 3 ? primary : (widget.isDarkMode ? Colors.white : Colors.black45), // Warna icon sesuai mode
                size: 30,
              ),
              onPressed: () => _onTappedItem(3),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: _selectedIndex == 4 ? primary : (widget.isDarkMode ? Colors.white : Colors.black45), // Warna icon sesuai mode
                size: 30,
              ),
              onPressed: () => _onTappedItem(4),
            ),
          ],
        ),
      ),
    );
  }
}
