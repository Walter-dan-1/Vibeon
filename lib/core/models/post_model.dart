class PostModel {
  final String id;
  final String ownerId;
  final String mediaUrl;
  final String thumbnailUrl;
  final String caption;
  final List<String> tags;
  final int likes;
  final int views;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.ownerId,
    required this.mediaUrl,
    required this.thumbnailUrl,
    required this.caption,
    required this.tags,
    this.likes = 0,
    this.views = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'ownerId': ownerId,
    'mediaUrl': mediaUrl,
    'thumbnailUrl': thumbnailUrl,
    'caption': caption,
    'tags': tags,
    'likes': likes,
    'views': views,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };

  factory PostModel.fromMap(Map<String, dynamic> m) => PostModel(
    id: m['id'],
    ownerId: m['ownerId'],
    mediaUrl: m['mediaUrl'],
    thumbnailUrl: m['thumbnailUrl'] ?? '',
    caption: m['caption'] ?? '',
    tags: List<String>.from(m['tags'] ?? []),
    likes: m['likes'] ?? 0,
    views: m['views'] ?? 0,
    createdAt: DateTime.parse(m['createdAt']),
  );
}
