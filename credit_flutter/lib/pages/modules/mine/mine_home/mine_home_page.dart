import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/mine_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/demand_center/my_needs_page.dart';
import 'package:credit_flutter/pages/modules/mine/about/about_page.dart';
import 'package:credit_flutter/pages/modules/mine/change_password/change_password_page.dart';
import 'package:credit_flutter/pages/modules/mine/enterprise_info/enterprise_info_page.dart';
import 'package:credit_flutter/pages/modules/mine/laws_regulatuins/laws_regulations_page.dart';
import 'package:credit_flutter/pages/modules/mine/mine_collection_page.dart';
import 'package:credit_flutter/pages/modules/news/news_collection.dart';
import 'package:credit_flutter/tools/login_tool.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../tools/global.dart';
import '../../login/login_page.dart';
import '../../login/login_type_page.dart';

/// @Description: 我的页面
class MineHomePage extends StatefulWidget {
  const MineHomePage({Key? key}) : super(key: key);

  @override
  State<MineHomePage> createState() => _MineHomePageState();
}

class _MineHomePageState extends State<MineHomePage> implements ClickListener {
  ///用户头像
  String picture = "";

  ///用户昵称
  String nickName = "";

  ///infoList
  List<Map<String, dynamic>> infoList = [
    {
      "name": "法律条文",
      "icon": "assets/images/svg/provisions.svg",
      "page": const LawsRegulationsPage()
    },
    {
      "name": "修改密码",
      "icon": "assets/images/svg/password.svg",
      "page": const ChangePasswordPage(
        type: PageType.password,
      )
    },
    {
      "name": "关于应用",
      "icon": "assets/images/svg/about.svg",
      "page": const AboutPage()
    },
    {
      "name": "我的收藏",
      "icon": "assets/images/svg/xin.svg",
      "page": const MineCollectionPage(),
    },
    {
      "name": "注销账号",
      "icon": "assets/images/svg/cancellation.svg",
    },
    {
      "name": "我的需求",
      "icon": "assets/images/svg/icon_my_needs.svg",
      "page": const MyNeedsPage(),
    }
  ];

