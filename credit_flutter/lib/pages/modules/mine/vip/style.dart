/*
 * @Author: ws
 * @Date: 2021-05-18 10:10:24
 * @LastEditors: Please set LastEditors
 * @Description: App内使用的颜色、字体
 * @FilePath: /credit_flutter/lib/style.dart
 */

import 'dart:ui';

import 'package:flutter/material.dart';

/// 主要 Primary 次要 secondary 不重要 minor

class CreditStyle {
  static const String pingFangSC = 'PingFangSC';
  static const String din = 'DIN';

  static double screenW = window.physicalSize.width / window.devicePixelRatio;
  static double screenH = window.physicalSize.height / window.devicePixelRatio;

  //主要 蓝色
  static const Color pBlueColor = Color(0xFF0069FF);

  //不重要 171717黑色
  static const Color mBlackColor171717 = Color(0xFF171717);

  //不重要 02050d黑色
  static const Color mBlackColor02050D = Color(0xFF02050D);

  //不重要 131313黑色
  static const Color mBlackColor131313 = Color(0xFF131313);

  //不重要 B6B6B8灰色
  static const Color mGrayColorB6B6B8 = Color(0xFFB6B6B8);

  //不重要 F1F4F9灰色
  static const Color mGrayColorF1F4F9 = Color(0xFFF1F4F9);

  //#bebebe
  static const Color mGrayColorBEBEBE = Color(0xFFBEBEBE);

  //不重要 D7D9DF灰色
  static const Color mGrayColorD7D9DF = Color(0xFFD7D9DF);

  //不重要 F5F5F5灰色
  static const Color mGrayColorF5F5F5 = Color(0xFFF5F5F5);

  //不重要 F6F9FF浅蓝色
  static const Color mBlueColorF6F9FF = Color(0xFFF6F9FF);

  //#E5E5E5
  static const Color colorE5E5E5 = Color(0xFFE5E5E5);

  //#B6B6B8
  static const Color colorB6B6B8 = Color(0xFFB6B6B8);

  //#EB2424
  static const Color colorEB2424 = Color(0xFFEB2424);

  //#ffffff
  static const Color colorWhite = Color(0xFFFFFFFF);
}
