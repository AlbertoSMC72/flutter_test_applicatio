import '../../domain/entities/genre_entity.dart';

class GenreModel extends GenreEntity {
  const GenreModel({
    super.id,
    required super.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  factory GenreModel.fromEntity(GenreEntity entity) {
    return GenreModel(
      id: entity.id,
      name: entity.name,
    );
  }

  GenreEntity toEntity() {
    return GenreEntity(
      id: id,
      name: name,
    );
  }
}