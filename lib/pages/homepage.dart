import 'package:aplikasi_habitku/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final Future<Map<String, dynamic>?> Function(BuildContext, Map<String, dynamic>?) onAddTask;

  const MyHomePage({Key? key, required this.tasks, required this.onAddTask}) : super(key: key);

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
    // _loadTasks();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  Future<void> _editTask(int index) async {
    final task = widget.tasks[index];
    final updatedTask = await widget.onAddTask(context, task);
    if (updatedTask != null) {
      setState(() {
        widget.tasks[index] = updatedTask;
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      widget.tasks.removeAt(index);
    });
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
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
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
                          icon: Icon(Icons.calendar_month, color: Color(0xffCDCDD0))),
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

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = date;
                      });
                      // TODO: Add logic to filter tasks for the selected day
                    },
                    behavior: HitTestBehavior.opaque, // Add this line
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                          color: isSelected
                              ? Color(0xff3843FF)
                              : isToday
                                  ? (_selectedDay != null &&
                                          !isSameDay(_selectedDay!, today))
                                      ? Color(0xffE6E8FF)
                                      : Color(0xff3843FF)
                                  : Colors.transparent,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected ||
                                        (isToday &&
                                            (_selectedDay == null ||
                                                isSameDay(
                                                    _selectedDay!, today)))
                                    ? Colors.white
                                    : isToday
                                        ? Color(0xff3843FF)
                                        : Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              _getDayName(date),
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected ||
                                        (isToday &&
                                            (_selectedDay == null ||
                                                isSameDay(
                                                    _selectedDay!, today)))
                                    ? Colors.white
                                    : isToday
                                        ? Color(0xff3843FF)
                                        : Color(0xffa0a0a0),
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
            child: widget.tasks.isEmpty
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
                          color: const Color(0xff000000),
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
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) {
                      final task = widget.tasks[index];
                      DateTime taskDate = task['date'] is String
                          ? DateTime.parse(task['date'])
                          : task['date'];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: Icon(
                            _getIcon(task['category']),
                            color: _getIconColor(task['category']),
                            size: 40,
                          ),
                          title: Text(task['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Time: ${DateFormat('hh:mm a').format(taskDate)}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14)),
                              SizedBox(height: 4),
                              Text(task['description'],
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