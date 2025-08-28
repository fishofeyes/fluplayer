import 'dart:io';
import 'dart:ui';

import 'package:fluplayer/home/model/home.dart';
import 'package:flutter/material.dart';

class HomeHistoryItem extends StatelessWidget {
  final HomeVideoModel model;
  final Function(HomeVideoModel)? onTap;
  const HomeHistoryItem({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(model),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: FileImage(File(model.face ?? '')),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Positioned(
            //   top: 8,
            //   right: 8,
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            //     decoration: BoxDecoration(
            //       color: Colors.black54,
            //       borderRadius: BorderRadius.circular(4),
            //     ),
            //     child: Text(
            //       '02:48',
            //       style: TextStyle(color: Colors.white, fontSize: 9),
            //     ),
            //   ),
            // ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      model.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 14 / 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
