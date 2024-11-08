/// *
/// -  @Date: 2023-09-05 14:27
/// -  @LastEditTime: 2023-09-05 14:30
/// -  @Description: 综合页面 公司 数据面板
///

import 'dart:math';

import 'package:animated_digit/animated_digit.dart';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IndexSynthesisCompanyDiskView extends StatefulWidget {
  const IndexSynthesisCompanyDiskView({super.key});

  @override
  State<IndexSynthesisCompanyDiskView> createState() =>
      _IndexSynthesisCompanyDiskViewState();
}

class _IndexSynthesisCompanyDiskViewState
    extends State<IndexSynthesisCompanyDiskView>
    with SingleTickerProviderStateMixin {
  /// 动画Controller
  late AnimatedDigitController _controller;

  static int time = 0;
  static int snumber = 0;

  double number = 0;

  @override
  void initState() {
    var box = Hive.box(HiveBoxs.dataBox);
    number = box.get(FinalKeys.BOX_RANDOM_NUMBER) ?? 1943552;
    _controller = AnimatedDigitController(number);
    super.initState();
    _random();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: const BoxDecoration(
        color: CustomColors.whiteBlueColorFE,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: [
          Expanded(
            child: Column(
              children: [
                AnimatedDigitWidget(
                  value: _controller.value,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  fractionDigits: 0,
                  enableSeparator: true,
                ),
                _titleView("已完成背调", 12),
              ],
            ),
          ),
          Container(
            width: 2,
            height: 40,
            color: CustomColors.colorF07F,
          ),
          _itemView(
            "1000+",
            "合作企业",
          ),
        ],
      ),
    );
  }

  Widget _itemView(String num, String titleStr) {
    return Expanded(
      child: Column(
        children: [
          _titleView(num, 16),
          _titleView(titleStr, 12),
        ],
      ),
    );
  }

  Widget _titleView(String titleStr, double fontSize) {
    return Text(
      titleStr,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _random() {
    Future.delayed(Duration(seconds: time), () {
      snumber = Random().nextInt(5) + 1;
      time = Random().nextInt(4) + 1;
      number += snumber;
      var box = Hive.box(HiveBoxs.dataBox);
      box.put(FinalKeys.BOX_RANDOM_NUMBER, number);
      _controller.resetValue(number);
      setState(() {});
      _random();
    });
  }
}
