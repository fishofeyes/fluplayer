import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:flutter/material.dart';

class CommonCover extends StatelessWidget {
  final HomeVideoModel data;
  final double width;
  final double height;
  const CommonCover({
    super.key,
    required this.data,
    this.width = 128,
    this.height = 72,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: ExtendedImage.file(
        File(data.face ?? ""),
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
            case LoadState.failed:
              return Container(
                width: 128,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xffFCF1F1),
                ),
                child: ExtendedImage.asset(
                  "assets/file/video.png",
                  width: 60,
                  height: 60,
                ),
              );
            case LoadState.completed:
              return ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: 128,
                height: 72,
                fit: BoxFit.cover,
              );
          }
        },
      ),
    );
  }
}
