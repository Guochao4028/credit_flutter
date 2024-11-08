/// *
/// -  @Date: 2022-07-07 10:58
/// -  @LastEditTime: 2022-07-07 10:58
/// -  @Description:
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/mine/about/about_page.dart';
import 'package:credit_flutter/pages/modules/mine/asset/asset_management_page.dart';
import 'package:credit_flutter/pages/modules/mine/authorization_code/authorization_code_page.dart';
import 'package:credit_flutter/pages/modules/mine/change_password/change_password_page.dart';
import 'package:credit_flutter/pages/modules/mine/enterprise_info/enterprise_info_page.dart';
import 'package:credit_flutter/pages/modules/mine/message_center/message_center_page.dart';
import 'package:credit_flutter/pages/modules/mine/mine_home/mine_home_view/mine_home_view_page.dart';
import 'package:credit_flutter/pages/modules/mine/mine_home/mine_home_view/person_info/person_info_page.dart';
import 'package:credit_flutter/pages/modules/mine/my_company/my_company_page.dart';
import 'package:credit_flutter/pages/modules/mine/order/order_page.dart';
import 'package:credit_flutter/pages/modules/mine/personnel_management/personnel_management_page.dart';
import 'package:credit_flutter/pages/modules/mine/vip/vip_page.dart';
import 'package:credit_flutter/tools/login_tool.dart';
import 'package:credit_flutter/utils/event_bus.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../../../tools/global.dart';
import '../../../../utils/log.dart';
import '../../pay/pay_password/pay_password_page.dart';
import '../../pay/pay_password/pay_setup_password_view.dart';
import '../history/history_page.dart';

/// @Description: 我的页面
class MineHomeNewPage extends StatefulWidget {
  const MineHomeNewPage({Key? key}) : super(key: key);

  @override
  State<MineHomeNewPage> createState() => _MineHomeNewPageState();
}

class _MineHomeNewPageState extends State<MineHomeNewPage>
    implements ClickListener, UserInfoViewClickListener {
  UserModel? userModel;

  int quantity = 0;

  ///主view
  MineHomeView? homeView;
  String? loginType;

  List<Map<String, dynamic>> infoList = [
    // {"name": "企业认证", "icon": "assets/images/svg/companyInfo.svg"},
    // {
    //   "name": "我的授权码",
    //   "icon": "assets/images/code.png",
    // },
    {
      "name": "我的订单",
      "icon": "assets/images/order.png",
      "page": const OrderListPage(),
    },
    {
      "name": "人员管理",
      "icon": "assets/images/ren.png",
      "page": const PersonnelManagementPage(),
    },
    {
      "name": "支付密码",
      "icon": "assets/images/pay.png",
    },
    {
      "name": "我的公司",
      "icon": "assets/images/company.png",
      "page": const MyCompanyPage()
    },
    {
      "name": "消息中心",
      "icon": "assets/images/info.png",
    },
    // {
    //   "name": "分享小程序",
    //   "icon": "assets/images/share.png",
    // },
    {
      "name": "修改密码",
      "icon": "assets/images/ChangePassword.png",
      "page": const ChangePasswordPage(
        type: PageType.password,
      )
    },
    {
      "name": "关于我们",
      "icon": "assets/images/about.png",
      "page": const AboutPage(),
    },
  ];

  List<Map<String, dynamic>> personInfoList = [
    {
      "name": "我的订单",
      "icon": "assets/images/order.png",
      "page": const OrderListPage(),
    },
    {
      "name": "支付密码",
      "icon": "assets/images/pay.png",
    },
    {
      "name": "消息中心",
      "icon": "assets/images/info.png",
    },
    {
      "name": "关于我们",
      "icon": "assets/images/about.png",
      "page": const AboutPage(),
    },
  ];

  List<Widget> viewList = [];

  ///是否设置过支付密码
  ///默认是设置过 true
  bool isPassworedFlag = true;

  @override
  void initState() {
    //初始化主页面
    super.initState();

    bus.on("refreshPage", (arg) {
      Log.e("refreshPage");
      MineHomeManager.userGetUserInfo((message) => {_refreshData()});
    });

    homeView = MineHomeView(clickListener: this);
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    // 取出数据
    _prefs.then((sp) {
      ///获取用户登录状态
      ///1，企业。2，用户
      loginType = sp.getString(FinalKeys.LOGIN_TYPE);

      if (loginType == "2") {
        personInfoList.insert(3, {
          "name": "历史报告",
          "icon": "assets/images/history.png",
          "page": const HistoryPage(),
        });
      }
      _refreshData();
    });
    MineHomeManager.getMessageUnreadCount((str) {
      quantity = int.parse(str);
      _refreshData();
    });

    Golbal.changeNotifier.addListener(() {
      Golbal.changeNotifier.message;
      setState(() {
        isPassworedFlag = true;
      });
    });
    UmengCommonSdk.onPageStart("mine_page");
  }

  @override
  void dispose() {
    super.dispose();
    bus.off("refreshPage");
    UmengCommonSdk.onPageEnd("mine_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航
      appBar: AppBar(
        backgroundColor: CustomColors.lightBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "我的",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
      backgroundColor: CustomColors.colorFFFDFDFD,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: viewList,
          ),
        ),
      ),
    );
  }

