// // FILEPATH: d:/Semester_5/Aplikasi-Habitku/lib/pages/addtask.dart

// import 'package:flutter/material.dart';

// class AddTask extends StatefulWidget {
//   @override
//   _AddTaskState createState() => _AddTaskState();
// }

// class _AddTaskState extends State<AddTask> {
//   String? selectedCategory;
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add New Task'),
//         backgroundColor: Color(0xff3843FF),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 labelText: 'Title',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(
//                 labelText: 'Description',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: selectedCategory,
//               decoration: InputDecoration(
//                 labelText: 'Category',
//                 border: OutlineInputBorder(),
//               ),
//               items: ['Work', 'Personal', 'Shopping', 'Health']
//                   .map((String category) {
//                 return DropdownMenuItem<String>(
//                   value: category,
//                   child: Text(category),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedCategory = newValue;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                 child: Text('Cancel'),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//               ElevatedButton(
//                 child: Text('Confirm'),
//                 style: ElevatedButton.styleFrom(
//                   textStyle: TextStyle(color: Colors.purple),
//                 ),
//                 onPressed: () {
//                   if (_titleController.text.isNotEmpty &&
//                       selectedCategory != null) {
//                     Navigator.of(context).pop({
//                       'title': _titleController.text,
//                       'description': _descriptionController.text,
//                       'category': selectedCategory,
//                     });
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Please fill all required fields')),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// FILEPATH: d:/Semester_5/Aplikasi-Habitku/lib/pages/addtask.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? selectedCategory;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<String> categories = ['Study', 'Task', 'Sports', 'Other'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showCategoryModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categories[index]),
                onTap: () {
                  setState(() {
                    selectedCategory = categories[index];
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
        backgroundColor: Color(0xff3843FF),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.category, color: Color(0xff3843FF)),
                    SizedBox(width: 8),
                    Text('Category'),
                  ],
                ),
                TextButton(
                  onPressed: _showCategoryModal,
                  child: Text(selectedCategory ?? 'Select Category'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Color(0xff3843FF)),
                    SizedBox(width: 8),
                    Text('Date'),
                  ],
                ),
                TextButton(
                  onPressed: _showDatePicker,
                  child: Text(
                    selectedDate == null
                        ? 'Select Date'
                        : DateFormat('yyyy-MM-dd').format(selectedDate!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: Color(0xff3843FF)),
                    SizedBox(width: 8),
                    Text('Time'),
                  ],
                ),
                TextButton(
                  onPressed: _showTimePicker,
                  child: Text(
                    selectedTime == null
                        ? 'Select Time'
                        : selectedTime!.format(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: Text('Confirm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () {
                  if (_titleController.text.isNotEmpty &&
                      selectedCategory != null &&
                      selectedDate != null &&
                      selectedTime != null) {
                    // Membuat objek task baru
                    final newTask = {
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'category': selectedCategory,
                      'date': selectedDate,
                      'time': selectedTime,
                    };
                    // Mengembalikan task baru ke halaman sebelumnya
                    Navigator.of(context).pop(newTask);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all required fields')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
