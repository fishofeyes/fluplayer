import 'dart:io';

import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_format.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/home/view/media_info.dart';
import 'package:flutter/material.dart';

class HomeVideoView extends StatelessWidget {
  final HomeVideoModel model;
  final Function(HomeVideoModel)? onTap;
  const HomeVideoView({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(model),
      child: Container(
        height: 208,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xff2440FE).withOpacity(0.15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(
                    File(model.face ?? ""),
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.black,
                      height: 126,
                      width: double.infinity,
                    ),
                    height: 126,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Image.asset("assets/play.webp", width: 28, height: 28),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      model.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${model.size.format(1)} • ${model.createDate.time()}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          commonShowBottomSheet(
                            context,
                            MediaInfo(model: model),
                          );
                        },
                        child: Image.asset(
                          "assets/more2.webp",
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
