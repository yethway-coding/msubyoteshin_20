import '/common/models/actor_model.dart';
import '/common/models/genre_model.dart';
import '/common/models/source_model.dart';

class MovieModel {
  String? id;
  String? title;
  String? poster;
  String? backdrop;
  String? trailer;
  String? releaseYear;
  String? runtime;
  String? rating;
  String? overview;
  List<SourceModel>? sources;
  List<ActorModel>? actors;
  List<GenreModel>? genres;
  String? createdAt;
  String? updatedAt;
  int? v;

  MovieModel({
    this.id,
    this.title,
    this.poster,
    this.backdrop,
    this.trailer,
    this.releaseYear,
    this.runtime,
    this.rating,
    this.overview,
    this.sources,
    this.actors,
    this.genres,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  MovieModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    title = json['title'] as String?;
    poster = json['poster'] as String?;
    backdrop = json['backdrop'] as String?;
    trailer = json['trailer'] as String?;
    releaseYear = json['release_year'] as String?;
    runtime = json['runtime'] as String?;
    rating = json['rating'] as String?;
    overview = json['overview'] as String?;
    sources = (json['sources'] as List?)
        ?.map((dynamic e) => SourceModel.fromJson(e as Map<String, dynamic>))
        .toList();
    actors = (json['actors'] as List?)
        ?.map((dynamic e) => ActorModel.fromJson(e as Map<String, dynamic>))
        .toList();
    genres = (json['genres'] as List?)
        ?.map((dynamic e) => GenreModel.fromJson(e as Map<String, dynamic>))
        .toList();
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    v = json['__v'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    // json['_id'] = id;
    json['title'] = title;
    json['poster'] = poster;
    json['backdrop'] = backdrop;
    json['trailer'] = trailer;
    json['release_year'] = releaseYear;
    json['rating'] = rating;
    json['overview'] = overview;
    json['runtime'] = runtime;
    json['sources'] = sources?.map((e) => e.toJson()).toList();
    json['actors'] = actors?.map((e) => e.toJson()).toList();
    json['genres'] = genres?.map((e) => e.toJson()).toList();
    // json['createdAt'] = createdAt;
    // json['updatedAt'] = updatedAt;
    // json['__v'] = v;
    return json;
  }
}
