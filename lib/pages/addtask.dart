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
  bool isLoading = false;

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

      try {
        final parsedTime = DateFormat.jm().parse(widget.task!.time); // Format 12 jam
        selectedTime = TimeOfDay(
          hour: parsedTime.hour,
          minute: parsedTime.minute,
        );
      } catch (e) {
        print('Error parsing time: $e');
        selectedTime = TimeOfDay.now();
      }
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
          title: const Text('Select Category'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    categories[index]['icon'] as IconData?,
                    color: const Color(0xff3843FF),
                  ),
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
        title: const Text('Add New Task'),
        backgroundColor: const Color(0xff3843FF),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
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
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  if (_titleController.text.isNotEmpty &&
                      selectedCategory != null &&
                      selectedDate != null &&
                      selectedTime != null) {
                    setState(() {
                      isLoading = true;
                    });

                    final newTask = Task(
                      title: _titleController.text.trim(),
                      description: _descriptionController.text.trim(),
                      icon: categories
                          .firstWhere(
                              (element) => element['label'] == selectedCategory)['icon']
                          .codePoint,
                      date: DateFormat('yyyy-MM-dd').format(selectedDate!),
                      time: selectedTime!.format(context),
                      category: selectedCategory!,
                    );

                    try {
                      if (widget.task == null) {
                        await DatabaseHelper.instance.insert(newTask);
                      } else {
                        await DatabaseHelper.instance.update(newTask);
                      }

                      setState(() {
                        isLoading = false;
                      });

                      Navigator.of(context).pop(newTask); // Kembalikan task ke layar sebelumnya
                    } catch (e) {
                      print('Error: $e');
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to save task')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields')),
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
