import 'package:extended_image/extended_image.dart';
import 'package:fluplayer/out/model/out_user_model.dart';
import 'package:flutter/material.dart';

class OutHeader extends StatelessWidget {
  final OutUserModel? model;
  final Function()? onTap;
  const OutHeader({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            GestureDetector(
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
          ],
        ),
        Container(
          constraints: BoxConstraints(maxWidth: size.width * 0.5),
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.translucent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: ExtendedImage.network(
                        model?.corver ?? '',
                        fit: BoxFit.cover,
                        cacheHeight: 48,
                        cacheWidth: 48,
                        loadStateChanged: (state) {
                          if (state.extendedImageLoadState ==
                              LoadState.completed) {
                            return Image(
                              image: state.imageProvider,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Container(
                              color: Colors.black,
                              child: Image.asset(
                                "assets/user.png",
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    model?.name ?? "-",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        // Positioned(
        //   child: const VipEnterItem(from: VipEnterValue.ldpage),
        //   right: 12,
        // )
      ],
    );
  }
}
