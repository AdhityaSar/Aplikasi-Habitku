import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Bagian Kalender Horizontal
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                DateTime today = DateTime.now();
                DateTime date = today.add(Duration(days: index - 1));
                return Column(
                  children: [
                    Text(
                      date.day.toString(), // Menampilkan tanggal
                      style: TextStyle(
                        color: index == 1 ? const Color(0xff3843FF) : const Color(0xff000000),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDayName(date), // Nama hari (MON, TUE, dll.)
                      style: TextStyle(
                        color: index == 1 ? const Color(0xff3843FF) : const Color(0xffA0A0A0),
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              }),
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
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(
                Icons.bar_chart,
                color: _selectedIndex == 1 ? const Color(0xff3843FF) : const Color(0xffCDCDD0),
                size: 30,
              ),
              onPressed: () => _onItemTapped(1),
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
                onPressed: () => _onItemTapped(2),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.history,
                color: _selectedIndex == 3 ? const Color(0xff3843FF) : const Color(0xffCDCDD0),
                size: 30,
              ),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: _selectedIndex == 4 ? const Color(0xff3843FF) : const Color(0xffCDCDD0),
                size: 30,
              ),
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mendapatkan nama hari (contoh: MON, TUE)
  String _getDayName(DateTime date) {
    List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return days[date.weekday % 7];
  }
}
