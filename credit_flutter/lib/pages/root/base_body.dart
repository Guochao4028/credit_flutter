/// *
/// -  @Date: 2022-07-12 13:42
/// -  @LastEditTime: 2022-07-12 13:43
/// -  @Description:
///
/// *
/// -  @Date: 2022-07-12 13:42
/// -  @LastEditTime: 2022-07-12 13:42
/// -  @Description: 主要处理全局回收键盘
///
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseBody extends StatelessWidget {
  final Widget child;

  const BaseBody({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: child,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }
        });
  }
}
