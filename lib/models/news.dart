class News {
  final String content;
  final String title;
  final String imageUrl;
  final String publishedAt;

  News({
    required this.content,
    required this.title,
    required this.imageUrl,
    required this.publishedAt,
  });

  // Factory method to create a News object from JSON data
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      content: json['description'],
      title: json['title'],
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150',
      publishedAt: DateTime.parse(json['publishedAt']).toLocal().toString(),
    );
  }

  // Method to convert a News object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'description': content,
      'title': title,
      'image': imageUrl,
      'publishedAt': publishedAt,
    };
  }
}
