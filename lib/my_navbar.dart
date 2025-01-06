import 'package:flutter/material.dart';
import 'package:aplikasi_habitku/pages/homepage.dart';
import 'package:aplikasi_habitku/pages/statspage.dart';
import 'package:aplikasi_habitku/pages/historypage.dart';
import 'package:aplikasi_habitku/pages/settingspage.dart';
import 'package:aplikasi_habitku/pages/addtask.dart';
import 'package:aplikasi_habitku/theme/theme.dart';
import 'package:aplikasi_habitku/helper/database_helper.dart';
import 'package:aplikasi_habitku/models/task_model.dart';

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
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final dbTasks = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      tasks = dbTasks;
    });
  }

  Future<void> _addNewTask(BuildContext context, [Task? task]) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddTask(task: task)),
  );

  if (result != null) {
    await _loadTasks();
    setState(() {});
  }
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
          const Statspage(),
          const Historypage(),
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
            _buildNavbarItem(Icons.home, 0),
            _buildNavbarItem(Icons.bar_chart, 1),
            _buildAddButton(),
            _buildNavbarItem(Icons.history, 2),
            _buildNavbarItem(Icons.settings, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavbarItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: _selectedIndex == index
            ? primary
            : (widget.isDarkMode ? Colors.white : Colors.black45),
        size: 30,
      ),
      onPressed: () => _onTappedItem(index),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xff3843FF),
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
    );
  }
}