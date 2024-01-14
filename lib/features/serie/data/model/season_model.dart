class SeasonModel {
  String? id;
  String? title;
  String? serie;
  String? createdAt;
  String? updatedAt;

  SeasonModel({
    this.id,
    this.title,
    this.serie,
    this.createdAt,
    this.updatedAt,
  });

  SeasonModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    title = json['title'] as String?;
    serie = json['serie'] as String?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['_id'] = id;
    json['title'] = title;
    json['serie'] = serie;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    return json;
  }
}
