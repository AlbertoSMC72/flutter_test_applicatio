class DownloadedBookEntity {
  final String id;
  final String title;
  final String description;
  final List<String> genres;
  final String author;
  final String coverImageBase64;

  DownloadedBookEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.genres,
    required this.author,
    required this.coverImageBase64,
  });
} 