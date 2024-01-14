import '/common/models/source_model.dart';

class EpisodeResponseModel {
  bool? status;
  String? message;
  List<EpisodeModel>? data;

  EpisodeResponseModel({
    this.status,
    this.message,
    this.data,
  });

  EpisodeResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = (json['data'] as List?)
        ?.map((dynamic e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    json['message'] = message;
    json['data'] = data?.map((e) => e.toJson()).toList();
    return json;
  }
}

class EpisodeModel {
  String? id;
  String? title;
  String? serie;
  String? season;
  List<SourceModel>? sources;
  String? createdAt;
  String? updatedAt;
  int? v;

  EpisodeModel({
    this.id,
    this.title,
    this.serie,
    this.season,
    this.sources,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  EpisodeModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    title = json['title'] as String?;
    serie = json['serie'] as String?;
    season = json['season'] as String?;
    sources = (json['sources'] as List?)
        ?.map((dynamic e) => SourceModel.fromJson(e as Map<String, dynamic>))
        .toList();
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    v = json['__v'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['_id'] = id;
    json['title'] = title;
    json['serie'] = serie;
    json['season'] = season;
    json['sources'] = sources?.map((e) => e.toJson()).toList();
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    json['__v'] = v;
    return json;
  }
}
