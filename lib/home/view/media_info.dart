import 'dart:io';

import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/home/provider/home.dart';
import 'package:fluplayer/home/view/rename_view.dart';
import 'package:fluplayer/home/view/show_media_info.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';

class MediaInfo extends StatelessWidget {
  final HomeVideoModel model;
  const MediaInfo({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 296,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff3E2309), Color(0xff000000)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 28, left: 20),
                child: Row(
                  children: [
                    ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(2),
                      child: Image.file(
                        File(model.face ?? ''),
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        model.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.translucent,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Container(height: 1, color: Colors.white.withOpacity(0.08)),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Action(
                    name: "Rename",
                    img: 'rename',
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      final nam = await commonShowBottomSheet(
                        context,
                        const RenameView(),
                      );
                      commonRef?.read(homeProvider.notifier).rename(model, nam);
                    },
                  ),
                  _Action(
                    name: "Info",
                    img: 'info',
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      commonShowBottomSheet(
                        context,
                        ShowMediaInfoView(model: model),
                      );
                    },
                  ),
                  _Action(
                    name: "Delete",
                    img: 'video_delete',
                    onTap: () {
                      commonRef
                          ?.read(homeProvider.notifier)
                          .deleteSingleVideo(model);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  final String name;
  final String img;
  final Function()? onTap;

  const _Action({super.key, required this.name, required this.img, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
        Navigator.pop(context);
      },
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          Container(
            width: 87,
            height: 87,
            decoration: BoxDecoration(
              color: const Color(0xff453526).withValues(alpha: 0.46),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Image.asset("assets/home/$img.png", width: 32, height: 32),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
