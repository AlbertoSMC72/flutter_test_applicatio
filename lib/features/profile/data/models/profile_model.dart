class Profile {
  final String id;
  final String username;
  final String email;
  final String friendCode;
  final String profilePicture;
  final String banner;
  final String? biography;
  final DateTime createdAt;
  final List<Genre> favoriteGenres;
  final List<Book> likedBooks;
  final List<OwnBook> ownBooks;
  final List<OwnBook> publishedBooks;
  final ProfileStats stats;

  Profile({
    required this.id,
    required this.username,
    required this.email,
    required this.friendCode,
    required this.profilePicture,
    required this.banner,
    this.biography,
    required this.createdAt,
    required this.favoriteGenres,
    required this.likedBooks,
    required this.ownBooks,
    required this.publishedBooks,
    required this.stats,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    print('[DEBUG] Parsing profile with keys: ${json.keys.toList()}');
    
    try {
      return Profile(
        id: json['id']?.toString() ?? '',
        username: json['username']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        friendCode: json['friendCode']?.toString() ?? '',
        profilePicture: json['profilePicture']?.toString() ?? '',
        banner: json['banner']?.toString() ?? '',
        biography: json['biography']?.toString(),
        createdAt: _parseDateTime(json['createdAt']),
        favoriteGenres: _parseGenres(json['favoriteGenres']),
        likedBooks: _parseBooks(json['likedBooks']),
        ownBooks: _parseOwnBooks(json['ownBooks']),
        publishedBooks: _parseOwnBooks(json['publishedBooks']),
        stats: json['stats'] != null 
            ? ProfileStats.fromJson(json['stats'] as Map<String, dynamic>)
            : ProfileStats.empty(),
      );
    } catch (e) {
      print('[ERROR] Error parsing profile: $e');
      rethrow;
    }
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    if (dateValue is String && dateValue.isNotEmpty) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  static List<Genre> _parseGenres(dynamic genresData) {
    if (genresData == null) return [];
    try {
      return (genresData as List<dynamic>)
          .map((genre) => Genre.fromJson(genre as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing genres: $e');
      return [];
    }
  }

  static List<Book> _parseBooks(dynamic booksData) {
    if (booksData == null) return [];
    try {
      return (booksData as List<dynamic>)
          .map((book) => Book.fromJson(book as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing books: $e');
      return [];
    }
  }

  static List<OwnBook> _parseOwnBooks(dynamic ownBooksData) {
    if (ownBooksData == null) return [];
    try {
      return (ownBooksData as List<dynamic>)
          .map((book) => OwnBook.fromJson(book as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing own books: $e');
      return [];
    }
  }

  @override
  String toString() {
    return 'Profile(id: $id, username: $username, email: $email, friendCode: $friendCode)';
  }
}

// ProfileStats Model
class ProfileStats {
  final int friendsCount;
  final int followersCount;
  final int booksWritten;
  final int booksLiked;

  ProfileStats({
    required this.friendsCount,
    required this.followersCount,
    required this.booksWritten,
    required this.booksLiked,
  });

  ProfileStats.empty()
      : friendsCount = 0,
        followersCount = 0,
        booksWritten = 0,
        booksLiked = 0;

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    try {
      return ProfileStats(
        friendsCount: json['friendsCount'] as int? ?? 0,
        followersCount: json['followersCount'] as int? ?? 0,
        booksWritten: json['booksWritten'] as int? ?? 0,
        booksLiked: json['booksLiked'] as int? ?? 0,
      );
    } catch (e) {
      print('Error parsing ProfileStats: $e');
      return ProfileStats.empty();
    }
  }

  @override
  String toString() {
    return 'ProfileStats(friends: $friendsCount, followers: $followersCount, written: $booksWritten, liked: $booksLiked)';
  }
}

// Genre Model
class Genre {
  final String id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    try {
      return Genre(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing Genre: $e');
      return Genre(id: '', name: 'Unknown');
    }
  }

  @override
  String toString() {
    return 'Genre(id: $id, name: $name)';
  }
}

// Author Model
class Author {
  final String username;

  Author({
    required this.username,
  });

  Author.empty() : username = 'Unknown';

  factory Author.fromJson(Map<String, dynamic> json) {
    try {
      return Author(
        username: json['username']?.toString() ?? 'Unknown',
      );
    } catch (e) {
      print('Error parsing Author: $e');
      return Author.empty();
    }
  }

  @override
  String toString() {
    return 'Author(username: $username)';
  }
}

// Book Model
class Book {
  final String id;
  final String title;
  final String description;
  final String coverImage;
  final Author author;

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.author,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    try {
      return Book(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        coverImage: json['coverImage']?.toString() ?? '',
        author: json['author'] != null 
            ? Author.fromJson(json['author'] as Map<String, dynamic>)
            : Author.empty(),
      );
    } catch (e) {
      print('Error parsing Book: $e');
      return Book(
        id: '',
        title: 'Unknown',
        description: '',
        coverImage: '',
        author: Author.empty(),
      );
    }
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, author: ${author.username})';
  }
}

// OwnBook Model
class OwnBook {
  final String id;
  final String title;
  final String description;
  final String coverImage;
  final bool published;
  final DateTime createdAt;

  OwnBook({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.published,
    required this.createdAt,
  });

  factory OwnBook.fromJson(Map<String, dynamic> json) {
    try {
      return OwnBook(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        coverImage: json['coverImage']?.toString() ?? '',
        published: json['published'] as bool? ?? false,
        createdAt: _parseDateTime(json['createdAt']),
      );
    } catch (e) {
      print('Error parsing OwnBook: $e');
      return OwnBook(
        id: '',
        title: 'Unknown',
        description: '',
        coverImage: '',
        published: false,
        createdAt: DateTime.now(),
      );
    }
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    if (dateValue is String && dateValue.isNotEmpty) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  @override
  String toString() {
    return 'OwnBook(id: $id, title: $title, published: $published)';
  }
}