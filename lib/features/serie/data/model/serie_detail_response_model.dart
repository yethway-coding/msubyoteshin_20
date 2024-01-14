import 'serie_model.dart';

class SerieDetailResponseModel {
  bool? status;
  String? message;
  SerieModel? data;

  SerieDetailResponseModel({
    this.status,
    this.message,
    this.data,
  });

  SerieDetailResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = (json['data'] as Map<String, dynamic>?) != null
        ? SerieModel.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    json['message'] = message;
    json['data'] = data?.toJson();
    return json;
  }
}
