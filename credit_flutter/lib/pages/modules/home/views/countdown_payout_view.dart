/// *
/// -  @Date: 2023-10-24 16:26
/// -  @LastEditTime: 2023-10-24 16:26
/// -  @Description: 待支付倒计时
///

// ignore_for_file: must_be_immutable

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/order_manager.dart';
import 'package:credit_flutter/models/order_list_model.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/notification.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CountDownPayoutView extends StatefulWidget {
  OrderListModel? listModel;
  CountDownPayoutView({this.listModel, super.key});

  @override
  State<CountDownPayoutView> createState() => _CountDownPayoutViewState();
}

class _CountDownPayoutViewState extends State<CountDownPayoutView> {
  Timer? _timer;
  bool ishide = false;
  int _timsTs = 0;
  OrderListModel? listModel;
  int total = 1;

  @override
  void initState() {
    getData();
    NotificationCener.instance.addNotification(FinalKeys.NOTIFICATION_COUNTDOWN,
        ({object}) {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// 剩余时间
    String remainingTime = _constructTime(_timsTs);
    return Offstage(
      offstage: ishide,
      child: Column(
        children: [
          Text(
            remainingTime,
            style: const TextStyle(
              color: CustomColors.bgRedColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Container(
            height: 50,
            width: 95,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              image: DecorationImage(
                image: AssetImage("assets/images/guodu4.png"),
                fit: BoxFit.fitHeight, // 完全填充
              ),
            ),
            child: Text(
              "您有$total份订单待支付",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void getData() {
    _cancelTimer();
    _timsTs = 0;
    if (Golbal.token.isEmpty && Golbal.golbalToken.isEmpty) {
      ishide = true;
      return;
    }
    // Golbal.loginType == "2 自查"
    // Golbal.loginType == "3 查别人"
    Map<String, dynamic> map = {"minute": 60, "orderStatus": 1};
    if (Golbal.loginType.isNotEmpty && Golbal.token.isNotEmpty) {
      if (Golbal.loginType == "2") {
        map["orderType"] = 8;
      } else {
        map["orderType"] = 12;
      }
    }

    OrderManager.orderPersonList(map, (object) {
      setState(() {
        listModel = object as OrderListModel;
        var detailsList = listModel?.detailsList ?? [];
        total = listModel?.total ?? 1;

        /// 1. 没有订单 页面隐藏
        /// 2. 订单时间超过60分钟，也隐藏
        if (detailsList.isEmpty) {
          ishide = true;
        } else {
          ishide = true;

          ///获取最新的订单
          var model = detailsList.last;
          var orderTime = model.createTimeTs;

          if (orderTime != null) {
            ///当前时间
            var _now = DateTime.now();

            var _diffDate = DateTime.fromMillisecondsSinceEpoch(orderTime * 1);

            /// 计算订单截止时间
            var _cutoffTime = _diffDate.add(const Duration(minutes: 60));

            var _existenceTime = _cutoffTime.difference(_now).inSeconds;

            if (_existenceTime > 0) {
              //获取总秒数，2 分钟为 120 秒
              _timsTs = _existenceTime;
              ishide = false;
              _startTimer();
            }
          }
        }
      });
    });
  }

  void _startTimer() {
    //设置 1 秒回调一次
    const period = Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      setState(() {
        //秒数减一，因为一秒回调一次
        _timsTs--;
      });
      if (_timsTs == 0) {
        //倒计时秒数为0，取消定时器
        _cancelTimer();
        setState(() {
          ishide = true;
        });
      }
    });
  }

  void _cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// *
  /// -  @description: 根据总秒数转换为对应的 mm:ss 格式
  /// -  @Date: 2023-10-25 15:15
  ///
  String _constructTime(int time) {
    int min = (time / 60 % 60).toInt();
    int sec = (time % 60).toInt();

    return "${formatTime(min)} : ${formatTime(sec)}";
  }

  /// *
  /// -  @description:数字格式化，将 0~9 的时间转换为 00~09
  /// -  @Date: 2023-10-25 15:14
  ///
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0$timeNum" : timeNum.toString();
  }
}
