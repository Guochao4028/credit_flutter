/// *
/// -  @Date: 2022-10-08 14:23
/// -  @LastEditTime: 2022-10-08 14:23
/// -  @Description: 子账号权限信息页面
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/select_replace_company_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/mine/my_company/select_replace_company_page.dart';
import 'package:credit_flutter/pages/root/root_page.dart';
import 'package:credit_flutter/tools/login_tool.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../define/define_enums.dart';
import 'login_page.dart';
import 'login_type_page.dart';

class ChildAccountInfoPage extends StatefulWidget {
  final Map arguments;

  ///子账号状态 0.禁用 1.启用 2.过期 3.删除
  // int childStatus = 1;
  ChildAccountInfoPage({required this.arguments, super.key});

  @override
  State<ChildAccountInfoPage> createState() => _ChildAccountInfoPageState();
}

class _ChildAccountInfoPageState extends State<ChildAccountInfoPage>
    implements ClickListener {
  int _childStatus = 0;

  ///  会员到期 文字说明
  final String _expireStr = "尊敬的用户您好，主帐号会员到期此账号不能使用请通知主帐号续费或切换公司，感谢配合";

  ///  被删除 文字说明
  final String _delStr = "尊敬的用户您好，主帐号已将此账号删除请切换公司或退出该公司，感谢配合";

  ///  禁用 文字说明
  final String _disableStr = "尊敬的用户您好，此账号已被禁用请联系主账号解除禁用，或者切换公司，感谢您的配合";

  @override
  void initState() {
    _childStatus = widget.arguments["childStatus"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String str = _reminder();
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.only(left: 37, right: 37),
          child: Center(
            child: Column(
              children: [
                _firstFigure(),
                const SizedBox(
                  height: 22,
                ),
                Center(
                  child: Text(
                    str,
                    textAlign: TextAlign.center,
                    style: const TextStyle(),
                  ),
                ),
                _buttonView(),
              ],
            ),
          ),
        ));
  }

  /// *
  /// -  @description: 显示按钮 逻辑
  /// -  @Date: 2022-10-08 15:53
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _buttonView() {
    ///是否显示离开公司
    bool isShowCancelLeave = true;

    ///子账号状态 0.禁用 1.启用 2.过期 3.删除
    switch (_childStatus) {
      case 0:
      case 2:
        isShowCancelLeave = true;
        break;
      case 3:
        isShowCancelLeave = false;
        break;
      default:
    }

    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (isShowCancelLeave)
            InkWell(
              child: Container(
                width: 132,
                height: 35,
                alignment: Alignment.center,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    side: BorderSide(
                      width: 1,
                      color: CustomColors.lightBlue,
                    ),
                  ),
                ),
                child: const Text(
                  "离开公司",
                  style: TextStyle(fontSize: 14, color: CustomColors.lightBlue),
                ),
              ),
              onTap: () => {_leaveCompany()},
            ),
          if (isShowCancelLeave)
            const SizedBox(
              width: 12,
            ),
          InkWell(
            child: Container(
              width: 132,
              height: 35,
              alignment: Alignment.center,
              decoration: const ShapeDecoration(
                color: CustomColors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                ),
              ),
              child: const Text(
                "切换公司",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            onTap: () => {_switchCompany()},
          ),
        ],
      ),
    );
  }

  /// *
  /// -  @description: 提示语构造方法
  /// -  @Date: 2022-10-08 15:54
  /// -  @parm:
  /// -  @return {*}
  ///
  String _reminder() {
    String str = "";

    ///子账号状态 0.禁用 1.启用 2.过期 3.删除
    switch (_childStatus) {
      case 0:
        str = _disableStr;
        break;
      case 2:
        str = _expireStr;
        break;
      case 3:
        str = _delStr;
        break;
      default:
    }
    return str;
  }

  /// *
  /// -  @description: 头图逻辑
  /// -  @Date: 2022-10-08 15:54
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _firstFigure() {
    String imagePath = "";

    ///子账号状态 0.禁用 1.启用 2.过期 3.删除
    switch (_childStatus) {
      case 0:
        imagePath = "assets/images/jinyong.png";
        break;
      case 2:
        imagePath = "assets/images/guoqi.png";
        break;
      case 3:
        imagePath = "assets/images/delIcon.png";
        break;
      default:
        imagePath = "";
    }
    // return str;

    return Container(
      margin: const EdgeInsets.only(top: 128),
      width: 265,
      height: 155,
      child: Image.asset(imagePath),
    );
  }

  /// *
  /// -  @description: 切换公司
  /// -  @Date: 2022-10-08 17:26
  /// -  @parm:
  /// -  @return {*}
  ///
  void _switchCompany() {
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            title: "提示",
            confirm: "确认",
            cancel: "取消",
            content: "您是否要切换当前公司",
            identity: "1",
            showCancel: true,
            clickListener: this,
          );
        });
  }

  /// *
  /// -  @description: 离开公司
  /// -  @Date: 2022-10-08 19:28
  /// -  @parm:
  /// -  @return {*}
  ///
  void _leaveCompany() {
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            title: "提示",
            confirm: "确认",
            cancel: "取消",
            content: "您是否要离开目前公司",
            identity: "2",
            showCancel: true,
            clickListener: this,
          );
        });
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> confirmMap) {
    String identity = confirmMap["identity"];
    if (identity == "1") {
      ///切换公司
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (context) => const SelectReplaceCompanyPage(),
          ))
          .then((value) => {
                if (value != null)
                  {
                    ///首页
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => RootPage(
                                  pageNumber: 0,
                                )),
                        (route) => route == null)
                  }
              });
    } else {
      ///离开公司
      SelectReplaceCompanyManager.companyLeaveCompany((object) {
        ToastUtils.showMessage("操作成功");
        LoginTools.loginOut(context);
        // _loginOut();
      });
    }
  }

  /// *
  /// -  @description: 退出
  /// -  @Date: 2022-10-08 19:25
  /// -  @parm:
  /// -  @return {*}
  ///
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
}
