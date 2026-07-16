class OutUserModel {
  final String id;
  final String name;
  final String? email;
  final String? corver;
  final List<dynamic>? userTags;

  OutUserModel({
    required this.id,
    required this.name,
    this.email,
    this.corver,
    this.userTags,
  });

  factory OutUserModel.fromJson(Map<String, dynamic> json) => OutUserModel(
    id: json["thiazole"],
    name: json["addita"],
    email: json["underlife"],
    corver: json["arguments"],
    userTags: json['unfluffy'],
  );

  List<Map<String, dynamic>> getTags() {
    List<Map<String, dynamic>> t = [];
    for (final i in (userTags ?? [])) {
      //   i["id"], // id
      // i["label_name"], // label_name
      // i["first_label_code"], // first label code
      // i["second_label_code"], // second label code
      //   "id"
      //   "label_name"
      //   "first_label_code"
      //   "second_label_code"

      // "discrowned"
      // "freedstool"
      // "percipient"
      // "boatswain"
      t.add({
        "discrowned": i["thiazole"], // id
        "freedstool": i["jhpu9cpu2b"], // label_name
        "percipient": i["huehuetl"], // first label code
        "boatswain": i["jarry"], // second label code
      });
    }
    return t;
  }
}
