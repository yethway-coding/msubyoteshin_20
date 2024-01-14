import '/common/models/genre_model.dart';

class GenreResponseModel {
  bool? status;
  String? message;
  List<GenreModel>? data;

  GenreResponseModel({
    this.status,
    this.message,
    this.data,
  });

  GenreResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = (json['data'] as List?)
        ?.map((dynamic e) => GenreModel.fromJson(e as Map<String, dynamic>))
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
