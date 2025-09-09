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
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              // 点击图片退出全屏
              Navigator.pop(context);
            },
            child: ExtendedImage.network(
              widget.model.cover ?? "",
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
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
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
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.translucent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Image.asset(
                          "assets/player/back.png",
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 60,
                    right: 60,
                    child: Text(
                      widget.model.name * 100,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
