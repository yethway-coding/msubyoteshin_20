class ActorModel {
  final String? id;
  final String? cover;
  final String? actorId;
  final String? name;
  final String? createdAt;
  final String? updatedAt;

  ActorModel({
    this.id,
    this.cover,
    this.actorId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  ActorModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        cover = json['cover'] as String?,
        actorId = json['actor_id'] as String?,
        name = json['name'] as String?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
        //'_id': id,
        'cover': cover,
        'actor_id': actorId,
        'name': name,
        //'createdAt': createdAt,
        //'updatedAt': updatedAt
      };
}
