import 'dart:ui';

import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/player/view/play_list_item.dart';
import 'package:flutter/material.dart';

class AlertPlayList extends StatelessWidget {
  final List<HomeVideoModel> list;
  const AlertPlayList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: screenPortraitUp == false
          ? BorderRadius.vertical(top: Radius.circular(24))
          : BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: size.height * 0.55,
          decoration: BoxDecoration(
            color: Color(0xff4ca1ff).withValues(alpha: 0.25),
          ),
          padding: EdgeInsets.only(top: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Playlist",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenPortraitUp == false ? 16 : 24),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, idx) {
                    return PlayListItem(data: list[idx]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
