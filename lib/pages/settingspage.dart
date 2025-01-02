import 'package:flutter/material.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  final ValueChanged<bool> onThemeChanged; // Callback untuk mengubah tema
  final bool isDarkMode; // Status tema saat ini

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Menengahkan judul
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Konten sejajar ke kiri
          children: [
            // Dark Mode Toggle
            Row(
              children: [
                const Icon(Icons.brightness_6, size: 30),
                const SizedBox(width: 16),
                const Text(
                  'Theme',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Switch(
                  value: widget.isDarkMode,
                  onChanged: (bool value) {
                    widget.onThemeChanged(value); // Mengubah tema
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Notifications
            Row(
              children: const [
                Icon(Icons.notifications_rounded, size: 30),
                SizedBox(width: 16),
                Text(
                  'Notifications and Alarm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