  @override
  void initState() {
    //初始化主页面
    super.initState();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    // 取出数据
    _prefs.then((sp) {
      ///获取用户登录状态
      String? loginType = sp.getString(FinalKeys.LOGIN_TYPE);

      ///获取用户信息
      UserModel.getInfo((model) {
        if (model != null) {
          setState(() {
            ///判断登录类型1，企业。2，用户
            if (loginType == "1") {
              nickName = model.userInfo.companyInfo.name;
              picture = model.userInfo.companyInfo.headImgUrl;
              if (nickName.isEmpty) {
                nickName = model.userInfo.nickName;
              }
            } else {
              nickName = model.userInfo.nickName;
              picture = model.userInfo.headImgUrl;
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Text(
              "我的",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          color: CustomColors.colorF8F8FA,
          width: double.infinity,
          child: Column(
            children: [
              ///用户信息
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                color: Colors.white,
                height: 105.0,
                child: _userInfo(),
              ),
              const SizedBox(height: 10),
              // WidgetTools().createMaterialButton(
              //     ScreenTool.screenWidth - 60,
              //     "注销账户",
              //     Colors.white,
              //     Colors.black,
              //     0,
              //     () => {_showDialog(context)}),
              // const SizedBox(height: 20),
              // WidgetTools().createMaterialButton(ScreenTool.screenWidth - 60,
              //     "退出登录", Colors.white, Colors.black, 0, () => {_singOut()}),
              // const SizedBox(height: 20),
              // WidgetTools().createMaterialButton(
              //     ScreenTool.screenWidth - 60,
              //     "新闻收藏",
              //     Colors.white,
              //     Colors.black,
              //     0,
              //     () => {_newsCollection()})
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                height: 300.0,
                child: _infoListView(),
              ),
              const SizedBox(
                height: 30,
              ),
              WidgetTools().createCustomButton(
                ScreenTool.screenWidth - 60,
                "退出登录",
                () => {_singOut()},
                fontSize: 15,
                fontWeight: FontWeight.bold,
                radius: 23,
                borderColor: CustomColors.colorFFEBEBEB,
                borderWidth: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(widgetContext) {
    showCupertinoDialog(
      context: widgetContext,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('注销账户',
              style: TextStyle(
                color: CustomColors.textDarkColor,
                fontSize: 18,
              )),
          content: Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              "确认注销,慧眼查将在7天内处理你的申请并删除账号信息。手机号、第三方授权将于"
              "${_cancellationTime()}"
              "被释放,再次登录将会创建一个新的账号",
              style: const TextStyle(
                color: CustomColors.textDarkColor,
                fontSize: 16,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('确认注销'),
              onPressed: () {
                MineManager.userLogout((message) {
                  LoginTools.loginOut(context);
                });
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

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

  _cancellation(widgetContext) {
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            title: "提示",
            confirm: "是",
            cancel: "否",
            content: "是否注销该改账号？",
            showCancel: true,
            identity: "2",
            clickListener: this,
          );
        });
  }

  _userLogout() {
    Navigator.of(context).pop();
    _singOut();
  }

  _newsCollection() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewsCollectionPage(),
      ),
    );
  }

  /// *
  /// -  @description: 用户信息
  /// -  @Date: 2022-06-30 14:04
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _userInfo() {
    String directionStr = "assets/images/svg/back.svg";

    ///用户头像
    ImageProvider avatars;
    if (picture.isEmpty) {
      avatars = const AssetImage("assets/images/logo.png");
    } else {
      avatars = NetworkImage(picture);
    }

    ///存放用户头像容器
    Container userAcatarsContainer = Container(
      width: 58,
      height: 58,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: CustomColors.shadowColor,
            offset: Offset(0, 0),
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
      ),
      child: ClipOval(
        child: Image(
          image: avatars,
          fit: BoxFit.fill,
        ),
      ),
    );

    ///用户昵称
    Text nickText = Text(
      nickName,
      style: const TextStyle(
        color: CustomColors.textDarkColor,
        fontSize: 16,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    ///箭头
    SizedBox direction = SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        directionStr,
        fit: BoxFit.fill,
      ),
    );

    return GestureDetector(
      onTap: () {
        if (!PlatformUtils.isWeb) {
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
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          userAcatarsContainer,
          const SizedBox(width: 17),
          SizedBox(
            width: 184,
            height: 44,
            child: nickText,
          ),
          const Expanded(child: SizedBox()),
          if (!PlatformUtils.isWeb) direction,
        ],
      ),
    );
  }

  ///页面列表
  Widget _infoListView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        Map<String, dynamic> itemModel = infoList[index];
        return _rowListItemView(
          context,
          itemModel,
        );
      },
      itemCount: infoList.length,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  ///页面列表上item
  Widget _rowListItemView(
    BuildContext context,
    Map model,
  ) {
    String iconStr = model["icon"];
    String titleStr = model["name"];
    String directionStr = "assets/images/svg/back.svg";

    ///icon
    SizedBox icon = SizedBox(
      width: 23,
      height: 23,
      child: SvgPicture.asset(
        iconStr,
        fit: BoxFit.fill,
      ),
    );

    ///title
    Text title = Text(
      titleStr,
      style: const TextStyle(
        color: CustomColors.greyBlack,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );

    ///箭头
    SizedBox direction = SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        directionStr,
        fit: BoxFit.fill,
      ),
    );

    ///Line
    Container line = Container(
      margin: const EdgeInsets.only(left: 45),
      height: 1,
      color: CustomColors.lineColor,
    );
    return GestureDetector(
      onTap: (() {
        if ("注销账号" == titleStr) {
          _cancellation(context);
        } else {
          if (model["page"] != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => model["page"],
              ),
            );
          }
        }
      }),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 48,
        child: Column(
          children: [
            Row(
              children: [
                icon,
                const SizedBox(
                  width: 7,
                ),
                title,
                const Expanded(child: SizedBox()),
                direction,
              ],
            ),
            const SizedBox(
              height: 13,
            ),
            line,
          ],
        ),
      ),
    );
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> map) {
    String title = map["title"];
    String identity = map["identity"];
    if (identity == "1") {
      LoginTools.loginOut(context);
    } else {
      _showDialog(this.context);
    }
  }

  /// *
  /// -  @description: 注销时间
  /// -  @Date: 2022-07-05 14:31
  /// -  @parm:
  /// -  @return {*}
  ///
  String _cancellationTime() {
    var time = DateTime.now().add(const Duration(days: 7));
    return "${time.year}年${time.month}月${time.day}日";
  }

  // void _loginOut() {
  //   Golbal.isStorage = false;
  //
  //   ///清空用户数据
  //   UserModel.removeUserInfo();
  //   // 获得实例
  //   Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  //   // 取出数据
  //   prefs.then((sp) {
  //     sp.clear();
  //     sp.setBool(FinalKeys.FIRST_OPEN, true);
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => const LoginTypePage()),
  //         (route) => false);
  //   });
  // }

  void _refreshData() {
    setState(() {});
  }
}
