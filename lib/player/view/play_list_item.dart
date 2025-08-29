import 'package:fluplayer/common/common_format.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/player/provider/play.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/view/common_cover.dart';

class PlayListItem extends ConsumerWidget {
  final HomeVideoModel data;
  const PlayListItem({super.key, required this.data});

  @override
  Widget build(BuildContext context, ref) {
    final id = ref.watch(playProvider).id;
    return InkWell(
      onTap: () => ref.read(playProvider.notifier).tapModel(data),
      child: Container(
        decoration: BoxDecoration(
          color: id == data.id ? Colors.white12 : Colors.transparent,
        ),
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 14),
        constraints: BoxConstraints(minHeight: 78),
        margin: EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  CommonCover(data: data, height: 62, width: 110),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Visibility(
                      visible: id == data.id,
                      child: Image.asset(
                        "assets/player/playing.png",
                        width: 10,
                        height: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 20 / 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${data.size.format()} · ${data.createDate.time()}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.5),
                      height: 14 / 12,
                    ),
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
