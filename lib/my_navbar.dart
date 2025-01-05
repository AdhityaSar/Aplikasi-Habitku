// FILEPATH: d:/Semester_5/Aplikasi-Habitku/lib/my_navbar.dart

import 'package:flutter/material.dart';
import 'package:aplikasi_habitku/pages/homepage.dart';
import 'package:aplikasi_habitku/pages/statspage.dart';
import 'package:aplikasi_habitku/pages/historypage.dart';
import 'package:aplikasi_habitku/pages/settingspage.dart';
import 'package:aplikasi_habitku/pages/addtask.dart';
import 'package:aplikasi_habitku/theme/theme.dart';

class MyNavbar extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;

  const MyNavbar({
    Key? key,
    required this.onThemeChanged,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<MyNavbar> createState() => _MyNavbarState();
}

class _MyNavbarState extends State<MyNavbar> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> tasks = [];

  Future<Map<String, dynamic>?> _addNewTask(BuildContext context, [Map<String, dynamic>? task]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTask(task: task)),
    );

    if (result != null) {
      if (task == null) {
        setState(() {
          tasks.add(result);
        });
      } else {
        setState(() {
          final index = tasks.indexOf(task);
          tasks[index] = result;
        });
      }
    }

    return result;
  }

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                color: _selectedIndex == 0
                    ? primary
                    : (widget.isDarkMode ? Colors.white : Colors.black45),
                size: 30,
              ),
              onPressed: () => _onTappedItem(0),
            ),
            IconButton(
              icon: Icon(
                Icons.bar_chart,
                color: _selectedIndex == 1
                    ? primary
                    : (widget.isDarkMode ? Colors.white : Colors.black45),
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
                color: _selectedIndex == 2
                    ? primary
                    : (widget.isDarkMode ? Colors.white : Colors.black45),
                size: 30,
              ),
              onPressed: () => _onTappedItem(2),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: _selectedIndex == 3
                    ? primary
                    : (widget.isDarkMode ? Colors.white : Colors.black45),
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