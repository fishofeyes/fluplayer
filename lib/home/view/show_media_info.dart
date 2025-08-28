import 'package:fluplayer/common/common_format.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:flutter/material.dart';

class ShowMediaInfoView extends StatelessWidget {
  final HomeVideoModel model;
  const ShowMediaInfoView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 27, start: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Info',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 26 / 24,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.translucent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Image.asset(
                          "assets/player/close.png",
                          width: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Text(
                  model.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 16 / 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(height: 1, color: Colors.white.withOpacity(0.08)),
              const SizedBox(height: 32),
              _Row(left: 'Size', right: model.size.format()),
              _Row(left: 'Format', right: model.format),
              _Row(left: 'Path', right: model.path),
              _Row(left: 'Modified', right: model.createDate.time()),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String left;
  final String right;
  const _Row({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              left,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xffBFBFBF),
                fontWeight: FontWeight.w400,
                height: 18 / 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 96),
            child: Text(
              right,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                height: 18 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
