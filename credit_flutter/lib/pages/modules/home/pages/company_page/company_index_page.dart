/// *
/// -  @Date: 2022-09-19 13:48
/// -  @LastEditTime: 2022-09-19 13:49
/// -  @Description: 企业首页
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/mine/enterprise_info/enterprise_info_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/pages/modules/report/report_details_example_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../report/new_report_example_page.dart';

class CompanyIndexPage extends StatefulWidget {
  const CompanyIndexPage({Key? key}) : super(key: key);

  @override
  State<CompanyIndexPage> createState() => _CompanyIndexPageState();
}

class _CompanyIndexPageState extends State<CompanyIndexPage>
    implements ClickListener {
  ///处理手机号
  final textPhoneController = TextEditingController();

  ///处理姓名
  final textNameController = TextEditingController();

  ///处理身份证
  final textIdController = TextEditingController();

  ///名字错误信息
  String nameErrorStr = "";

  ///手机号错误信息
  String phoneErrorStr = "";

  ///身份证号错误信息
  String idErrorStr = "";

  ///名字信息
  String nameStr = "";

  ///手机号信息
  String phoneStr = "";

  ///身份证号信息
  String idStr = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBar(),
        elevation: 0,
        backgroundColor: CustomColors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  width: ScreenTool.screenWidth,
                  child: _icon(),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  width: ScreenTool.screenWidth - 32,
                  child: _inputWidger(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// *
  /// -  @description: appBar 开通会员  title
  /// -  @Date: 2022-06-20 16:32
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _appBar() {
    //开通会员
    Widget openVip = Container(
      width: 94,
      height: 32,
      padding: const EdgeInsets.only(left: 8, right: 8),
      decoration: const BoxDecoration(
        color: CustomColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Row(
        children: const [
          Image(
            image: AssetImage("assets/images/vipIcon.png"),
            width: 16,
            height: 16,
            // fit: BoxFit.fill,
          ),
          Text(
            " 开通会员",
            style: TextStyle(
              color: CustomColors.goldenColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );

    //标题
    Widget titleView = Container(
      alignment: Alignment.center,
      child: const Text(
        "慧眼查",
        style: TextStyle(fontSize: 17),
      ),
    );

    return Row(
      children: [
        // openVip,
        const SizedBox(
          width: 94,
        ),
        Expanded(
          child: titleView,
        ),
        const SizedBox(
          width: 94,
        ),
      ],
    );
  }

  /// *
  /// -  @description:  icon  存放慧眼查图标
  /// -  @Date: 2022-06-20 17:35
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _icon() {
    Container container = Container(
        color: CustomColors.bgRedColor,
        padding: const EdgeInsets.only(left: 4),
        child: const Text(
          "国家信用体系建设\n 重 点 服 务 平 台",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));

    return Container(
      color: CustomColors.lightBlue,
      height: 117,
      padding: const EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 131,
            height: 31,
            child: Image(
              image: AssetImage("assets/images/nowcheck.png"),
              fit: BoxFit.fill,
            ),
          ),
          container,
        ],
      ),
    );
  }

  /// *
  /// -  @description:  输入面板
  /// -  @Date: 2022-06-20 18:19
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _inputWidger(BuildContext context) {
    ///报告样例
    Container sampleReport = Container(
      padding: const EdgeInsets.only(
        right: 15,
      ),
      height: 24,
      child: Row(
        children: [
          const Expanded(
            child: SizedBox(),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewReportExamplePage(),
                ),
              );
            },
            child: Text(
              "查看报告样例",
              style: TextStyle(
                  color: CustomColors.goldenColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    ///标题
    Container titleContainer = Container(
      alignment: Alignment.center,
      height: 17,
      child: const Image(
        image: AssetImage("assets/images/titleImage.png"),
      ),
    );

    ///*输入请输入真实信息以确保搜索的准确性
    Container promptContainer = Container(
      margin: const EdgeInsets.only(left: 16),
      child: const Text(
        "*请输入真实信息以确保搜索的准确性",
        style: TextStyle(fontSize: 12, color: CustomColors.bgRedColor),
      ),
    );

    ///输入要查询人的手机号，您要查询的授权请求...
    Container promptInfoContainer = Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 11,
      ),
      child: const Text(
        "输入要查询人的手机号，您要查询的授权请求 将会以短信的方式发送到对方手机上，对方授权成功后方可看到要查询的信息。",
        style: TextStyle(
          color: CustomColors.bgRedColor,
          fontSize: 12,
        ),
      ),
    );

    List<TextInputFormatter> nameInputFormatterList = [
      // FilteringTextInputFormatter.allow(RegExp(r'[\u4e00-\u9fa5, A-Z,a-z]')),
      FilteringTextInputFormatter.deny(
        RegExp(
            "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"),
      ),

      // FilteringTextInputFormatter.allow(RegExp(r'[.]')),
      LengthLimitingTextInputFormatter(20),
    ];
    List<TextInputFormatter> phoneInputFormatterList = [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      LengthLimitingTextInputFormatter(11),
    ];

    List<TextInputFormatter> idInputFormatterList = [
      FilteringTextInputFormatter.allow(RegExp(r'[X,x,0-9]')),
      LengthLimitingTextInputFormatter(18),
    ];

    return Container(
      height: 397,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 0.0), //阴影xy轴偏移量
              blurRadius: 4.0, //阴影模糊程度
              spreadRadius: 3.0 //阴影扩散程度
              ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sampleReport,
          titleContainer,
          const SizedBox(
            height: 20,
          ),
          promptContainer,

          inputTextFiled(
            "请输入姓名",
            "assets/images/nameIcon.png",
            textNameController,
            nameInputFormatterList,
            TextInputType.text,
          ),
          addErrorPrompt(nameErrorStr),
          inputTextFiled(
            "请输入身份证号",
            "assets/images/idIcon.png",
            textIdController,
            idInputFormatterList,
            TextInputType.text,
          ),
          addErrorPrompt(idErrorStr),
          inputTextFiled(
              "请输入手机号",
              "assets/images/phoneIcon.png",
              textPhoneController,
              phoneInputFormatterList,
              TextInputType.number),
          addErrorPrompt(phoneErrorStr),
          promptInfoContainer,
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 14),
            child: WidgetTools().createMaterialButton(
              ScreenTool.screenWidth - 32 - 32,
              "查询",
              CustomColors.lightBlue,
              Colors.white,
              0,
              () {
                ///验证输入的合法性
                if (determineLegal()) {
                  ///查询报告
                  selecedInfo(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget inputTextFiled(
      String hintText,
      String iconPath,
      TextEditingController textEditingController,
      List<TextInputFormatter> inputFormatters,
      TextInputType inputType) {
    InputDecoration decoration = InputDecoration(
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      icon: Image(
        image: AssetImage(iconPath),
        width: 18,
        height: 18,
      ),
    );

    TextField textField = TextField(
      controller: textEditingController,
      onChanged: (str) {
        nameErrorStr = "";
        phoneErrorStr = "";
        idErrorStr = "";
        setState(() {});

        if (textEditingController == textNameController) {
          nameStr = str;
        } else if (textEditingController == textIdController) {
          idStr = str;
        } else {
          phoneStr = str;
        }
      },
      inputFormatters: inputFormatters,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: inputType,
      decoration: decoration,
    );

    return Container(
      height: 56,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 11),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColors.lightGrey,
            width: 0.5,
          ),
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        padding: const EdgeInsets.only(left: 16),
        child: textField,
      ),
    );
  }

  /// *
  /// -  @description: 查询按钮逻辑
  /// -  @Date: 2022-06-23 10:47
  /// -  @parm:
  /// -  @return {*}
  ///
  void selecedInfo(BuildContext context) {
    /// 获取用户信息
    UserModel.getInfo(
      (model) {
        StateType verifiedStateType =
            model!.userInfo.companyInfo.getVerifiedStatus();

        popWidget(verifiedStateType, context);
      },
    );
  }

  /// *
  /// -  @description: 弹窗
  /// -  @Date: 2022-06-24 09:46
  /// -  @parm: verifiedStateType 公司认证状态
  /// -  @return {*}
  ///
  void popWidget(StateType verifiedStateType, BuildContext context) {
    switch (verifiedStateType) {
      case StateType.success:

        /// 认证成功
        /// 校验账号合法性
        Golbal.checkAccount((success, userModel) {
          if (userModel != null) {
            UserInfo userInfo = userModel.userInfo;
            if (success == true) {
              _payment();
            } else {
              Navigator.pushNamed(context, "/childAccountInfo",
                  arguments: {"childStatus": userInfo.childStatus});
            }
          }
          setState(() {});
        });

        break;
      case StateType.fail:

        /// 认证失败
        showDialog(
            context: context,
            builder: (context) {
              return  PopupWindowDialog(
                title: "认证失败",
                confirm: "知道了",
                content: "您的企业认证信息认证失败",
                contentImage: "assets/images/fail.png",
                showCancel: false,
              );
            });
        break;
      case StateType.waiting:

        /// 认证中
        showDialog(
            context: context,
            builder: (context) {
              return  PopupWindowDialog(
                title: "认证中",
                confirm: "知道了",
                content: "您的企业认证信息正在认证请等待审核",
                contentImage: "assets/images/waiting.png",
                showCancel: false,
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
                clickListener: this,
              );
            });
    }
  }

  /// *
  /// -  @description: 判断输入的合法性
  /// -  @Date: 2022-06-24 09:47
  /// -  @parm:
  /// -  @return {*}
  ///
  bool determineLegal() {
    bool flag = true;
    if (!verifyName()) {
      flag = false;
    } else if (!verifyId()) {
      flag = false;
    } else if (!verifyPhone()) {
      flag = false;
    }

    setState(() {});
    return flag;
  }

  bool verifyPhone() {
    bool flag = true;
    if (StringTools.isEmpty(phoneStr)) {
      phoneErrorStr = "手机号不能为空";
      flag = false;
    }
    if (!RegexUtils.verifyPhoneNumber(phoneStr)) {
      phoneErrorStr = "请输入正确手机号";
      flag = false;
    }
    return flag;
  }

  bool verifyName() {
    bool flag = true;
    if (StringTools.isEmpty(nameStr)) {
      nameErrorStr = "姓名不能为空";
      flag = false;
      return flag;
    }

    if (StringTools.checkSpace(nameStr)) {
      nameErrorStr = "姓名中不能有空格或特殊符号";
      flag = false;
      return flag;
    }

    if (StringTools.checkABC(nameStr)) {
      nameErrorStr = "姓名中不能有英文字母";
      flag = false;
      return flag;
    }

    return flag;
  }

  bool verifyId() {
    bool flag = true;
    Map map = StringTools.verifyCardId(idStr);
    flag = map["state"];
    if (flag == false) {
      idErrorStr = map["message"];
    }
    return flag;
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> map) {
    String title = map["title"];
    // String identity = map["identity"];

    if (title == "去认证") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const EnterpriseInfoPage(),
        ),
      );
    }
  }

  Widget addErrorPrompt(String title) {
    return Offstage(
      offstage: StringTools.isEmpty(title),
      child: Container(
        padding: const EdgeInsets.only(left: 34),
        height: 20,
        child: Row(children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: CustomColors.warningColor,
            ),
          ),
        ]),
      ),
    );
  }

  _payment() {
    ///获取报告价格 无引用
    PayManager.getReportPrice(2, (price) {
      if (Golbal.isWX == true) {
        PayWXMiniProgramClass.price = price;
        PayWXMiniProgramClass.reportType = 2;
        PayWXMiniProgramClass.toPay(PaymentFromType.paymentFromSeachType);
      } else {
        PayCheakstandPage page = PayCheakstandPage(
          displayType: PaymentListDisplayType.paymentListAllDisplay,
          fromType: PaymentFromType.paymentFromSeachType,
          price: price,
          reportType: 2,
        );
        page.packet = {
          "idCard": idStr,
          "idCardName": nameStr,
          "phone": phoneStr
        };
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      }
    });
  }
}
