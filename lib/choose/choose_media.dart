import 'package:fluplayer/choose/view/choose_action.dart';
import 'package:fluplayer/home/provider/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseMediaPage extends ConsumerWidget {
  const ChooseMediaPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/home/bg.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72),
                const Text(
                  "Import",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Import from system file",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    ChooseAction(
                      title: "File",
                      img: "file",
                      onTap: () => ref
                          .read(homeProvider.notifier)
                          .import(context, false),
                    ),
                    const SizedBox(width: 23),
                    ChooseAction(
                      title: "video",
                      img: "video",
                      onTap: () =>
                          ref.read(homeProvider.notifier).import(context, true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
