import 'package:aplikasi_habitku/models/task_model.dart';
import 'package:aplikasi_habitku/helper/database_helper.dart';
import 'package:aplikasi_habitku/pages/addtask.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyHomePage extends StatefulWidget {
  final List<Task> tasks;
  final Future<void> Function(BuildContext, [Task?]) onAddTask;

  const MyHomePage({Key? key, required this.tasks, required this.onAddTask})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController _scrollController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _selectedDay = DateTime.now();
    _loadTasks();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  Future<void> _navigateToAddTask() async {
    // Navigasi ke halaman AddTask
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTask()),
    );

    // Jika task baru berhasil dibuat
    if (newTask != null && newTask is Task) {
      setState(() {
        tasks.add(newTask); // Tambahkan task baru ke daftar
      });
    }
  }

  Future<void> _loadTasks() async {
    final dbTasks = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      tasks = dbTasks;
    });
  }

  Future<void> _editTask(int index) async {
    final task = tasks[index];
    await widget.onAddTask(context, task);
    await _loadTasks();
  }

  Future<void> _deleteTask(int index) async {
    await DatabaseHelper.instance.delete(tasks[index].id!);
    await _loadTasks();
  }

  void _scrollToToday() {
    final middleIndex = 30;
    final middleOffset = middleIndex * 60.0;

    _scrollController.animateTo(
      middleOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToSelectedDate() {
    if (_selectedDay != null) {
      final int index = DateTime.now().difference(_selectedDay!).inDays + 30;
      _scrollController.animateTo(
        index * 54.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => _showMonthCalendar(context),
                          icon: Icon(Icons.calendar_month,
                              color: Color(0xffCDCDD0))),
                      SizedBox(width: 8),
                      Icon(Icons.help_outline, color: Color(0xffCDCDD0)),
                    ],
                  )
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 64,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 60,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  DateTime today = DateTime.now();
                  DateTime date = today.add(Duration(days: index - 30));
                  bool isToday = date.day == today.day &&
                      date.month == today.month &&
                      date.year == today.year;
                  bool isSelected =
                      _selectedDay != null && isSameDay(_selectedDay!, date);

                  // Deteksi mode gelap atau terang
                  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = date;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                          color: isSelected
                              ? Color(0xff3843FF) // Warna latar belakang untuk hari yang dipilih
                              : isToday
                                  ? (isDarkMode ? Colors.white : Color(0xffE6E8FF)) // Warna latar belakang untuk hari ini
                                  : Colors.transparent, // Warna latar belakang untuk hari lainnya
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white // Teks putih untuk hari yang dipilih
                                    : isToday
                                        ? (isDarkMode ? Colors.black : Color(0xff3843FF)) // Teks untuk hari ini di darkmode dan lightmode
                                        : (isDarkMode ? Colors.white : Colors.black), // Teks untuk hari lainnya
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              _getDayName(date),
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected
                                    ? Colors.white // Teks putih untuk hari yang dipilih
                                    : isToday
                                        ? (isDarkMode ? Colors.black : Color(0xff3843FF)) // Teks hari ini di darkmode dan lightmode
                                        : (isDarkMode ? Colors.grey[300] : Colors.black45), // Teks hari lainnya
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: tasks.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/noActivities.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'There is nothing scheduled',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adding new activities',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xffA0A0A0),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      DateTime taskDate = DateTime.parse(task.date);

                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: Icon(
                            _getIcon(task.category),
                            color: _getIconColor(task.category),
                            size: 40,
                          ),
                          title: Text(task.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Time: ${task.time}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14)),
                              SizedBox(height: 4),
                              Text(task.description,
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editTask(index);
                              } else if (value == 'delete') {
                                _deleteTask(index);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showMonthCalendar(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 1, 1),
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _scrollToSelectedDate();
                  Navigator.pop(context);
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                headerStyle: HeaderStyle(formatButtonVisible: false),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Color(0xff3843FF),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                    color: Color(0xff3843FF).withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(color: Colors.white),
                ),
              ));
        });
  }

  String _getDayName(DateTime date) {
    List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return days[date.weekday % 7];
  }

  IconData _getIcon(String category) {
    switch (category) {
      case 'Sports':
        return Icons.sports;
      case 'Study':
        return Icons.book;
      case 'Task':
        return Icons.task;
      default:
        return Icons.event;
    }
  }

  Color _getIconColor(String category) {
    switch (category) {
      case 'Sports':
        return Colors.green;
      case 'Study':
        return Colors.blue;
      case 'Task':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}