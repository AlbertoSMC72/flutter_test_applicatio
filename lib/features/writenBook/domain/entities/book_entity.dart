import 'genre_entity.dart';

class BookEntity {
  final int? id;
  final String title;
  final String description;
  final String? coverImage; // Base64 image string
  final bool? published;
  final dynamic createdAt; // Can be String or DateTime
  final int authorId;
  final List<int>? genreIds;
  final AuthorEntity? author;
  final List<GenreEntity>? genres;

  const BookEntity({
    this.id,
    required this.title,
    required this.description,
    this.coverImage,
    this.published,
    this.createdAt,
    required this.authorId,
    this.genreIds,
    this.author,
    this.genres,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookEntity &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.coverImage == coverImage &&
        other.published == published &&
        other.createdAt == createdAt &&
        other.authorId == authorId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        coverImage.hashCode ^
        published.hashCode ^
        createdAt.hashCode ^
        authorId.hashCode;
  }

  @override
  String toString() {
    return 'BookEntity(id: $id, title: $title, description: $description, authorId: $authorId, published: $published)';
  }

  // Helper method to check if book has cover image
  bool get hasCoverImage => coverImage != null && coverImage!.isNotEmpty;

  // Helper method to get formatted creation date
  String? get formattedCreatedAt {
    if (createdAt == null) return null;
    
    if (createdAt is String) {
      try {
        final date = DateTime.parse(createdAt);
        return _formatDate(date);
      } catch (e) {
        return createdAt;
      }
    } else if (createdAt is DateTime) {
      return _formatDate(createdAt);
    }
    
    return createdAt.toString();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Hace un momento';
    }
  }
}

class AuthorEntity {
  final String username;
  final String? profilePicture;

  const AuthorEntity({
    required this.username,
    this.profilePicture,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthorEntity &&
        other.username == username &&
        other.profilePicture == profilePicture;
  }

  @override
  int get hashCode => username.hashCode ^ profilePicture.hashCode;

  @override
  String toString() => 'AuthorEntity(username: $username, profilePicture: $profilePicture)';
}

