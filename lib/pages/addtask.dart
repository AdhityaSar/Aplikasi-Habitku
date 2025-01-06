// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class AddTask extends StatefulWidget {
//   final Map<String, dynamic>? task;

//   const AddTask({Key? key, this.task}) : super(key: key);

//   @override
//   _AddTaskState createState() => _AddTaskState();
// }

// class _AddTaskState extends State<AddTask> {
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   String? selectedCategory;
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

//   final List<Map<String, dynamic>> categories = [
//     {'icon': Icons.book, 'label': 'Study'},
//     {'icon': Icons.task, 'label': 'Task'},
//     {'icon': Icons.sports, 'label': 'Sports'},
//     {'icon': Icons.more_horiz, 'label': 'Other'},
//   ];

//   @override
//   void initState() {
//     super.initState();

//     if (widget.task != null) {
//       _titleController.text = widget.task!['title'] ?? '';
//       _descriptionController.text = widget.task!['description'] ?? '';
//       selectedCategory = widget.task!['category'];
//       selectedDate = widget.task!['date'] is String
//           ? DateTime.parse(widget.task!['date'])
//           : widget.task!['date'];
//       selectedTime = widget.task!['time'] != null
//           ? TimeOfDay(
//               hour: int.parse(widget.task!['time'].split(":")[0]),
//               minute: int.parse(widget.task!['time'].split(":")[1]),
//             )
//           : null;
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//     void _showCategoryDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select Category'),
//           content: Container(
//             width: double.maxFinite,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: Icon(categories[index]['icon'] as IconData?, color: Color(0xff3843FF)),
//                   title: Text(categories[index]['label']),
//                   onTap: () {
//                     setState(() {
//                       selectedCategory = categories[index]['label'];
//                     });
//                     Navigator.pop(context);
//                   },
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showDatePicker() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   void _showTimePicker() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime ?? TimeOfDay.now(),
//     );
//     if (picked != null && picked != selectedTime) {
//       setState(() {
//         selectedTime = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add New Task'),
//         backgroundColor: Color(0xff3843FF),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 labelText: 'Task Name',
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
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.category, color: Color(0xff3843FF)),
//                     SizedBox(width: 8),
//                     Text('Category'),
//                   ],
//                 ),
//                 TextButton(
//                   onPressed: _showCategoryDialog,
//                   child: Text(selectedCategory ?? 'Select Category'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, color: Color(0xff3843FF)),
//                     SizedBox(width: 8),
//                     Text('Date'),
//                   ],
//                 ),
//                 TextButton(
//                   onPressed: _showDatePicker,
//                   child: Text(
//                     selectedDate == null
//                         ? 'Select Date'
//                         : DateFormat('yyyy-MM-dd').format(selectedDate!),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.access_time, color: Color(0xff3843FF)),
//                     SizedBox(width: 8),
//                     Text('Time'),
//                   ],
//                 ),
//                 TextButton(
//                   onPressed: _showTimePicker,
//                   child: Text(
//                     selectedTime == null
//                         ? 'Select Time'
//                         : selectedTime!.format(context),
//                   ),
//                 ),
//               ],
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
//                 onPressed: () {
//                   if (_titleController.text.isNotEmpty &&
//                       selectedCategory != null &&
//                       selectedDate != null &&
//                       selectedTime != null) {
//                     final newTask = {
//                       'title': _titleController.text,
//                       'description': _descriptionController.text,
//                       'category': selectedCategory,
//                       'date': DateTime(
//                         selectedDate!.year,
//                         selectedDate!.month,
//                         selectedDate!.day,
//                         selectedTime!.hour,
//                         selectedTime!.minute,
//                       ), // Gabungkan tanggal dan waktu
//                     };
//                     Navigator.of(context).pop(newTask);
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_habitku/models/task_model.dart';
import 'package:aplikasi_habitku/helper/database_helper.dart';

class AddTask extends StatefulWidget {
  final Task? task;

  const AddTask({Key? key, this.task}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? selectedCategory;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.book, 'label': 'Study'},
    {'icon': Icons.task, 'label': 'Task'},
    {'icon': Icons.sports, 'label': 'Sports'},
    {'icon': Icons.more_horiz, 'label': 'Other'},
  ];

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      selectedCategory = widget.task!.category;
      selectedDate = DateTime.parse(widget.task!.date);
      selectedTime = TimeOfDay(
        hour: int.parse(widget.task!.time.split(":")[0]),
        minute: int.parse(widget.task!.time.split(":")[1]),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Category'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(categories[index]['icon'] as IconData?, color: Color(0xff3843FF)),
                  title: Text(categories[index]['label']),
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index]['label'];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
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
                  onPressed: _showCategoryDialog,
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
                onPressed: () async {
                  if (_titleController.text.isNotEmpty &&
                      selectedCategory != null &&
                      selectedDate != null &&
                      selectedTime != null) {
                    final newTask = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      icon: categories.firstWhere((element) => element['label'] == selectedCategory)['icon'].codePoint,
                      date: DateFormat('yyyy-MM-dd').format(selectedDate!),
                      time: selectedTime!.format(context),
                      category: selectedCategory!,
                    );

                    if (widget.task == null) {
                      await DatabaseHelper.instance.insert(newTask);
                    } else {
                      await DatabaseHelper.instance.update(newTask);
                    }

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