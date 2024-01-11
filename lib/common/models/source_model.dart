class SourceModel {
  final String? resolution;
  final String? url;
  final String? urlType;
  final String? format;
  final String? id;

  SourceModel({
    this.resolution,
    this.url,
    this.urlType,
    this.format,
    this.id,
  });

  SourceModel.fromJson(Map<String, dynamic> json)
      : resolution = json['resolution'] as String?,
        url = json['url'] as String?,
        urlType = json['url_type'] as String?,
        format = json['format'] as String?,
        id = json['_id'] as String?;

  Map<String, dynamic> toJson() => {
        'resolution': resolution,
        'url': url,
        'url_type': urlType,
        'format': format,
        // '_id': id,
      };
}
