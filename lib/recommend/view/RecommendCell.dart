import 'package:extended_image/extended_image.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/home/model/recommend_model.dart';
import 'package:fluplayer/out/model/out_user_model.dart';
import 'package:fluplayer/out/out_user_page.dart';
import 'package:flutter/material.dart';

import '../../out/model/out_model.dart';

class ReCommendCell extends StatelessWidget {
  final RecommendModel model;
  final int idx;
  const ReCommendCell({super.key, required this.model, required this.idx});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        commonPush(
          context,
          OutUserPage(
            user: OutUserModel(
              id: model.uid!,
              name: model.uname,
              corver: model.cover,
            ),
            model: OutModel(
              outUrl: "",
              userId: model.uid!,
              isMiddle: model.isMiddle,
            ),
          ),
        );
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsetsDirectional.only(top: idx == 0 ? 0 : 12, bottom: 12),
        child: Row(
          children: [
            ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(54 / 2),
              child: ExtendedImage.network(
                model.cover ?? '',
                width: 54,
                height: 54,
                cacheHeight: 54 * 2,
                cacheWidth: 54 * 2,
                fit: BoxFit.cover,
                loadStateChanged: (state) {
                  if (state.extendedImageLoadState == LoadState.failed ||
                      state.extendedImageLoadState == LoadState.loading) {
                    return Image.asset("assets/user.png");
                  } else {
                    return ExtendedRawImage(
                      image: state.extendedImageInfo?.image,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              model.uname ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
