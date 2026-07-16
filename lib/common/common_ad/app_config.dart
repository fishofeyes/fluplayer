// To parse this JSON data, do
//
//     final appConfigModel = appConfigModelFromJson(jsonString);

class AppConfigModel {
  final bool haveSim;
  final bool haveSimulator;
  final bool haveVip;
  final bool pad;

  AppConfigModel({
    this.haveSim = false,
    this.haveSimulator = false,
    this.haveVip = false,
    this.pad = false,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => AppConfigModel(
    haveSim: json["haveSim"],
    haveSimulator: json["haveSimulator"],
    haveVip: json["haveVip"],
    pad: json["pad"],
  );

  Map<String, dynamic> toJson() => {
    "haveSim": haveSim,
    "haveSimulator": haveSimulator,
    "haveVip": haveVip,
    "pad": pad,
  };
}
