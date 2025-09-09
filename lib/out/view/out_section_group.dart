import 'package:fluplayer/common/view/background_title.dart';
import 'package:flutter/material.dart';

class OutSectionGroup extends StatelessWidget {
  final int index;
  final Function(int)? onTap;
  const OutSectionGroup({super.key, required this.index, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xff282018),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          _Item(
            title: "Share",
            selected: index == 0,
            onTap: () => onTap?.call(0),
          ),
          _Item(
            title: "Hot",
            selected: index == 1,
            onTap: () => onTap?.call(1),
          ),
          _Item(
            title: "Recently",
            selected: index == 2,
            onTap: () => onTap?.call(2),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final bool selected;
  final Function()? onTap;
  const _Item({
    super.key,
    required this.title,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          child: selected
              ? BackgroundTitleView(title: title)
              : Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.white54),
                ),
        ),
      ),
    );
  }
}
