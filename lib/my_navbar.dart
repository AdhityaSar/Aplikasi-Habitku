// FILEPATH: d:/Semester_5/Aplikasi-Habitku/lib/my_navbar.dart

import 'package:aplikasi_habitku/pages/historypage.dart';
import 'package:aplikasi_habitku/pages/homepage.dart';
import 'package:aplikasi_habitku/pages/settingspage.dart';
// import 'package:aplikasi_habitku/pages/statspage.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_habitku/pages/addtask.dart';

class MyNavbar extends StatefulWidget {
  const MyNavbar({super.key, required void Function(bool isDark) onThemeChanged, required bool isDarkMode});

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
          // StatsPage(),
          Historypage(),
          Settingspage( onThemeChanged: (bool isDark) => {}, isDarkMode: false),
        ],
      ),
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
                onPressed: () => _addNewTask(context),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.history,
                color: _selectedIndex == 2 ? const Color(0xff3843FF) : const Color(0xffCDCDD0),
                size: 30,
              ),
              onPressed: () => _onTappedItem(2),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: _selectedIndex == 3 ? const Color(0xff3843FF) : const Color(0xffCDCDD0),
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