import 'package:flutter/material.dart';

class RenameView extends StatefulWidget {
  const RenameView({super.key});

  @override
  State<RenameView> createState() => _RenameViewState();
}

class _RenameViewState extends State<RenameView> {
  final _controller = TextEditingController();
  int length = 0;

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        length = _controller.text.length;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsetsDirectional.only(bottom: bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff3E2309), Color(0xff000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsetsDirectional.only(top: 24, start: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rename",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(12),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          fillColor: const Color(0xff13150D),
                          filled: true,
                          enabledBorder: InputBorder.none,
                          hintText: "Please enter media name",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        onChanged: (e) {
                          if (_controller.text.length >= 100) {
                            _controller.text = _controller.text.substring(
                              0,
                              100,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        "$length/100",
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white.withOpacity(0.75),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0, bottom: 26),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffFFD4AB).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 23),
                        Expanded(
                          child: Opacity(
                            opacity: length == 0 ? 0.5 : 1,
                            child: InkWell(
                              onTap: () async {
                                if (length == 0) return;
                                Navigator.pop(context, _controller.text);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                fit: StackFit.loose,
                                children: [
                                  Image.asset(
                                    "assets/home/bg1.png",
                                    height: 48,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  ),
                                  Text(
                                    "Confirm",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
