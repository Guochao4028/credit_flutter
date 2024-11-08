/// *
/// -  @Date: 2022-07-08 15:56
/// -  @LastEditTime: 2022-07-08 15:58
/// -  @Description:
///
/// *
/// -  @Date: 2022-07-08 15:56
/// -  @LastEditTime: 2022-07-08 15:56
/// -  @Description: 注销账号
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/mine_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/login_tool.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../define/define_enums.dart';
import '../../login/login_page.dart';
import '../../login/login_type_page.dart';

class CancellationAccountPage extends StatefulWidget {
  const CancellationAccountPage({Key? key}) : super(key: key);

  @override
  State<CancellationAccountPage> createState() =>
      _CancellationAccountPageState();
}

class _CancellationAccountPageState extends State<CancellationAccountPage>
    implements ClickListener {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.lightBlue,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "注销账号",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _getIconView(),
              _mattersView(),
              const SizedBox(
                height: 17,
              ),
              WidgetTools().createCustomButton(
                ScreenTool.screenWidth - 32,
                "我要注销",
                () {
                  _showDialog();
                },
                bgColor: CustomColors.lightBlue,
                textColor: CustomColors.whiteColor,
                radius: 5,
              ),
              // _getListView(),
            ],
          ),
        ),
      ),
    );
  }

  /// *
  /// -  @description: icon view
  /// -  @Date: 2022-07-08 16:07
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _getIconView() {
    SizedBox iconImage = SizedBox(
      width: 180,
      height: 110,
      child: SvgPicture.asset(
        "assets/images/svg/cancellationIcon.svg",
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 78),
      child: Center(
        child: Column(
          children: [
            iconImage,
            const SizedBox(
              height: 74,
            ),
          ],
        ),
      ),
    );
  }

  /// *
  /// -  @description: 注意事项
  /// -  @Date: 2022-07-08 16:24
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _mattersView() {
    return Container(
      height: 156,
      decoration: const BoxDecoration(
        color: CustomColors.lightGreyF8,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.only(left: 12, right: 8, top: 21),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 2,
                height: 11,
                color: CustomColors.lightBlue,
              ),
              const SizedBox(
                width: 3,
              ),
              const Text(
                "注意事项",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.darkGrey3C,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "1.账号一旦注销，账号将永久失效，不可继续使用。",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.darkGrey,
                  ),
                ),
                Text(
                  "2.订单信息、交易记录、消息、个人资料、查询记录、报告、等信息都被删除且无法找回。",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.darkGrey,
                  ),
                ),
                Text(
                  "3.已经认证的信息将自动失效。",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.darkGrey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            title: "提示",
            confirm: "确认注销",
            cancel: "取消",
            content: "确认注销，慧眼查将在7天内处理您的申请并删除账号信息，再次登录将会创建一个新的账号",
            contentEdgeInsets: const EdgeInsets.only(left: 35, right: 35),
            contentStyle:
                const TextStyle(fontSize: 15, color: CustomColors.darkGrey),
            contentAlign: TextAlign.center,
            showCancel: true,
            clickListener: this,
          );
        });
  }

  // void _loginOut() {
  //   ///清空用户数据
  //   UserModel.removeUserInfo();
  //   // 获得实例
  //   Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  //   // 取出数据
  //   prefs.then((sp) {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => const LoginTypePage(),
  //     ));
  //   });
  // }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> confirmMap) {
    MineManager.userLogout((message) {
      LoginTools.loginOut(context);
    });
  }
}
