import '/common/models/actor_model.dart';
import '/common/models/genre_model.dart';
import '/features/serie/data/model/season_model.dart';

class SerieModel {
  String? id;
  String? title;
  String? poster;
  String? backdrop;
  String? trailer;
  String? releaseYear;
  String? rating;
  String? overview;
  List<ActorModel>? actors;
  List<GenreModel>? genres;
  List<SeasonModel>? seasons;
  String? createdAt;
  String? updatedAt;
  int? v;

  SerieModel({
    this.id,
    this.title,
    this.poster,
    this.backdrop,
    this.trailer,
    this.releaseYear,
    this.rating,
    this.overview,
    this.actors,
    this.genres,
    this.seasons,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  SerieModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    title = json['title'] as String?;
    poster = json['poster'] as String?;
    backdrop = json['backdrop'] as String?;
    trailer = json['trailer'] as String?;
    releaseYear = json['release_year'] as String?;
    rating = json['rating'] as String?;
    overview = json['overview'] as String?;
    actors = (json['actors'] as List?)
        ?.map((dynamic e) => ActorModel.fromJson(e as Map<String, dynamic>))
        .toList();
    genres = (json['genres'] as List?)
        ?.map((dynamic e) => GenreModel.fromJson(e as Map<String, dynamic>))
        .toList();
    seasons = (json['seasons'] as List?)
        ?.map((dynamic e) => SeasonModel.fromJson(e as Map<String, dynamic>))
        .toList();
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    v = json['__v'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['_id'] = id;
    json['title'] = title;
    json['poster'] = poster;
    json['backdrop'] = backdrop;
    json['trailer'] = trailer;
    json['release_year'] = releaseYear;
    json['rating'] = rating;
    json['overview'] = overview;
    json['actors'] = actors?.map((e) => e.toJson()).toList();
    json['genres'] = genres?.map((e) => e.toJson()).toList();
    json['seasons'] = seasons?.map((e) => e.toJson()).toList();
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    json['__v'] = v;
    return json;
  }
}
