import '/features/serie/data/model/serie_model.dart';

class SerieResponseModel {
  bool? status;
  String? message;
  List<SerieModel>? data;

  SerieResponseModel({
    this.status,
    this.message,
    this.data,
  });

  SerieResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = (json['data'] as List?)
        ?.map((dynamic e) => SerieModel.fromJson(e as Map<String, dynamic>))
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
