class GenreEntity {
  final int? id;
  final String name;

  const GenreEntity({
    this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GenreEntity &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode;
  }

  @override
  String toString() {
    return 'GenreEntity(id: $id, name: $name)';
  }
}