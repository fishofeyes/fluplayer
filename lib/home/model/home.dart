import 'package:fluplayer/common/common_aes.dart';
import 'package:fluplayer/common/request/http_helper.dart';
import 'package:hive/hive.dart';
part 'home.g.dart';

@HiveType(typeId: 1)
class HomeVideoModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int size;
  @HiveField(2)
  final int createDate;
  @HiveField(3)
  final String format;
  @HiveField(4)
  final String path;
  @HiveField(5)
  final String? face;
  @HiveField(6)
  final String id;
  @HiveField(7)
  final double position;
  @HiveField(8)
  final String? uid;
  @HiveField(9)
  final String? uidUrl;
  @HiveField(10)
  final bool? isMiddle;
  final bool? recommend;

  HomeVideoModel({
    required this.name,
    required this.size,
    required this.createDate,
    required this.format,
    required this.path,
    required this.face,
    required this.position,
    required this.id,
    this.uid,
    this.uidUrl,
    this.isMiddle,
    this.recommend,
  });

  HomeVideoModel copyWith({
    String? name,
    int? size,
    String? format,
    String? path,
    String? face,
    String? id,
    double? position,
  }) {
    return HomeVideoModel(
      name: name ?? this.name,
      size: size ?? this.size,
      position: position ?? this.position,
      createDate: DateTime.now().millisecondsSinceEpoch,
      format: format ?? this.format,
      path: path ?? this.path,
      face: face ?? this.face,
      id: id ?? this.id,
      isMiddle: isMiddle,
      uid: uid,
      uidUrl: uidUrl,
      recommend: recommend,
    );
  }

  Future<String> getRealLink() async {
    final sender = await HttpHelper.request(
      HttpHelperApi.getUrl,
      query: "/$uid/$id?quality=ORIGINAL",
      post: false,
      isMiddle: isMiddle!,
    );
    return CommonAes.getUrl(sender);
  }
}
