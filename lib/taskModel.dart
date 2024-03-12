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
      createdAt: DateTime.fromMillisecondsSinceEpoch(map["createdAt"])
          .toIso8601String(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map["updatedAt"])
              .toIso8601String()
          : null,
    );
  }
}
