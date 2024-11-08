import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../../define/define_enums.dart';
import '../../../../../manager/pay_manager.dart';
import '../../../../../models/user_model.dart';
import '../../../../../tools/global.dart';
import '../../../../../tools/string_tool.dart';
import '../../../../../utils/popup_window.dart';
import '../../../../../utils/regex_utils.dart';
import '../../../mine/enterprise_info/enterprise_info_page.dart';
import '../../../pay/pay_payment/pay_checkstand_page.dart';
import '../../../report/report_details_example_page.dart';

class VerticalQueryPage extends StatefulWidget {
  final int type;

  const VerticalQueryPage({Key? key, required this.type}) : super(key: key);

  @override
  State<VerticalQueryPage> createState() => _VerticalQueryPageState();
}

class _VerticalQueryPageState extends State<VerticalQueryPage>
    implements ClickListener {
  ///处理手机号
  final textPhoneController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();

  ///处理姓名
  final textNameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  ///处理身份证
  final textIdController = TextEditingController();
  FocusNode idFocusNode = FocusNode();

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

  ///当前选中
  int currentlySelected = 0;

  List<TextInputFormatter> nameInputFormatterList = [
    FilteringTextInputFormatter.deny(
      RegExp(
          "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"),
    ),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getTitle(),
                style: const TextStyle(
                  fontSize: 17.0,
                  color: CustomColors.greyBlack,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: getColor(),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Stack(
                children: [
                  getTopBg(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 204,
                        padding:
                            const EdgeInsets.only(left: 16, top: 30, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getTopTitle(),
                            const SizedBox(
                              height: 7,
                            ),
                            getTopContent(),
                            const SizedBox(
                              height: 9,
                            ),
                            Container(
                              width: 143,
                              height: 5,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFFFFFFFF),
                                    Color(0x05ffffff),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReportDetailsExamplePage(),
                                  ),
                                );
                              },
                              child: getTopSample(),
                            )
                          ],
                        ),
                      ),
                      getSpeedOfProgress(),
                      contentInputBox(),
                      addExplain(),
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }

  // void cancelFocus() {
  //   phoneFocusNode.unfocus();
  //   nameFocusNode.unfocus();
  //   idFocusNode.unfocus();
  // }

  String getTitle() {
    switch (widget.type) {
      case 1:
        return "个人报告";
      case 2:
        return "求职报告";
      case 3:
        return "婚恋报告";
      default:
        return "";
    }
  }

  Decoration getColor() {
    switch (widget.type) {
      case 1:
        return const BoxDecoration(
          color: Color(0xFF1B7CF6),
        );
      case 2:
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3AB3FB),
              Color(0xFF1B7CF6),
            ],
          ),
        );
      case 3:
        return const BoxDecoration(
          color: Color(0xFFFA7F86),
        );
      default:
        return const BoxDecoration(
          color: Colors.white,
        );
    }
  }

  getTopTitle() {
    String title = "";
    switch (widget.type) {
      case 1:
        title = "个人数据报告查询";
        break;
      case 2:
        title = "职员背景信息调查";
        break;
      case 3:
        title = "婚恋情况分析报告";
        break;
      default:
        title = "";
        break;
    }
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  getTopContent() {
    String content1 = "";
    String content2 = "";
    switch (widget.type) {
      case 1:
        content1 = "多维度数据一目了然";
        content2 = "及时了解他人风险";
        break;
      case 2:
        content1 = "入职信息早查询";
        content2 = "职场风险早避免";
        break;
      case 3:
        content1 = "多维度数据一目了然";
        content2 = "及时了解他人风险";
        break;
      default:
        content1 = "婚恋隐患早知道";
        content2 = "有效杜绝虚假资料";
        break;
    }
    return Column(
      children: [
        Text(
          content1,
          style: const TextStyle(
            fontSize: 13.0,
            color: Colors.white,
          ),
        ),
        Text(
          content2,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  getTopSample() {
    switch (widget.type) {
      case 1:
      case 2:
        return Container(
          width: 97,
          height: 32,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFF5C441),
                Color(0xFFF28B3C),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                image: AssetImage("assets/images/icon_sample_report.png"),
                width: 19,
                height: 19,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "报告样例",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      case 3:
        return Container(
          width: 97,
          height: 32,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                image: AssetImage("assets/images/icon_sample_report_red.png"),
                width: 19,
                height: 19,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "报告样例",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xFFFF6C84),
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  getTopBg() {
    switch (widget.type) {
      case 1:
        return Container(
          height: 204,
          padding: const EdgeInsets.only(left: 16, top: 30, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Image(
                image: AssetImage("assets/images/icon_verticals_1.png"),
                width: 157,
              ),
            ],
          ),
        );
      case 2:
        return Container(
          height: 204,
          padding: const EdgeInsets.only(left: 16, top: 30, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Image(
                image: AssetImage("assets/images/icon_verticals_2.png"),
                width: 197,
              ),
            ],
          ),
        );
      case 3:
        return Container(
          height: 204,
          padding: const EdgeInsets.only(left: 16, top: 30, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Image(
                image: AssetImage("assets/images/icon_verticals_3.png"),
                width: 175,
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  getSpeedOfProgress() {
    Color bgColor = Colors.white;
    Color txtColor = Colors.white;
    String arrow = "icon_blue_arrow";

    switch (widget.type) {
      case 1:
        bgColor = const Color(0xFFEBF1FD);
        txtColor = const Color(0xFF4194FC);
        arrow = "icon_blue_arrow";
        break;
      case 2:
        bgColor = const Color(0xFFEBF1FD);
        txtColor = const Color(0xFF4194FC);
        arrow = "icon_blue_arrow";
        break;
      case 3:
        bgColor = const Color(0xFFFDEBEB);
        txtColor = const Color(0xFFFF6C84);
        arrow = "icon_red_arrow";
        break;
    }
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      height: 51,
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "输入信息",
                style: TextStyle(
                  fontSize: 13.0,
                  color: txtColor,
                ),
              ),
            ),
          ),
          Image(
            image: AssetImage("assets/images/$arrow.png"),
            width: 28,
            height: 18,
          ),
          Expanded(
            child: Center(
              child: Text(
                "查询授权",
                style: TextStyle(
                  fontSize: 13.0,
                  color: txtColor,
                ),
              ),
            ),
          ),
          Image(
            image: AssetImage("assets/images/$arrow.png"),
            width: 28,
            height: 18,
          ),
          Expanded(
            child: Center(
              child: Text(
                "生成报告",
                style: TextStyle(
                  fontSize: 13.0,
                  color: txtColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  contentInputBox() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.only(top: 19, bottom: 19),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          inputTextFiled(
            "请输入被查询人的身份证号",
            "assets/images/idIcon.png",
            textIdController,
            idInputFormatterList,
            TextInputType.text,
          ),
          const SizedBox(
            height: 15,
          ),
          inputTextFiled(
            "请输入被查询人的姓名",
            "assets/images/nameIcon.png",
            textNameController,
            nameInputFormatterList,
            TextInputType.text,
          ),
          const SizedBox(
            height: 15,
          ),
          inputTextFiled(
              "请输入被查询人的手机号",
              "assets/images/phoneIcon.png",
              textPhoneController,
              phoneInputFormatterList,
              TextInputType.number),
          addTips(),
          submitButton(),
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
      isCollapsed: true,
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
    );

    TextField textField = TextField(
      autofocus: false,
      controller: textEditingController,
      inputFormatters: inputFormatters,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: inputType,
      decoration: decoration,
    );

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 12),
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
      child: Row(
        children: [
          Image(
            image: AssetImage(iconPath),
            width: 18,
            height: 18,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(child: textField),
        ],
      ),
    );
  }

  addTips() {
    Color txtColor = Colors.white;

    switch (widget.type) {
      case 1:
        txtColor = const Color(0xFF1B7CF6);
        break;
      case 2:
        txtColor = const Color(0xFF1B7CF6);
        break;
      case 3:
        txtColor = const Color(0xFFFF6C84);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(left: 16, top: 11, right: 16, bottom: 15),
      child: Text(
        "*请输入真实信息以确保查询的准确性，当输入完要查询人的手机号，对方将收到验证短信授权后才可看到报告",
        style: TextStyle(
          fontSize: 13.0,
          color: txtColor,
        ),
      ),
    );
  }

  submitButton() {
    Color bgColor = Colors.white;

    switch (widget.type) {
      case 1:
        bgColor = const Color(0xFF1B7CF6);
        break;
      case 2:
        bgColor = const Color(0xFF1B7CF6);
        break;
      case 3:
        bgColor = const Color(0xFFFF6C84);
        break;
    }
    return InkWell(
      onTap: () {
        submit();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        height: 45,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: const Center(
          child: Text(
            "查询",
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  addExplain() {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
      padding: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "说明",
            style: TextStyle(
              fontSize: 12.0,
              color: CustomColors.darkGrey,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: Text(
              "1、为了确保是本人授权，需要本人来进行人脸识别，通过后才可以查询。\n2、严格遵守监管要求，您的个人信息会进行加密处理。\n3、恪守保密原则，未经过您的授权，不会将个人信息透露给任何的第三方。\n4、请注意保护好您的个人隐私信息，避免他人使用您的个人信息造成不良伤害。",
              style: TextStyle(
                fontSize: 12.0,
                color: CustomColors.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submit() {
    if (!verifyId()) {
      ToastUtils.showMessage(idErrorStr);
      return;
    }
    if (!verifyName()) {
      ToastUtils.showMessage(nameErrorStr);
      return;
    }
    if (!verifyPhone()) {
      ToastUtils.showMessage(phoneErrorStr);
      return;
    }
    String jsonStr = Golbal.token;
    if (jsonStr.isNotEmpty) {
      verificationInfo(context);
    } else {
      WidgetTools().showNotLoggedIn(context);
    }
  }

  bool verifyId() {
    bool flag = true;
    if (idStr.isEmpty) {
      idErrorStr = "请输入被查询人的身份证号";
      flag = false;
      return flag;
    }
    Map map = StringTools.verifyCardId(idStr);
    flag = map["state"];
    if (flag == false) {
      idErrorStr = map["message"];
    }
    return flag;
  }

  bool verifyName() {
    bool flag = true;
    if (StringTools.isEmpty(nameStr)) {
      nameErrorStr = "请确认被查询人的姓名";
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

  bool verifyPhone() {
    bool flag = true;
    if (phoneStr.isEmpty) {
      phoneErrorStr = "手机号不能为空";
      flag = false;
    }
    if (!RegexUtils.verifyPhoneNumber(phoneStr)) {
      phoneErrorStr = "请输入正确手机号";
      flag = false;
    }
    return flag;
  }

  void verificationInfo(BuildContext context) {
    /// 获取用户信息
    UserModel.getInfo(
      (model) {
        StateType verifiedStateType =
            model!.userInfo.companyInfo.getVerifiedStatus();
        popWidget(verifiedStateType, context);
      },
    );
  }

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
        // 认证失败
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
        // 认证中
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
        // 未认证
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

  _payment() {
    ///获取报告价格 无引用
    PayManager.getReportPrice(2, (price) {
      PayCheakstandPage page = PayCheakstandPage(
        displayType: PaymentListDisplayType.paymentListAllDisplay,
        fromType: PaymentFromType.paymentFromSeachType,
        price: price,
        reportType: 2,
      );
      page.packet = {"idCard": idStr, "idCardName": nameStr, "phone": phoneStr};
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    });
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> map) {
    String title = map["title"];
    if (title == "去认证") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const EnterpriseInfoPage(),
        ),
      );
    }
  }
}
