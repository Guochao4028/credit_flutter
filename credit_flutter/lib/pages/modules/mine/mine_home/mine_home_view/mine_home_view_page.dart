/// *
/// -  @Date: 2022-07-07 11:25
/// -  @LastEditTime: 2022-07-07 11:25
/// -  @Description: 我的页面 所有子控件view的集合
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MineHomeView {
  final UserInfoViewClickListener? clickListener;
  UserModel? _model;

  MineHomeView({this.clickListener, Key? key});

  /// *
  /// -  @description: 用户信息 view
  /// -  @Date: 2022-07-07 17:16
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget userInfoView(UserModel? model, String? loginType) {
    if (model != null) {
      _model = model;

      ///判断登录类型1，企业。2，用户
      if (loginType == "1") {
        ///企业
        return _companyView(model);
      } else {
        ///用户
        return _personView(model);
      }
    }

    return const SizedBox();
  }

  /// *
  /// -  @description: 会员中心
  /// -  @Date: 2022-07-07 17:18
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget memberCenterView() {
    return GestureDetector(
      onTap: () {
        clickListener?.tapMemberView();
      },
      child: SizedBox(
        // height: 60,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            padding: const EdgeInsets.only(left: 19, top: 10, bottom: 10),
            decoration: const BoxDecoration(
              color: CustomColors.goldenColorAB,
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "会员中心",
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.bgRedColor5D2F,
                      ),
                    ),
                    Text(
                      "开通立即享受8折优惠",
                      style: TextStyle(
                        fontSize: 12,
                        color: CustomColors.bgRedColor5D2F,
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Container(
                  width: 85,
                  height: 30,
                  padding: const EdgeInsets.only(left: 14),
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(100)),
                    color: CustomColors.color39405D,
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/MemberIcon.png"),
                      const Text(
                        " 去开通",
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.goldenColor0D9B7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// *
  /// -  @description: 常用功能 标题
  /// -  @Date: 2022-07-07 18:12
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget commonFunctionTitle() {
    return Container(
      height: 68,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: const Text(
        "常用功能",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: CustomColors.greyBlack,
        ),
      ),
    );
  }

  Widget commonFunctionView(List list, int quantity) {
    double height = 172;
    if (list.length > 4) {
      height = 172;
    } else {
      height = height / 2;
    }
    return Container(
      height: height,
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.only(left: 18, right: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 0.0),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        //禁止滑动
        padding: const EdgeInsets.all(0),
        // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        //   // mainAxisSpacing: 28.0,
        //   // crossAxisSpacing: 22.0,
        //   maxCrossAxisExtent: 86,
        // ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 86,
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          //自定义的行 代码在下面
          // return _showGridViewItem(
          // context, itmeList[pageViewNumber + index]);
          return _showGridViewItem(list[index], index, quantity);
        },
      ),
    );
  }

  _showGridViewItem(Map<String, dynamic> model, int index, int quantity) {
    String imagePath = model["icon"];
    String titleStr = model["name"];
    bool flag = imagePath.contains("svg");

    ///icon
    SizedBox icon = SizedBox(
      width: 27,
      height: 27,
      child: flag == false
          ? Image.asset(
              imagePath,
              fit: BoxFit.fill,
            )
          : SvgPicture.asset(
              imagePath,
              fit: BoxFit.fill,
            ),
    );

    ///title
    Text title = Text(
      titleStr,
      style: const TextStyle(
        color: CustomColors.greyBlack,
        fontSize: 12,
      ),
    );

    Widget widget;
    if (titleStr == "消息中心") {
      widget = Stack(
        children: [
          Align(
            child: Container(
              // color: Colors.red,
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 0),
                  icon,
                  const SizedBox(height: 3),
                  title,
                ],
              ),
            ),
          ),
          if (quantity > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 22),
                Container(
                  margin: const EdgeInsets.only(top: 18),
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4444),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ],
            )
        ],
      );
    } else {
      widget = Container(
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 0),
            icon,
            const SizedBox(height: 3),
            title,
          ],
        ),
      );
    }

    return GestureDetector(
        onTap: () => clickListener?.tapGridViewItem(index), child: widget);
  }

  /// *
  /// -  @description: 退出
  /// -  @Date: 2022-07-07 18:31
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget quitView() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        WidgetTools().createCustomButton(
          ScreenTool.screenWidth - 60,
          "退出登录",
          () => {clickListener?.tapSingOut()},
          fontSize: 15,
          fontWeight: FontWeight.bold,
          radius: 23,
          borderColor: CustomColors.colorFFEBEBEB,
          borderWidth: 1,
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  /// *
  /// -  @description: 企业 用户信息 入口
  /// -  @Date: 2022-07-07 18:11
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _companyView(UserModel model) {
    ///名字
    String name = model.userInfo.companyInfo.licenceName;

    ///头像
    String picture = model.userInfo.companyInfo.headImgUrl;

    ///职位
    String position = model.userInfo.companyInfo.accountPerson;

    ///到期时间
    String endTime = model.userInfo.companyInfo.maturityTime;
    String balance = model.userInfo.companyInfo.balance.toString();

    int vipType = 0;
    if (model.userInfo.companyInfo.vipStatus == 1) {
      if (model.userInfo.companyInfo.vipType == 1) {
        //vip
        vipType = 1;
      } else if (model.userInfo.companyInfo.vipType == 2) {
        //svip
        vipType = 2;
      }
    }

    double height = 185.0 - 49;

    List<Widget> viewList = [];
    viewList.add(_userInfo(
      name: name,
      picture: picture,
      position: position,
      endTime: endTime,
      vipType: vipType,
    ));

    if (!PlatformUtils.isIOS) {
      height = 185;
      viewList.add(const SizedBox(height: 24));
      viewList.add(_balanceView(balance));
    }

    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
      color: CustomColors.colorFFF7F8FA,
      height: height,
      child: Column(
        children: viewList,
      ),
    );
  }

  /// *
  /// -  @description: 个人 用户信息 入口
  /// -  @Date: 2022-09-21 11:15
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _personView(UserModel model) {
    ///名字
    String name = model.userInfo.nickName;

    ///职位
    String position = model.userInfo.position;

    String balance = model.userInfo.balance.toString();

    List<Widget> viewList = [];
    viewList.add(
      _personUserInfo(
        name: name,
        position: position,
      ),
    );
    double height = 185.0 - 49;
    if (!PlatformUtils.isIOS) {
      viewList.add(const SizedBox(height: 24));
      viewList.add(_balanceView(balance));
      height = 185;
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      color: CustomColors.colorFFF7F8FA,
      height: height,
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          children: viewList,
        ),
      ),
    );
  }

  /// *
  /// -  @description: 个人 用户信息
  /// -  @Date: 2022-09-21 14:36
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _personUserInfo({
    String name = "",
    String position = "",
  }) {
    ///箭头
    String directionStr = "assets/images/svg/back.svg";

    ///用户头像

    ///用户昵称
    Text nickText = Text(
      name,
      style: const TextStyle(
        color: CustomColors.textDarkColor,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      // maxLines: 2,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    ///职位
    Text positionText = Text(
      position,
      style: const TextStyle(
        color: CustomColors.textDarkColor,
        fontSize: 17,
      ),
      maxLines: 1,
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
        clickListener?.tapUserInfoView();
      },
      child: Container(
        color: CustomColors.colorFFF7F8FA,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _headPortrait(name),
            const SizedBox(width: 17),
            SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 200,
                    child: nickText,
                  ),
                  Row(
                    children: [
                      if (position.isNotEmpty) positionText,
                    ],
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            direction,
          ],
        ),
      ),
    );
  }

  Widget _headPortrait(String name) {
    if (name.isNotEmpty) {
      name = name.substring(0, 1);
    } else {
      name = "";
    }
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        //背景
        color: CustomColors.connectColor,
        //设置四周圆角 角度
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        style: const TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// *
  /// -  @description: 用户信息
  /// -  @Date: 2022-07-07 15:34
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _userInfo(
      {String name = "",
      String picture = "",
      String position = "",
      String endTime = "",
      int vipType = 0}) {
    ///箭头
    String directionStr = "assets/images/svg/back.svg";

    ///用户头像
    ImageProvider avatars;
    if (picture.isEmpty) {
      avatars = const AssetImage("assets/images/icon_default_avatar.jpeg");
    } else {
      avatars = NetworkImage(picture);
    }

    ///存放用户头像容器
    Container userAcatarsContainer = Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(1),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: CustomColors.color17000,
            offset: Offset(0, 0),
            blurRadius: 4,
            spreadRadius: 0,
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
      name,
      style: const TextStyle(
        color: CustomColors.textDarkColor,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      // maxLines: 2,
      // maxLines: 1,
      // overflow: TextOverflow.ellipsis,
    );

    ///职位
    Text positionText = Text(
      position,
      style: const TextStyle(
        color: CustomColors.textDarkColor,
        fontSize: 17,
      ),
      maxLines: 1,
    );

    ///认证状态
    CompanyInfo cInfo = _model!.userInfo.companyInfo;
    String verifiedStr = cInfo.getCompanyVerifiedStatus();
    Color bgAutoStatusBgColor = Colors.white;
    Color verifiedTextColor = Colors.white;
    double vwitdh = 46, vheight = 16;

    switch (cInfo.getVerifiedStatus()) {
      case StateType.success:
        vheight = 0;
        vwitdh = 0;
        break;
      case StateType.fail:
        bgAutoStatusBgColor = CustomColors.colorF82522;
        vwitdh = 56;
        break;
      case StateType.waiting:
        bgAutoStatusBgColor = CustomColors.colorF5AF4D;
        break;
      default:
        bgAutoStatusBgColor = CustomColors.colorD8D8D8;
        verifiedTextColor = CustomColors.darkGreyE6;
    }

    Container autoStatusContainer = Container(
      height: vheight,
      width: vwitdh,
      decoration: BoxDecoration(
        //设置四周圆角 角度
        borderRadius: const BorderRadius.all(Radius.circular(7.5)),
        color: bgAutoStatusBgColor,
      ),
      padding: const EdgeInsets.all(2),
      child: Text(
        verifiedStr,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: verifiedTextColor,
          fontSize: 8,
        ),
      ),
    );

    ///到期时间
    Text endTimeText = Text(
      endTime,
      style: const TextStyle(
        color: CustomColors.darkGrey99,
        fontSize: 17,
      ),
      maxLines: 1,
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
        clickListener?.tapUserInfoView();
      },
      child: Container(
        color: CustomColors.colorFFF7F8FA,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            userAcatarsContainer,
            const SizedBox(width: 17),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 200,
                    child: nickText,
                  ),
                  Row(
                    children: [
                      if (position.isNotEmpty) positionText,
                      const SizedBox(
                        width: 5,
                      ),
                      autoStatusContainer,
                      const SizedBox(
                        width: 5,
                      ),
                      if (vipType != 0) WidgetTools().getMemberLogo(vipType),
                    ],
                  ),
                  if (endTime.isNotEmpty) endTimeText,
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            direction,
          ],
        ),
      ),
    );
  }

  /// *
  /// -  @description: 慧眼币
  /// -  @Date: 2022-07-07 15:35
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _balanceView(String balance) {
    return GestureDetector(
      onTap: () {
        // if (!PlatformUtils.isWeb) {
        clickListener?.tapRechargeView();
        // }
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/资产背景.png'),
            fit: BoxFit.fill, // 完全填充
          ),
        ),
        height: 49,
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/moneyIcon.png",
              width: 36,
              height: 32,
            ),
            const SizedBox(width: 23),
            const Text(
              "慧眼币",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(width: 15),
            Text(
              balance,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const Expanded(child: SizedBox()),
            Container(
              padding: const EdgeInsets.all(5),
              width: 75,
              height: 30,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: CustomColors.lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: const Text(
                "去充值",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class UserInfoViewClickListener {
  ///用户信息点击
  void tapUserInfoView();

  ///充值点击
  void tapRechargeView();

  ///会员点击
  void tapMemberView();

  ///退出
  void tapSingOut();

  ///点击常用功能
  void tapGridViewItem(int index);
}
