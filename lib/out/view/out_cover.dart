import 'package:extended_image/extended_image.dart';
import 'package:fluplayer/out/model/out_media_model.dart';
import 'package:flutter/material.dart';

class OutCover extends StatelessWidget {
  final OutMediaModel model;
  const OutCover({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final isVideo = model.video;
    final isDir = model.directory;
    if (isDir) {
      return Image.asset("assets/p_dir.png", width: 110, height: 62);
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            width: 110,
            height: 62,
            child: ExtendedImage.network(
              model.cover ?? "",
              fit: BoxFit.cover,
              cacheWidth: 110 * 2,
              cacheHeight: 110 * 2,
              loadStateChanged: (state) {
                final str = isDir
                    ? 'p_dir.png'
                    : isVideo
                    ? 'p_video.png'
                    : 'p_pic.png';
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return Image.asset("assets/$str", width: 110, height: 62);
                  case LoadState.completed:
                    return ExtendedRawImage(
                      image: state.extendedImageInfo?.image,
                      fit: BoxFit.cover,
                    );
                  default:
                    return Image.asset("assets/$str", width: 110, height: 62);
                }
              },
            ),
          ),
        ),
        Visibility(
          visible: isVideo,
          child: Image.asset("assets/play.webp", width: 28, height: 28),
        ),
      ],
    );
  }
}
