import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyHomePage extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final Function(BuildContext) onAddTask;

  const MyHomePage({Key? key, required this.tasks, required this.onAddTask})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Bagian Kalender Horizontal
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Todays',
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
                itemCount: 60, // Increased to show more days
                itemBuilder: (context, index) {
                  DateTime today = DateTime.now();
                  DateTime date = today.add(
                      Duration(days: index - 30)); // Start from 30 days ago
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
                                  ? Color(0xff3843FF).withOpacity(0.3)
                                  : Colors.transparent,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: isSelected || isToday
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              _getDayName(date),
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected || isToday
                                    ? Colors.white
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

          // Konten di Tengah
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
                      return ListTile(
                        title: Text(widget.tasks[index]['title']),
                        subtitle: Text(widget.tasks[index]['description']),
                        trailing: Text(widget.tasks[index]['category']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Menambahkan modal calendar
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
                headerStyle: HeaderStyle(formatButtonVisible: false),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color:
                        Color(0xff3843FF), // Change this to your desired color
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

  // Fungsi untuk mendapatkan nama hari (contoh: MON, TUE)
  String _getDayName(DateTime date) {
    List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return days[date.weekday % 7];
  }
}
