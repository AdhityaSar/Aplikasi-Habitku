// FILEPATH: d:/Semester_5/Aplikasi-Habitku/lib/my_navbar.dart

import 'package:aplikasi_habitku/pages/historypage.dart';
import 'package:aplikasi_habitku/pages/homepage.dart';
import 'package:aplikasi_habitku/pages/settingspage.dart';
import 'package:aplikasi_habitku/pages/statspage.dart';
import 'package:aplikasi_habitku/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_habitku/pages/addtask.dart';

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
  List<Map<String, dynamic>> tasks = [];

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addNewTask(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTask()),
    );

    if (result != null) {
      setState(() {
        tasks.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          MyHomePage(tasks: tasks, onAddTask: _addNewTask),
          StatsPage(),
          Historypage(),
          Settingspage( 
            onThemeChanged: widget.onThemeChanged,
             isDarkMode: widget.isDarkMode,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
       color: widget.isDarkMode ? Colors.black : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? primary : (widget.isDarkMode ? Colors.white : Colors.black45),
                size: 30,
              ),
              onPressed: () => _onTappedItem(0),
            ),
            IconButton(
              icon: Icon(
                Icons.bar_chart,
                color: _selectedIndex == 1 ? primary : (widget.isDarkMode ? Colors.white : Colors.black45),
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
                onPressed: () => _addNewTask(context),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.history,
                 color: _selectedIndex == 2 ? primary : (widget.isDarkMode ? Colors.white : Colors.black45),
                size: 30,
              ),
              onPressed: () => _onTappedItem(2),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: _selectedIndex == 3 ? primary : (widget.isDarkMode ? Colors.white : Colors.black45),
                size: 30,
              ),
              onPressed: () => _onTappedItem(3),
            ),
          ],
        ),
      ),
    );
  }
}