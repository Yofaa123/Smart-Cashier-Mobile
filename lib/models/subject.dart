class SubjectModel {
  final int id;
  final String name;
  final String description;

  SubjectModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}
