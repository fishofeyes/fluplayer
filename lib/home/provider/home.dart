import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_hive.dart';
import 'package:fluplayer/common/view/have_permission.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/root/provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart';
part 'home.g.dart';

@Riverpod(keepAlive: true)
class Home extends _$Home {
  final ImagePicker _imagePicker = ImagePicker();
  @override
  HomeState build() {
    return HomeState();
  }

  void insertHistory(HomeVideoModel m) {
    final res = state.history;
    state = state.copyWith(history: [m, ...state.history]);
    CommonHive.homeVideoBox.put(m.id, m);
  }

  void rename(HomeVideoModel m, String? name) {
    if (name == null) return;
    HomeVideoModel? res = state.history.firstWhereOrNull(
      (e) => e.path == m.path,
    );
    HomeVideoModel? res2 = state.home.firstWhereOrNull((e) => e.path == m.path);
    if (res != null) {
      CommonHive.historyBox.put(m.id, m);
    }
    if (res2 != null) {
      res2 = res2.copyWith(name: name);
      CommonHive.homeVideoBox.put(m.id, m);
    }
  }

  void updatePosition(HomeVideoModel m, double position) {
    m = m.copyWith(position: position);
    final tempList = state.history;
    final idx1 = tempList.indexWhere((e) => e.path == m.path);
    state.history[idx1] = m;
    CommonHive.historyBox.put(m.id, m);
  }

  void deleteAll() {
    state = state.copyWith(history: []);
    CommonHive.historyBox.clear();
  }

  // 删除历史
  void deleteSingle(HomeVideoModel m) {
    final res = state.history;
    res.removeWhere((e) => e.path == m.path);
    CommonHive.historyBox.delete(m.id);
    state = state.copyWith(history: [...res]);
  }

  // 删除文件
  void deleteSingleVideo(HomeVideoModel m) {
    final res = state.history;
    final res2 = state.home;
    res.removeWhere((e) => e.path == m.path);
    res2.removeWhere((e) => e.path == m.path);
    CommonHive.historyBox.delete(m.id);
    CommonHive.homeVideoBox.delete(m.id);
    state = state.copyWith(history: [...res], home: [...res2]);
  }

  void import(BuildContext context, bool isVideo) async {
    await Permission.appTrackingTransparency.request();
    if (isVideo) {
      PermissionStatus status = await Permission.photos.status;
      status = await Permission.photos.request();
      if (status.isGranted) {
        final res = await _imagePicker.pickVideo(source: ImageSource.gallery);
        if (res != null) {
          await _copyVideoToAppDirectory(res);
          ref.read(tabIndexProvider.notifier).state = 0;
        }
      } else {
        commonShowBottomSheet(context, const HavePermission());
      }
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mov', 'm4v', 'avi', 'mkv'],
      );
      if (result != null) {
        for (final i in result.files) {
          await _copyVideoToAppDirectory(i.xFile);
        }
        ref.read(tabIndexProvider.notifier).state = 0;
      }
    }
  }

  // 将视频拷贝到应用的沙盒目录
  Future<void> _copyVideoToAppDirectory(XFile video) async {
    try {
      // 获取应用的文档目录
      final videoName = basename(video.path); // 获取视频文件名
      final videoFormat = extension(video.path);
      final newPath = video.path;

      // 生成视频封面图
      final Uint8List? bytes = await VideoThumbnail.thumbnailData(
        video: video.path,
        imageFormat: ImageFormat.JPEG, // 你可以选择其他格式
        maxWidth: 200, // 最大宽度，调整封面图的大小
        quality: 75, // 设置质量
      );

      String? face;
      if (bytes != null) {
        face = await _saveThumbnailToLocal(bytes);
      }
      final m = HomeVideoModel(
        name: videoName,
        size: await video.length(),
        createDate: DateTime.now().millisecondsSinceEpoch,
        format: videoFormat,
        path: newPath,
        face: face,
        position: 0,
        id: newPath,
      );
      state = state.copyWith(home: [m, ...state.home]);
      CommonHive.homeVideoBox.put(m.id, m);
    } catch (e) {
      print('Failed to copy video: $e');
    }
  }

  // 保存封面图到本地
  Future<String?> _saveThumbnailToLocal(Uint8List bytes) async {
    try {
      // 获取本地存储路径
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg'; // 设置文件名
      final filePath = join(directory.path, fileName); // 获取文件路径

      // 将字节数据写入文件
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      print('Thumbnail saved to: $filePath');
      return filePath;
    } catch (e) {
      print('Failed to save thumbnail: $e');
    }
    return null;
  }
}

class HomeState {
  final List<HomeVideoModel> home;
  final List<HomeVideoModel> history;

  HomeState({this.home = const [], this.history = const []});

  HomeState copyWith({
    List<HomeVideoModel>? home,
    List<HomeVideoModel>? history,
  }) {
    return HomeState(home: home ?? this.home, history: history ?? this.history);
  }
}
