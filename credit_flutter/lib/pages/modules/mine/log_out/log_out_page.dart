import 'dart:math';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';

/// @Description: 注销页面
class LogOutPage extends StatefulWidget {
  const LogOutPage({Key? key}) : super(key: key);

  @override
  State<LogOutPage> createState() => _LogOutPageState();
}

class _LogOutPageState extends State<LogOutPage> {
  @override
  void initState() {
    //初始化主页面
    super.initState();
    UserModel.getInfo((model) {
      if (model != null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 26, right: 26),
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              "请谨慎操作",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Text(
                  "当前帐号：",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  color: CustomColors.lightBlue,
                  width: 3,
                  height: 18,
                ),
                const SizedBox(width: 5),
                const Text(
                  "注销后",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(2.5),
                      color: CustomColors.lightGrey),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    "账号永久失效,不可继续使用;",
                    style: TextStyle(
                      color: CustomColors.lightGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 5,
                  height: 5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(2.5),
                      color: CustomColors.lightGrey),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    "订单信息、交易记录、消息、个人资料都将被删除且无法找回;",
                    style: TextStyle(
                      color: CustomColors.lightGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 5,
                  height: 5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(2.5),
                      color: CustomColors.lightGrey),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    "已经认证的信息将自动失效;",
                    style: TextStyle(
                      color: CustomColors.lightGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Container(
                  color: CustomColors.lightBlue,
                  width: 3,
                  height: 18,
                ),
                const SizedBox(width: 5),
                const Text(
                  "存在以下情况不能注销账号",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 5,
                  height: 5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(2.5),
                      color: CustomColors.lightGrey),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    "存在未完成或待支付的订单;",
                    style: TextStyle(
                      color: CustomColors.lightGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 5,
                  height: 5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(2.5),
                      color: CustomColors.lightGrey),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    "存在未消费的慧眼币;",
                    style: TextStyle(
                      color: CustomColors.lightGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 5,
                  height: 5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(2.5),
                      color: CustomColors.lightGrey),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    "账号存在与其他产品的授权登录或绑定关系;",
                    style: TextStyle(
                      color: CustomColors.lightGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            WidgetTools().createMaterialButton(
              double.infinity,
              "我要注销",
              CustomColors.lightBlue,
              Colors.white,
              1,
              () => {},
            )
          ],
        ),
      ),
    );
  }
}
