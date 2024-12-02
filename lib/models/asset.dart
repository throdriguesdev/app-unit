class Asset {
  final int? id;
  final String name;
  final String description;
  final String category;
  final String status;

  Asset({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.status,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      category: json['category'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'category': category,
    'status': status,
  };
}
