import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'addtask.dart';

class MyHomePage extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;

  const MyHomePage({Key? key, required this.tasks}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late List<Map<String, dynamic>> _tasks; 

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.tasks); 
  }

  void _addNewTask(BuildContext context) async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTask()),
    );

    if (newTask != null && newTask is Map<String, dynamic>) {
      setState(() {
        _tasks.add(newTask); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addNewTask(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Bagian Kalender Horizontal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TODAYS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _showMonthCalendar(context),
                      icon: const Icon(Icons.calendar_month, color: Color(0xffCDCDD0)),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.help_outline, color: Color(0xffCDCDD0)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 64,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 30,
                itemBuilder: (context, index) {
                  DateTime today = DateTime.now();
                  DateTime date = today.add(Duration(days: index));
                  bool isToday = isSameDay(date, today);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Container(
                      width: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                        color: isToday ? const Color(0xff3843FF) : Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: isToday ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getDayName(date),
                            style: TextStyle(
                              fontSize: 10,
                              color: isToday ? Colors.white : const Color(0xffa0a0a0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Konten di Tengah
          Expanded(
            child: _tasks.isEmpty
                ? _buildEmptyTasksView()
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return ListTile(
                        leading: const Icon(Icons.task, color: Color(0xff3843FF)),
                        title: Text(task['title']),
                        subtitle: Text(task['description']),
                        trailing: Text(
                          task['category'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTasksView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/noActivities.png',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        const Text(
          'There is nothing scheduled',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff000000),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Try adding new activities',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xffA0A0A0),
          ),
        ),
      ],
    );
  }

  // Menampilkan modal calendar
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
              Navigator.pop(context);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: const Color(0xff3843FF),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: const Color(0xff3843FF).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // Fungsi untuk mendapatkan nama hari (contoh: MON, TUE)
  String _getDayName(DateTime date) {
    const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return days[date.weekday % 7];
  }
}
