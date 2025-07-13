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
    required this.stats,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      friendCode: json['friendCode'] as String,
      profilePicture: json['profilePicture'] as String? ?? '',
      banner: json['banner'] as String? ?? '',
      biography: json['biography'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      favoriteGenres: (json['favoriteGenres'] as List<dynamic>?)
          ?.map((genre) => Genre.fromJson(genre as Map<String, dynamic>))
          .toList() ?? [],
      likedBooks: (json['likedBooks'] as List<dynamic>?)
          ?.map((book) => Book.fromJson(book as Map<String, dynamic>))
          .toList() ?? [],
      ownBooks: (json['ownBooks'] as List<dynamic>?)
          ?.map((book) => OwnBook.fromJson(book as Map<String, dynamic>))
          .toList() ?? [],
      stats: ProfileStats.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'friendCode': friendCode,
      'profilePicture': profilePicture,
      'banner': banner,
      'biography': biography,
      'createdAt': createdAt.toIso8601String(),
      'favoriteGenres': favoriteGenres.map((genre) => genre.toJson()).toList(),
      'likedBooks': likedBooks.map((book) => book.toJson()).toList(),
      'ownBooks': ownBooks.map((book) => book.toJson()).toList(),
      'stats': stats.toJson(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'username': username,
      'biography': biography,
      'favoriteGenres': favoriteGenres.map((genre) => genre.id).toList(),
    };
  }

  Profile copyWith({
    String? id,
    String? username,
    String? email,
    String? friendCode,
    String? profilePicture,
    String? banner,
    String? biography,
    DateTime? createdAt,
    List<Genre>? favoriteGenres,
    List<Book>? likedBooks,
    List<OwnBook>? ownBooks,
    ProfileStats? stats,
  }) {
    return Profile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      friendCode: friendCode ?? this.friendCode,
      profilePicture: profilePicture ?? this.profilePicture,
      banner: banner ?? this.banner,
      biography: biography ?? this.biography,
      createdAt: createdAt ?? this.createdAt,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      likedBooks: likedBooks ?? this.likedBooks,
      ownBooks: ownBooks ?? this.ownBooks,
      stats: stats ?? this.stats,
    );
  }

  @override
  String toString() {
    return 'Profile(id: $id, username: $username, email: $email, friendCode: $friendCode, biography: $biography)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Profile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Genre {
  final String id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'Genre(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Genre && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

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
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      coverImage: json['coverImage'] as String? ?? '',
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverImage': coverImage,
      'author': author.toJson(),
    };
  }

  @override
  String toString() => 'Book(id: $id, title: $title, author: ${author.username})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

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
    return OwnBook(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      coverImage: json['coverImage'] as String? ?? '',
      published: json['published'] as bool,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverImage': coverImage,
      'published': published,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'OwnBook(id: $id, title: $title, published: $published)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OwnBook && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Author {
  final String username;

  Author({
    required this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }

  @override
  String toString() => 'Author(username: $username)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Author && other.username == username;
  }

  @override
  int get hashCode => username.hashCode;
}

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

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      friendsCount: json['friendsCount'] as int,
      followersCount: json['followersCount'] as int,
      booksWritten: json['booksWritten'] as int,
      booksLiked: json['booksLiked'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friendsCount': friendsCount,
      'followersCount': followersCount,
      'booksWritten': booksWritten,
      'booksLiked': booksLiked,
    };
  }

  @override
  String toString() {
    return 'ProfileStats(friendsCount: $friendsCount, followersCount: $followersCount, booksWritten: $booksWritten, booksLiked: $booksLiked)';
  }
}