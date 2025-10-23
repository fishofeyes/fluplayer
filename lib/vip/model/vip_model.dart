class VipModel {
  final String id;
  final String name;
  final String desc;
  final int type; // 1: week, 2: year, 3: lifetime
  final bool tag;

  VipModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.type,
    this.tag = false,
  });

  factory VipModel.fromJson(Map<String, dynamic> json) {
    return VipModel(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      type: json["type"],
      tag: json['tag'],
    );
  }

  VipModel copyWith({String? desc}) {
    return VipModel(
      desc: desc ?? this.desc,
      id: id,
      name: name,
      type: type,
      tag: tag,
    );
  }
}
