import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class OutUserCover extends StatelessWidget {
  final String? url;
  const OutUserCover({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset("assets/user.png", width: 52, height: 52),
        ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(25),
          child: ExtendedImage.network(
            url ?? '',
            width: 50,
            height: 50,
            cacheHeight: 100,
            cacheWidth: 100,
            fit: BoxFit.cover,
            loadStateChanged: (state) {
              if (state.extendedImageLoadState == LoadState.failed ||
                  state.extendedImageLoadState == LoadState.loading) {
                return const SizedBox();
              } else {
                return ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  fit: BoxFit.cover,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
