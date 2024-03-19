class GetUsers {
  final int id;
  final String title;
  final String description;
  final String image;

  GetUsers(
      {required this.id,
      required this.title,
      required this.description,
      required this.image});

  factory GetUsers.fromJson(Map<String, dynamic> json) {
    return GetUsers(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json.containsKey('image_url') ? json['image_url'] ?? '' : '',
    );
  }
}
