class PodcastEpisode {
  final String title;
  final String description;
  final String audioUrl;
  final String imageUrl;
  final String publishedDate;

  PodcastEpisode(
      {required this.title,
      required this.description,
      required this.audioUrl,
      required this.imageUrl,
      required this.publishedDate});

  // Example: Factory constructor to create from JSON
  factory PodcastEpisode.fromJson(Map<String, dynamic> json) {
    return PodcastEpisode(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      publishedDate: json['publishedDate'] ?? '',
    );
  }
}
