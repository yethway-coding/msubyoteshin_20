import 'movie_model.dart';

class MovieResponseModel {
  bool? status;
  String? message;
  List<MovieModel>? data;

  MovieResponseModel({
    this.status,
    this.message,
    this.data,
  });

  MovieResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = (json['data'] as List?)
        ?.map((dynamic e) => MovieModel.fromJson(e as Map<String, dynamic>))
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
