import 'package:fluplayer/common/common_format.dart';
import 'package:fluplayer/out/model/out_media_model.dart';
import 'package:fluplayer/out/view/out_cover.dart';
import 'package:flutter/material.dart';

class OutItem extends StatelessWidget {
  final Function()? onTap;
  final EdgeInsets padding;
  final Color? bgColor;
  final OutMediaModel model;
  final bool isFromWeb;
  const OutItem({
    super.key,
    this.onTap,
    required this.padding,
    this.bgColor,
    this.isFromWeb = false,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    String str =
        "${model.createTime.time("HH:mm:ss")} · ${model.size.format(1)} · ${model.createTime.time("yyyy/MM/dd")}";
    if (model.directory) {
      str = "${model.vidQty} videos";
    }
    if (isFromWeb) {
      str = model.showTime ?? "";
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 62 + 26,
        color: bgColor ?? const Color(0xff2440FE).withOpacity(0.12),
        alignment: Alignment.center,
        padding: padding,
        child: Row(
          children: [
            OutCover(model: model),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          str,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Visibility(
                      //   visible: !isFromWeb,
                      //   child: GestureDetector(
                      //     onTap: onReport,
                      //     behavior: HitTestBehavior.translucent,
                      //     child: Image.asset(
                      //       "assets/more2.webp",
                      //       width: 24,
                      //       height: 24,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
