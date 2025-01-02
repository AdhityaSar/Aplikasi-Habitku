import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
            padding: const EdgeInsets.all(16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TODAYS',
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
                itemCount: 30,
                itemBuilder: (context, index) {
                  DateTime today = DateTime.now();
                  DateTime date = today.add(Duration(days: index));
                  bool isToday = date.day == today.day &&
                      date.month == today.month &&
                      date.year == today.year;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Container(
                      width: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                        color: isToday ? Color(0xff3843FF) : Colors.transparent,
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
                          SizedBox(height: 2),
                          Text(
                            _getDayName(date),
                            style: TextStyle(
                              fontSize: 10,
                              color: isToday ? Colors.white : Color(0xffa0a0a0),
                            ),
                          )
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/noActivities.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),

                // Teks di Bawah Ikon
                Text(
                  'There is nothing schedule',
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
