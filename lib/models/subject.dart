class SubjectModel {
  final int id;
  final String name;
  final String description;
  int? bookmarkId; // For bookmark management

  SubjectModel({
    required this.id,
    required this.name,
    required this.description,
    this.bookmarkId,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      bookmarkId: json['bookmark_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'bookmark_id': bookmarkId,
    };
  }
}
