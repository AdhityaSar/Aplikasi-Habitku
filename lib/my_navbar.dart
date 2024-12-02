import 'package:aplikasi_habitku/pages/homepage.dart';
import 'package:aplikasi_habitku/pages/your_stats.dart';
import 'package:flutter/material.dart';

class MyNavbar extends StatefulWidget {
  const MyNavbar({super.key});

  @override
  State<MyNavbar> createState() => _MyNavbarState();
}

class _MyNavbarState extends State<MyNavbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    MyHomePage(), 
    YourStats(),
    Center(child: Text('Add Activity Page')), // Placeholder for Add Activity
    Center(child: Text('History Page')), // Placeholder for History
    Center(child: Text('Settings Page')), // Placeholder for Settings
  ];

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? const Color(0xff3843FF) : const Color(0xffCDCDD0),
                size: 30,
              ),
              onPressed: () => _onTappedItem(0),
            ),
            IconButton(
              icon: Icon(
                Icons.bar_chart,
                color: _selectedIndex == 1 ? const Color(0xff3843FF) : const Color(0xffCDCDD0),
                size: 30,
              ),
              onPressed: () => _onTappedItem(1),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xff3843FF),
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
                color: _selectedIndex == 3 ? const Color(0xff3843FF) : const Color(0xffCDCDD0),
                size: 30,
              ),
              onPressed: () => _onTappedItem(3),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: _selectedIndex == 4 ? const Color(0xff3843FF) : const Color(0xffCDCDD0),
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
