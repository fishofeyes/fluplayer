import 'package:fluplayer/common/common_report/model/common_event_model.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/home/model/recommend_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

enum HiveBoxEnum { homeVideo, history, recommend, event }

class CommonHive {
  static Box<HomeVideoModel> homeVideoBox = Hive.box<HomeVideoModel>(
    HiveBoxEnum.homeVideo.name,
  );
  static Box<HomeVideoModel> historyBox = Hive.box<HomeVideoModel>(
    HiveBoxEnum.history.name,
  );
  static Box<RecommendModel> recommendBox = Hive.box<RecommendModel>(
    HiveBoxEnum.recommend.name,
  );

  static Box<CommonEventModel> commonEventBox = Hive.box<CommonEventModel>(
    HiveBoxEnum.event.name,
  );
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(HomeVideoModelAdapter());
    Hive.registerAdapter(RecommendModelAdapter());
    Hive.registerAdapter(CommonEventModelAdapter());
    await Hive.openBox<HomeVideoModel>(HiveBoxEnum.homeVideo.name);
    await Hive.openBox<HomeVideoModel>(HiveBoxEnum.history.name);
    await Hive.openBox<RecommendModel>(HiveBoxEnum.recommend.name);
    await Hive.openBox<CommonEventModel>(HiveBoxEnum.event.name);
  }
}
