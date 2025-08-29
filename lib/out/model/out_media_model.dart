import 'package:fluplayer/home/model/home.dart';

class OutMediaModel {
  final String id;
  final int createTime;
  final String? showTime;
  final int vidQty;
  final bool directory;
  final bool video;
  final String name;
  final String? cover;
  final int size;
  final String? userId;
  final bool isMiddle;
  final bool isRecommend;

  OutMediaModel({
    required this.id,
    required this.vidQty,
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
  });

  HomeVideoModel convertModel({String? link}) {
    return HomeVideoModel(
      name: name,
      size: size,
      createDate: createTime ?? 0,
      format: "",
      path: id,
      face: cover,
      position: 0,
      id: id,
      // webLink: link,
      // webFrom: from,
      // userId: userId,
      // isDir: directory,
    );
  }

  factory OutMediaModel.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> meta,
    String userId,
    bool isMiddle, {
    bool isRecommend = false,
  }) => OutMediaModel(
    id: json["id"],
    createTime: json["create_time"],
    vidQty: json["vid_qty"],
    directory: json["directory"],
    video: json["video"],
    name: meta["display_name"],
    cover: meta["thumbnail"],
    size: meta["size"],
    userId: userId,
    isMiddle: isMiddle,
    isRecommend: isRecommend,
  );

  factory OutMediaModel.fromDirJson(
    Map<String, dynamic> json,
    Map<String, dynamic> meta,
    String userId,
    bool isMiddle, {
    bool isRecommend = false,
  }) => OutMediaModel(
    id: json["id"],
    createTime: json["create_time"],
    vidQty: json["vid_qty"],
    directory: json["directory"],
    video: json["video"],
    name: meta["display_name"],
    cover: meta["thumbnail"],
    size: meta["size"],
    userId: userId,
    isMiddle: isMiddle,
    isRecommend: isRecommend,
  );
}
