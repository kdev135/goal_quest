class Blog {
  final int id;
  final DateTime createdAt;
  final String title;
  final List<String> tags;
  final String content;
  final String readTime;
  final String? bannerImageUrl;
  final String? thumbnailUrl;

  Blog({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.tags,
    required this.content,
    required this.readTime,
    this.bannerImageUrl,
    this.thumbnailUrl,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      title: json['title'],
      tags: List<String>.from(json['tags']),
      content: json['content'],
      readTime: json['read_time'],
      bannerImageUrl: json['banner_image_url'],
      thumbnailUrl: json['thumbnail_url'],
    );
  }
}