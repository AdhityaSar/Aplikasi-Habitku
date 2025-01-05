class Task {
  final int? id;
  final String title;
  final String description;
  final int icon;
  final String date;
  final String time;
  final String category;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.date,
    required this.time,
    required this.category,
  });

  // Convert a Task into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'date': date,
      'time': time,
      'category': category,
    };
  }

  // Create a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      icon: map['icon'],
      date: map['date'],
      time: map['time'],
      category: map['category'],
    );
  }
}
