
// ignore_for_file: depend_on_referenced_packages

/// *
/// @Date: 2022-06-09 18:16
/// @LastEditTime: 2022-06-14 20:38
/// @Description: 屏幕适配
import 'package:credit_flutter/define/define_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///屏幕缩放插件
class ScreenTool {
  ///初始化
  static int(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: FinalKeys.DESIGN_SIZE,
    );
  }

  /// 获取 计算后的高度
  static height(double value) {
    return value.h;
  }

  /// 获取 计算后的宽度
  static width(double value) {
    return value.w;
  }

  /// 获取 计算后的屏幕高度
  static double get screenHeight {
    return 1.sh;
  }

  /// 获取 计算后的屏幕高度
  static double get screenWidth {
    return 1.sw;
  }

  ///顶部导航栏高度= 状态栏高度 + Appbar高度
  static double get navigationBarHeight {
    return ScreenUtil().statusBarHeight + kToolbarHeight;
  }

  static double get topSafeHeight {
    return ScreenUtil().statusBarHeight;
  }

  static double get bottomSafeHeight {
    return ScreenUtil().bottomBarHeight;
  }
}
