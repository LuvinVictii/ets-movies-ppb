final String tableMovies = 'movies';

class MovieFields {
  static final List<String> values = [
    id, title, addedDate, coverImage, description
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String addedDate = 'added_date';
  static final String coverImage = 'cover_image';
  static final String description = 'description';
}

class Movie {
  final int? id;
  final String title;
  final DateTime addedDate;
  final String coverImage;
  final String description;

  const Movie({
    this.id,
    required this.title,
    required this.addedDate,
    required this.coverImage,
    required this.description,
  });

  Movie copy({
    int? id,
    String? title,
    DateTime? addedDate,
    String? coverImage,
    String? description,
  }) =>
      Movie(
        id: id ?? this.id,
        title: title ?? this.title,
        addedDate: addedDate ?? this.addedDate,
        coverImage: coverImage ?? this.coverImage,
        description: description ?? this.description,
      );

  static Movie fromJson(Map<String, Object?> json) => Movie(
        id: json[MovieFields.id] as int?,
        title: json[MovieFields.title] as String,
        addedDate: DateTime.parse(json[MovieFields.addedDate] as String),
        coverImage: json[MovieFields.coverImage] as String,
        description: json[MovieFields.description] as String,
      );

  Map<String, Object?> toJson() => {
        MovieFields.id: id,
        MovieFields.title: title,
        MovieFields.addedDate: addedDate.toIso8601String(),
        MovieFields.coverImage: coverImage,
        MovieFields.description: description,
      };
}