/////////////// -- Action--
  _singOut() {
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            title: "提示",
            confirm: "是",
            cancel: "否",
            content: "是否退出账号",
            showCancel: true,
            identity: "1",
            clickListener: this,
          );
        });
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> map) {
    String title = map["title"];
    String identity = map["identity"];
    if (identity == "1") {
      // _loginOut();
      LoginTools.loginOut(context);
    } else if (identity == "99") {
      String authorizationCode =
          userModel?.userInfo.companyInfo.authorizationCode ?? "";
      Clipboard.setData(ClipboardData(text: authorizationCode));

      ToastUtils.showMessage("复制成功");
    } else if (identity == "verifiedState") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const EnterpriseInfoPage(),
        ),
      );
    }
  }

  /// *
  /// -  @description: 刷新数据
  /// -  @Date: 2022-07-11 11:54
  /// -  @parm:
  /// -  @return {*}
  ///
  void _refreshData() {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    // 取出数据
    _prefs.then((sp) {
      ///获取用户登录状态
      loginType = sp.getString(FinalKeys.LOGIN_TYPE);

      ///获取用户信息
      UserModel.getInfo((model) {
        if (model != null) {
          setState(() {
            userModel = model;
            if (model.userInfo.getIfSet()) {
              isPassworedFlag = false;
            }

            infoList = [
              // {"name": "企业认证", "icon": "assets/images/svg/companyInfo.svg"},
              {
                "name": "我的订单",
                "icon": "assets/images/order.png",
                "page": const OrderListPage(),
              },
              {
                "name": "人员管理",
                "icon": "assets/images/ren.png",
                "page": const PersonnelManagementPage(),
              },
              {
                "name": "支付密码",
                "icon": "assets/images/pay.png",
              },
              {
                "name": "我的公司",
                "icon": "assets/images/company.png",
                "page": const MyCompanyPage()
              },
              {
                "name": "消息中心",
                "icon": "assets/images/info.png",
              },
              // {
              //   "name": "分享小程序",
              //   "icon": "assets/images/share.png",
              // },
              {
                "name": "修改密码",
                "icon": "assets/images/ChangePassword.png",
                "page": const ChangePasswordPage(
                  type: PageType.password,
                )
              },
              {
                "name": "关于我们",
                "icon": "assets/images/about.png",
                "page": const AboutPage(),
              }
            ];

            if (model.userInfo.companyInfo.verifiedStatus == 1) {
              if (model.userInfo.companyInfo.agencyCode.isNotEmpty) {
                infoList.add({
                  "name": "我的授权码",
                  "icon": "assets/images/code.png",
                  "page": const AuthorizationCodePage(),
                });
              }
            }

            List<Map<String, dynamic>> temp = infoList;

            if (loginType == "1") {
              viewList.clear();
              viewList.add(homeView!.userInfoView(userModel, loginType));
              viewList.add(const SizedBox(height: 10));

              if (model.userInfo.owner != 1) {
                for (var i = 0; i < temp.length; i++) {
                  Map<String, dynamic> map = temp[i];

                  String name = map["name"];
                  if (name == "人员管理") {
                    temp.remove(map);
                  }
                }
              } else {
                if (!PlatformUtils.isIOS) {
                  viewList.add(homeView!.memberCenterView());
                }
              }
              viewList.add(homeView!.commonFunctionTitle());
              viewList.add(homeView!.commonFunctionView(temp, quantity));
              viewList.add(homeView!.quitView());
            } else {
              viewList = [
                homeView!.userInfoView(userModel, loginType),
                const SizedBox(height: 10),
                homeView!.commonFunctionTitle(),
                homeView!.commonFunctionView(personInfoList, quantity),
                homeView!.quitView()
              ];
            }
          });
        }
      });
    });
  }

  @override
  void tapUserInfoView() {
    if (loginType == "1") {
      var push = Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const EnterpriseInfoPage(),
        ),
      );
      push.then((value) {
        if (value != null) {
          MineHomeManager.userGetUserInfo((message) => {_refreshData()});
        }
      });
    } else {
      var push = Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const PersonInfoPage(),
        ),
      );
      push.then((value) {
        Log.d("message");
        // if (value != null) {
        MineHomeManager.userGetUserInfo((message) => {_refreshData()});
        // }
      });
    }
  }

  @override
  void tapRechargeView() {
    if (loginType == "1" && (userModel!.userInfo.owner == 1) ||
        loginType == "2" ||
        loginType == "3") {
      if (loginType == "1") {
        StateType verifiedStateType =
            userModel!.userInfo.companyInfo.getVerifiedStatus();
        if (verifiedStateType != StateType.success) {
          popWidget(verifiedStateType, context);
          return;
        }
      }
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const AssetManagementPage(),
      ));
    } else {
      ToastUtils.showMessage("您的账号为子账号，目前不能进行充值");
    }
  }

  @override
  void tapMemberView() {
    if (loginType == "1" && (userModel!.userInfo.owner == 1)) {
      StateType verifiedStateType =
          userModel!.userInfo.companyInfo.getVerifiedStatus();
      if (verifiedStateType != StateType.success) {
        popWidget(verifiedStateType, context);
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VipPageWidget(),
        ),
      );
    } else {
      ToastUtils.showMessage("您的账号为子账号，目前不能进行");
    }
  }

  /// *
  /// -  @description: 弹窗
  /// -  @Date: 2022-10-13 15:47
  /// -  @parm:
  /// -  @return {*}
  ///
  void popWidget(StateType verifiedStateType, BuildContext context) {
    switch (verifiedStateType) {
      case StateType.fail:

        /// 认证失败
        showDialog(
            context: context,
            builder: (context) {
              return const PopupWindowDialog(
                title: "认证失败",
                confirm: "知道了",
                content: "您的企业认证信息认证失败",
                contentImage: "assets/images/fail.png",
                showCancel: false,
                identity: "0",
              );
            });
        break;
      case StateType.waiting:

        /// 认证中
        showDialog(
            context: context,
            builder: (context) {
              return PopupWindowDialog(
                title: "认证中",
                confirm: "知道了",
                content: "您的企业认证信息正在认证请等待审核",
                contentImage: "assets/images/waiting.png",
                showCancel: false,
                identity: "0",
              );
            });
        break;
      default:

        /// 未认证
        showDialog(
            context: context,
            builder: (context) {
              return PopupWindowDialog(
                title: "提示",
                confirm: "去认证",
                cancel: "知道了",
                content: "请先认证企业信息",
                showCancel: true,
                identity: "verifiedState",
                clickListener: this,
              );
            });
    }
  }

  @override
  void tapSingOut() {
    _singOut();
  }

  @override
  void tapGridViewItem(int index) {
    Map<String, dynamic> model;
    if (loginType == "1") {
      model = infoList[index];
    } else {
      model = personInfoList[index];
    }

    String name = model["name"];

    if (model["page"] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => model["page"],
        ),
      ).then((value) {
        _refreshData();
      });

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => model["page"],
      //   ),
      // );
    } else {
      // if (name == "我的授权码") {
      //   String? authorizationCode =
      //       userModel?.userInfo.companyInfo.authorizationCode;
      //   showDialog(
      //       context: context,
      //       builder: (context) {
      //         return AuthorizationPopupWindowDialog(
      //           authorizationCode: authorizationCode ?? "",
      //           clickListener: this,
      //         );
      //       });
      // } else
      if (name == "消息中心") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageCenterPage(quantity: quantity),
          ),
        ).then((value) {
          MineHomeManager.getMessageUnreadCount((str) {
            //刷新
            quantity = int.parse(str);
            if (quantity <= 0) {
              _refreshData();
            }
          });
        });
      } else if (name == "支付密码") {
        // "page": const PayPasswordPage()
        //判断是否保存支付密码
        if (isPassworedFlag) {
          //有密码
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const PayPasswordPage(),
          ));
        } else {
          //没有密码
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const PaySetupPasswordPage(),
          ));
        }
      }
    }
  }
}
