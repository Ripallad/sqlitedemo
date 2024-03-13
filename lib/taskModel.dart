class TaskModel {
  int id;
  String title;
  String createdAt;
  String? updatedAt;
  TaskModel({
    required this.id,
    required this.title,
    required this.createdAt,
    this.updatedAt,
  });

  factory TaskModel.fromSqliteDatabase(Map<String, dynamic> map) {
    return TaskModel(
      id: (map["id"] ?? 0) as int,
      title: (map["title"] ?? '') as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map["created_at"])
          .toIso8601String(),
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map["updated_at"])
              .toIso8601String()
          : null,
    );
  }
}
