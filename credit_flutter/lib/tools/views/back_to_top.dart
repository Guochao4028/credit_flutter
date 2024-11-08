/// *
/// -  @Date: 2023-08-29 17:04
/// -  @LastEditTime: 2023-08-29 17:05
/// -  @Description: 回到顶部 视图布局
///

import 'package:flutter/material.dart';

class BackToTop extends StatefulWidget {
  final ScrollController controller;

  ///传入距离底部的距离
  final double bottom;

  ///传入距离顶部(0,0)距离，默认为0，
  final double offsetTop;

  ///如果传入顶部距离offsetTop isAuto 必须是true
  final bool isAuto;

  /// 间隔
  final double interval;

  const BackToTop(
    this.controller, {
    super.key,
    this.bottom = 0,
    this.offsetTop = 0,
    this.isAuto = false,
    this.interval = 0,
  });

  @override
  State createState() => _BackToTopState();
}

class _BackToTopState extends State<BackToTop> {
  bool shown = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(isScroll);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(isScroll);
  }

  void isScroll() {
    final bool toShow;

    if (widget.isAuto == false && widget.offsetTop == 0) {
      toShow = (widget.controller?.offset ?? 0) >
          MediaQuery.of(context).size.height / 2;
    } else {
      toShow = (widget.controller?.offset ?? 0) > widget.offsetTop;
    }

    if (toShow ^ shown) {
      setState(() {
        shown = toShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: MediaQuery.of(context).padding.bottom + (widget.bottom ?? 40),
        right: 20,
        child: Offstage(
          offstage: !shown,
          child: GestureDetector(
            onTap: () {
              if (widget.offsetTop != 0) {
                widget.controller.animateTo(widget.offsetTop - widget.interval,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn);
              } else {
                widget.controller.animateTo(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn);
              }
            },
            child: Container(
                height: 44,
                width: 44,
                alignment: const Alignment(0, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 0),
                    ]),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: const Icon(
                        Icons.vertical_align_top,
                        size: 20,
                        color: Colors.black38,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 0),
                      child: const Text(
                        'Top',
                        style:
                            TextStyle(fontSize: 10, color: Color(0xFFA1A6AA)),
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}
