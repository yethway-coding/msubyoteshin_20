import 'movie_model.dart';

class MovieDetailResponseModel {
  bool? status;
  String? message;
  MovieModel? data;

  MovieDetailResponseModel({
    this.status,
    this.message,
    this.data,
  });

  MovieDetailResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] == null ? null : MovieModel.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    json['message'] = message;
    json['data'] = data?.toJson();
    return json;
  }
}
