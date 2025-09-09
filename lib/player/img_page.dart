import 'package:extended_image/extended_image.dart';
import 'package:fluplayer/out/model/out_media_model.dart';
import 'package:flutter/material.dart';

class ImgPage extends StatefulWidget {
  final OutMediaModel model;
  const ImgPage({super.key, required this.model});

  @override
  State<ImgPage> createState() => _ImgPageState();
}

class _ImgPageState extends State<ImgPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          // 点击图片退出全屏
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: widget.model.id,
            child: ExtendedImage.network(
              widget.model.cover ?? "",
              fit: BoxFit.contain,
              mode: ExtendedImageMode.gesture, // 启用手势模式
              initGestureConfigHandler: (state) {
                // 配置手势参数
                return GestureConfig(
                  minScale: 0.8, // 最小缩放比例
                  animationMinScale: 0.8, // 缩放动画最小值
                  maxScale: 3.0, // 最大缩放比例
                  animationMaxScale: 3.0, // 缩放动画最大值
                  speed: 1.0, // 缩放速度
                  inertialSpeed: 100.0, // 惯性速度
                  initialScale: 1.0, // 初始缩放比例
                  inPageView: false, // 是否在 PageView 中
                  initialAlignment: InitialAlignment.center, // 初始对齐方式
                );
              },
              loadStateChanged: (state) {
                // 加载状态处理
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return const Center(child: CircularProgressIndicator());
                  case LoadState.completed:
                    return state.completedWidget;
                  case LoadState.failed:
                    return const Center(
                      child: Icon(Icons.error_outline, color: Colors.white),
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
