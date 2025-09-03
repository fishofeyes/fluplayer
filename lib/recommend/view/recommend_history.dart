import 'package:extended_image/extended_image.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_report/common_report.dart';
import 'package:fluplayer/home/model/recommend_model.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/model/out_user_model.dart';
import 'package:fluplayer/out/out_user_page.dart';
import 'package:fluplayer/out/provider/out_user.dart';
import 'package:flutter/material.dart';

import '../../common/common_enum.dart';

class RecommendHistory extends StatelessWidget {
  final RecommendModel model;
  final double size;
  final bool isHome;
  const RecommendHistory({
    super.key,
    required this.model,
    this.size = 88,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonReport.myEvent(
          MySessionEvent.channellEw9istClick,
          data: {
            "caycJ": "echgctd",
            "OZI": isHome ? "ruZHz" : "LBfCnCNiI",
            "PzgyR": "pNZSbnOq",
          },
        );
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
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: Column(
          children: [
            ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(size / 2),
              child: ExtendedImage.network(
                model.cover ?? '',
                width: size,
                height: size,
                cacheWidth: size.toInt() * 2,
                cacheHeight: size.toInt() * 2,
                fit: BoxFit.cover,
                loadStateChanged: (state) {
                  if (state.extendedImageLoadState == LoadState.failed ||
                      state.extendedImageLoadState == LoadState.loading) {
                    return Image.asset(
                      "assets/home/photo.png",
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return ExtendedRawImage(
                      image: state.extendedImageInfo?.image,
                      fit: BoxFit.cover,
                      width: size,
                      height: size,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 4),
            Container(
              constraints: BoxConstraints(maxWidth: 88),
              child: Text(
                model.uname ?? "",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
