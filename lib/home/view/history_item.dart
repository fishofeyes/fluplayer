import 'dart:io';

import 'package:fluplayer/common/common_format.dart';
import 'package:fluplayer/common/view/common_gradient_bar.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HistoryItem extends StatelessWidget {
  final HomeVideoModel model;
  final Function(HomeVideoModel)? onDelete;
  final Function(HomeVideoModel)? onTap;
  const HistoryItem({
    super.key,
    required this.model,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          CustomSlidableAction(
            onPressed: (c) {
              onDelete?.call(model);
            },
            flex: 1,
            backgroundColor: Colors.red,
            child: Image.asset("assets/delete.webp", width: 24, height: 24),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => onTap?.call(model),
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: Stack(
                  children: [
                    ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        File(model.face ?? ''),
                        width: 128,
                        height: 72,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.black,
                          width: 128,
                          height: 72,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      height: 2,
                      left: 4,
                      right: 4,
                      bottom: 4,
                      child: CommonGradientBar(
                        progress: model.position.clamp(0.0, 1.0),
                        bgColor: Colors.white.withOpacity(0.5),
                        gradientColors: const [
                          Color(0xff2CE1F9),
                          Color(0xff2335FF),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${model.createDate.time("HH:mm:ss")} • ${model.size.format(1)} • ${model.createDate.time()}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
