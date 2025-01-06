import 'package:aplikasi_habitku/pages/addtask.dart';
import 'package:aplikasi_habitku/theme/randomcolor.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_habitku/models/task_model.dart';
import 'package:aplikasi_habitku/helper/database_helper.dart';

class Historypage extends StatefulWidget {
  const Historypage({super.key});

  @override
  State<Historypage> createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  List<Task> tasks = [];  // Menyimpan daftar task yang ditampilkan di history

  @override
  void initState() {
    super.initState();
    _loadTasks();  // Memuat task saat halaman dimulai
  }

  // Memuat task dari database
  void _loadTasks() async {
    final taskList = await DatabaseHelper.instance.queryAllRows(); // Mengambil data task dari database
    setState(() {
      tasks = taskList;
    });
  }

  // Fungsi untuk menghapus task
  void _deleteTask(int id) async {
    await DatabaseHelper.instance.delete(id);  // Menghapus task dari database
    _loadTasks();  // Memuat ulang task setelah dihapus
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task berhasil dihapus')));
  }

  // Fungsi untuk mengedit task
  void _editTask(Task task) async {
    // Menavigasi ke halaman untuk mengedit task
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddTask(task: task),
    ));
    if (result != null) {
      _loadTasks();  // Memuat ulang task setelah diedit
    }
  }

  // Fungsi untuk mendapatkan tanggal real-time
  String getCurrentDate() {
    final DateTime now = DateTime.now();
    return "${now.day} ${_getMonthName(now.month)} ${now.year}";
  }

  // Fungsi untuk mendapatkan nama bulan berdasarkan nomor bulan
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HISTORY',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Menampilkan tanggal saat ini di sebelah kanan judul "HISTORY"
            Text(
              getCurrentDate(), // Menampilkan tanggal real-time
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: tasks.isEmpty
            ? Center(child: Text('Tidak ada history'))
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  // Mendapatkan warna acak untuk setiap task
                  Color randomColor = getRandomColor(context);

                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: randomColor,  // Menggunakan warna acak
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.access_alarms_outlined, color: Colors.white),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              // Menambahkan waktu ke tampilan
                              Text(
                                task.time, // Menampilkan waktu
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
