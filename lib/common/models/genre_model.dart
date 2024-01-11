class GenreModel {
  final String? id;
  final String? name;
  final String? genreId;
  final int? incrementId;
  final String? createdAt;
  final String? updatedAt;

  GenreModel({
    this.id,
    this.name,
    this.genreId,
    this.incrementId,
    this.createdAt,
    this.updatedAt,
  });

  GenreModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        name = json['name'] as String?,
        genreId = json['genre_id'] as String?,
        incrementId = json['increment_id'] as int?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
        // '_id' : id,
        'name': name,
        'genre_id': genreId,
        //'increment_id': incrementId,
        //'createdAt' : createdAt,
        //'updatedAt' : updatedAt
      };
}
