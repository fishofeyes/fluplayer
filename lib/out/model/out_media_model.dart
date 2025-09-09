import 'package:fluplayer/home/model/home.dart';

class OutMediaModel {
  final String id;
  final int createTime;
  final String? showTime;
  final int qty;
  final bool directory;
  final bool video;
  final String name;
  final String? cover;
  final int size;
  final String? userId;
  final bool isMiddle;
  final bool isRecommend;
  final String? outUrl;

  OutMediaModel({
    required this.id,
    required this.qty,
    required this.directory,
    required this.video,
    required this.isMiddle,
    required this.createTime,
    this.showTime,
    required this.name,
    required this.size,
    this.cover,
    this.userId,
    this.isRecommend = false,
    this.outUrl,
  });

  HomeVideoModel convertModel({bool recommend = false}) {
    return HomeVideoModel(
      name: name,
      size: size,
      createDate: createTime ?? 0,
      format: "",
      path: id,
      face: cover,
      position: 0,
      id: id,
      uidUrl: outUrl,
      isMiddle: isMiddle,
      uid: userId,
      recommend: recommend,
    );
  }

  factory OutMediaModel.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> meta,
    String userId,
    bool isMiddle, {
    bool isRecommend = false,
    String? outUrl,
  }) => OutMediaModel(
    id: json["thiazole"],
    createTime: json["hunyak"],
    qty: json["hollin"],
    directory: json["stright"],
    video: json["edlwpukdhp"],
    name: json['familia']["unintombed"],
    cover: meta["haps_gldei"],
    size: meta["photophily"],
    userId: userId,
    isMiddle: isMiddle,
    outUrl: outUrl,
    isRecommend: isRecommend,
  );

  // factory OutMediaModel.fromJson(
  //   Map<String, dynamic> json,
  //   Map<String, dynamic> meta,
  //   String userId,
  //   bool isMiddle, {
  //   bool isRecommend = false,
  // }) => OutMediaModel(
  //   id: json["id"],
  //   createTime: json["create_time"],
  //   qty: json["vid_qty"],
  //   directory: json["directory"],
  //   video: json["video"],
  //   name: json["display_name"],
  //   cover: meta["thumbnail"],
  //   size: meta["size"],
  //   userId: userId,
  //   isMiddle: isMiddle,
  //   isRecommend: isRecommend,
  // );

  factory OutMediaModel.fromDirJson(
    Map<String, dynamic> json,
    Map<String, dynamic> meta,
    String userId,

    bool isMiddle, {
    bool isRecommend = false,
    String? outUrl,
  }) => OutMediaModel(
    id: json["kz4g3xf5ci"],
    createTime: json["twinging"],
    qty: json["venenose"],
    directory: json["munches"],
    video: json["decarhinus"],
    name: json["gijvuv0x2c"]["jocosity"], // 未处理
    cover: meta["liparite"],
    size: meta["atkyl_7v_y"],
    userId: userId,
    isMiddle: isMiddle,
    isRecommend: isRecommend,
  );

  factory OutMediaModel.fromRecommend(
    Map<String, dynamic> json,
    Map<String, dynamic> meta,
    String userId,
    bool isMiddle, {
    bool isRecommend = false,
  }) => OutMediaModel(
    id: json["fryperq0qd"],
    createTime: json["sultanry"],
    qty: json["sitcoms"],
    directory: json["corticose"],
    video: json["miseats"],
    name: json["mutilators"]["nssi6g_kun"],
    cover: meta["chpgsdt02a"],
    size: meta["reunionism"],
    userId: userId,
    isMiddle: isMiddle,
    isRecommend: isRecommend,
  );
}
