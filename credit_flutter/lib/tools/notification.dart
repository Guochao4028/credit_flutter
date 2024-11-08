/// *
/// -  @Date: 2022-07-29 16:31
/// -  @LastEditTime: 2022-07-29 16:32
/// -  @Description: 自定义通知
///

import 'package:flutter/material.dart';

class MSCustomNotification extends Notification {
  MSCustomNotification(this.msg);
  final String msg;
}

class CustomChangeNotifier extends ChangeNotifier {
  Map<String, dynamic> _info = {}; //数值计算
  Map get message => _info;
  sendMessage(Map<String, dynamic> message) {
    _info = message;
    notifyListeners();
  }
}

typedef NotificationUsingBlock = Function({dynamic object});

class NotificationCener {
  // factory NotificationCener() => _getInstance();
  // static NotificationCener get instance => _getInstance();

  // static NotificationCener _instance = NotificationCener._instance();

  NotificationCener._getInstance();
  static final NotificationCener _instance = NotificationCener._getInstance();
  static NotificationCener get instance {
    return _instance;
  }

  final Map<String, List<NotificationUsingBlock>> _notificationBlock =
      <String, List<NotificationUsingBlock>>{};

  /// *
  /// -  @description:添加通知
  /// -  @Date: 2023-10-25 14:18
  /// -  @parm: name 通知名称， usingBlock回调
  /// -  @return {*}
  ///
  addNotification(String name, NotificationUsingBlock usingBlock) {
    final List<NotificationUsingBlock> list = [];
    if (_notificationBlock.containsKey(name)) {
      list.addAll(_notificationBlock[name]!);
    }
    list.add(usingBlock);
    _notificationBlock[name] = list;
  }

  /// *
  /// -  @description:发送通知
  /// -  @Date: 2023-10-25 14:20
  /// -  @parm:  name 通知名称,object 传值
  /// -  @return {*}
  ///
  postNotification(String name, {dynamic object}) {
    if (_notificationBlock.containsKey(name)) {
      for (var block in _notificationBlock[name]!) {
        block(object: object);
      }
    }
  }

  /// *
  /// -  @description:删除指定通知
  /// -  @Date: 2023-10-25 14:22
  /// -  @parm:name 通知名称
  /// -  @return {*}
  ///
  removeNotification(String name) {
    if (_notificationBlock.containsKey(name)) {
      var list = _notificationBlock[name];

      if (list!.length == 1) {
        _notificationBlock.remove(name);
      } else {
        list.removeLast();

        _notificationBlock[name] = list;
      }
    }
  }
}
