import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../../../define/define_enums.dart';
import '../../../../../manager/news_manager.dart';
import '../../../../../manager/pay_manager.dart';
import '../../../../../models/news_details_model.dart';
import '../../../../../models/news_list_model.dart';
import '../../../../../models/user_model.dart';
import '../../../../../tools/global.dart';
import '../../../../../tools/screen_tool.dart';
import '../../../../../tools/string_tool.dart';
import '../../../../../utils/popup_window.dart';
import '../../../../../utils/regex_utils.dart';
import '../../../mine/enterprise_info/enterprise_info_page.dart';
import '../../../mine/vip/vip_page.dart';
import '../../../news/news_details.dart';
import '../../../pay/pay_payment/pay_checkstand_page.dart';
import 'over_scroll_behavior.dart';

class AgainNewCompanyIndexPage extends StatefulWidget {
  const AgainNewCompanyIndexPage({Key? key}) : super(key: key);

  @override
  State<AgainNewCompanyIndexPage> createState() =>
      _AgainNewCompanyIndexPageState();
}

class _AgainNewCompanyIndexPageState extends State<AgainNewCompanyIndexPage>
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

  ///当前步骤
  int step = 1;

  ///当前选中
  int currentlySelected = 0;

  bool isOne = true;

  bool isTwo = false;

  bool isThree = false;

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

  final EasyRefreshController _controller = EasyRefreshController();

  //当前页
  int pageNum = 1;

  List<NewsDetailsModel> newsList = [];

  ScrollController controller = ScrollController();

  final GlobalKey _checkKey = GlobalKey();
  final GlobalKey _exampleKey = GlobalKey();

  var changeColor = false;

  var noMore = true;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (noMore) {
        if (controller.position.pixels >=
            controller.position.maxScrollExtent - (76 * 3)) {
          pageNum++;
          _initData();
        }
      }
      var checkHeight = _checkKey.currentContext?.size?.height ?? 0.0;
      var exampleHeight = _exampleKey.currentContext?.size?.height ?? 0.0;
      if (controller.position.pixels >= checkHeight + exampleHeight) {
        if (!changeColor) {
          changeColor = true;
          setState(() {});
        }
      } else {
        if (changeColor) {
          changeColor = false;
          setState(() {});
        }
      }
    });
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '慧眼查',
            style: TextStyle(fontSize: 17.0, color: Colors.white),
          ),
        ),
        backgroundColor: CustomColors.color021EC9,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: const [
              SizedBox(
                height: 96,
              ),
              Image(
                image: AssetImage("assets/images/icon_home_bg_bottom.png"),
                width: double.infinity,
                height: 55,
                fit: BoxFit.fill,
              ),
            ],
          ),
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            scrollBehavior: OverScrollBehavior(),
            controller: controller,
            slivers: [
              SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    "assets/images/icon_home_bg_top.png",
                    fit: BoxFit.cover,
                  ),
                ),
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 96,
                title: SizedBox(
                  height: 96,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          String jsonStr = Golbal.token;
                          if (jsonStr.isNotEmpty) {
                            jumpMember();
                            cancelFocus();
                          } else {
                            WidgetTools().showNotLoggedIn(context);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Image(
                              image: AssetImage("assets/images/vipIcon.png"),
                              width: 11,
                              height: 11,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '会员权益',
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Color(0xFFF0BB8E),
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFFD1AB9A),
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              image: AssetImage(
                                  "assets/images/icon_logo_name.png"),
                              width: 125,
                              height: 29,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Container(
                              height: 36,
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.0),
                                color: CustomColors.colorF82522,
                              ),
                              child: const Center(
                                child: Text(
                                  '社会信用体系建设\n重 点 服 务 平 台',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  key: _checkKey,
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 15),
                  margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(
                              image: AssetImage(
                                  "assets/images/icon_home_check.png"),
                              width: 131,
                              height: 17,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        maintainSize: false,
                        visible: isOne,
                        child: inputTextFiled(
                          "请输入被查询人的身份证号",
                          textIdController,
                          idInputFormatterList,
                          TextInputType.text,
                          idFocusNode,
                        ),
                      ),
                      Visibility(
                        maintainSize: false,
                        visible: isTwo,
                        child: inputTextFiled(
                          "请确认被查询人的姓名",
                          textNameController,
                          nameInputFormatterList,
                          TextInputType.text,
                          nameFocusNode,
                        ),
                      ),
                      Visibility(
                        maintainSize: false,
                        visible: isThree,
                        child: inputTextFiled(
                          "请确认被查询人的手机号",
                          textPhoneController,
                          phoneInputFormatterList,
                          TextInputType.number,
                          phoneFocusNode,
                        ),
                      ),
                      addClew(),
                      addBut(),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  key: _exampleKey,
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      left: 16, top: 10, right: 16, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(
                              image: AssetImage(
                                  "assets/images/icon_left_line.png"),
                              width: 52,
                              height: 3,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              '报告样例',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: CustomColors.greyBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Image(
                              image: AssetImage(
                                  "assets/images/icon_right_line.png"),
                              width: 52,
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 181,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent: 86,
                          ),
                          itemCount: 6,
                          itemBuilder: (BuildContext context, int index) {
                            return _addGridViewItem(index + 1);
                          },
                        ),
                      ),
                      addExample(),
                    ],
                  ),
                ),
              ),
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 50,
                title: Container(
                  color: changeColor
                      ? const Color(0xFF2358D2)
                      : Colors.transparent,
                  height: 50,
                  width: double.infinity,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                      ),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage("assets/images/icon_left_line.png"),
                          width: 52,
                          height: 3,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          '精选公司',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: CustomColors.greyBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Image(
                          image:
                              AssetImage("assets/images/icon_right_line.png"),
                          width: 52,
                          height: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((content, index) {
                  var newsData = newsList[index];
                  return WidgetTools().showHomeNewsViewItem(context, newsData,
                      () {
                    cancelFocus();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsPage(
                          newsId: newsData.newsId,
                          type: newsData.type,
                          coverImage: newsData.coverImage,
                        ),
                      ),
                    );
                  });
                }, childCount: newsList.length),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget inputTextFiled(
      String hintText,
      TextEditingController textEditingController,
      List<TextInputFormatter> inputFormatters,
      TextInputType inputType,
      FocusNode focusNode) {
    InputDecoration decoration = InputDecoration(
      isCollapsed: true,
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
    );

    TextField textField = TextField(
      autofocus: false,
      focusNode: focusNode,
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
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
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
      child: textField,
    );
  }

  addClew() {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
      width: double.infinity,
      child: Text(
        step != 3
            ? "*请输入真实信息以确保搜索的准确性"
            : "*要查询的授权请求将以短信的方式发送到对方手机上，对方授权成功后方可看到要查询的信息。",
        style: const TextStyle(
          fontSize: 12.0,
          color: CustomColors.colorF82522,
        ),
      ),
    );
  }

  addBut() {
    var butStr = "查询";
    switch (step) {
      case 1:
        butStr = "查询";
        break;
      case 2:
        butStr = "确认姓名（2/3）";
        break;
      case 3:
        butStr = "确认";
        break;
    }
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
      width: double.infinity,
      height: 45,
      child: Row(
        children: [
          if (step != 1)
            InkWell(
              onTap: () {
                previousStep();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                width: 27,
                height: 27,
                padding: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  //设置四周圆角 角度
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  //设置四周边框
                  border: Border.all(
                    width: 1,
                    color: CustomColors.colorD2CCCC,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: CustomColors.colorD2CCCC,
                  size: 12,
                ),
              ),
            ),
          Expanded(
            child: InkWell(
              onTap: () {
                ifJudge();
              },
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: CustomColors.color1B7CF6,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Center(
                  child: Text(
                    butStr,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ifJudge() {
    switch (step) {
      case 1:
        if (verifyId()) {
          step = 2;
          isOne = false;
          isTwo = true;
          isThree = false;
        } else {
          ToastUtils.showMessage(idErrorStr);
        }
        break;
      case 2:
        if (verifyName()) {
          step = 3;
          isOne = false;
          isTwo = false;
          isThree = true;
        } else {
          ToastUtils.showMessage(nameErrorStr);
        }
        break;
      case 3:
        if (verifyPhone()) {
          String jsonStr = Golbal.token;
          if (jsonStr.isNotEmpty) {
            verificationInfo(context);
          } else {
            WidgetTools().showNotLoggedIn(context);
          }
        } else {
          ToastUtils.showMessage(phoneErrorStr);
        }
        break;
    }
    setState(() {});
  }

  previousStep() {
    switch (step) {
      case 2:
        step = 1;
        isOne = true;
        isTwo = false;
        isThree = false;
        break;
      case 3:
        step = 2;
        isOne = false;
        isTwo = true;
        isThree = false;
        break;
    }
    setState(() {});
  }

  Widget _addGridViewItem(int item) {
    String icon = "";
    String name = "";
    switch (item) {
      case 1:
        icon = "icon_home_item1";
        name = "司法风险";
        break;
      case 2:
        icon = "icon_home_item2";
        name = "身份信息";
        break;
      case 3:
        icon = "icon_home_item3";
        name = "学历信息";
        break;
      case 4:
        icon = "icon_home_item4";
        name = "工作经历";
        break;
      case 5:
        icon = "icon_home_item5";
        name = "职业风险";
        break;
      case 6:
        icon = "icon_home_item6";
        name = "职场关系";
        break;
    }
    return InkWell(
      onTap: () {
        currentlySelected = currentlySelected == item
            ? currentlySelected = 0
            : currentlySelected = item;
        cancelFocus();
        setState(() {});
      },
      child: Column(
        children: [
          Image(
            image: AssetImage("assets/images/$icon.png"),
            width: 40,
            height: 40,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 15.0,
              color: CustomColors.greyBlack,
            ),
          ),
        ],
      ),
    );
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

  /// *
  /// -  @description: 查询按钮逻辑
  /// -  @Date: 2022-06-23 10:47
  /// -  @parm:
  /// -  @return {*}
  ///
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
        // 认证失败
        showDialog(
            context: context,
            builder: (context) {
              return PopupWindowDialog(
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
              return PopupWindowDialog(
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

  void _initData() {
    Map<String, dynamic> param = {
      "pageNum": pageNum,
      "pageSize": 5,
      "type": 1,
      "hideLoading": true,
    };
    NewsManger.getNewsList(param, (listModel) {
      NewsListModel newsListModel = listModel as NewsListModel;
      newsList.addAll(newsListModel.data);
      if (newsList.length < newsListModel.total) {
        _controller.finishLoad(noMore: false);
      } else {
        noMore = false;
        _controller.finishLoad(noMore: true);
      }
      setState(() {});
    });
  }

  Widget addExample() {
    Widget currently;
    double height = 0;
    String assetImage = "";
    var width = ScreenTool.screenWidth - 62;
    switch (currentlySelected) {
      case 1:
        assetImage = "assets/images/icon_home_example1.png";
        height = width * 0.55;
        break;
      case 2:
        assetImage = "assets/images/icon_home_example2.png";
        height = width * 0.751;
        break;
      case 3:
        assetImage = "assets/images/icon_home_example3.png";
        height = width * 0.636;
        break;
      case 4:
        assetImage = "assets/images/icon_home_example4.png";
        height = width * 0.546;
        break;
      case 5:
        assetImage = "assets/images/icon_home_example5.png";
        height = width * 0.636;
        break;
      case 6:
        assetImage = "assets/images/icon_home_example6.png";
        height = width * 0.738;
        break;
    }
    if (currentlySelected != 0) {
      currently = Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: Image(
          image: AssetImage(assetImage),
          fit: BoxFit.fill,
        ),
      );
    } else {
      currently = const SizedBox();
    }
    return currently;
  }

  void jumpMember() {
    UserModel.getInfo(
      (model) {
        if ((model!.userInfo.owner == 1)) {
          StateType type = model!.userInfo.companyInfo.getVerifiedStatus();
          if (type != StateType.success) {
            jumpMemberPopWidget(type, context);
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
      },
    );
  }

  void jumpMemberPopWidget(StateType verifiedStateType, BuildContext context) {
    switch (verifiedStateType) {
      case StateType.fail:

        /// 认证失败
        showDialog(
            context: context,
            builder: (context) {
              return PopupWindowDialog(
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

  void cancelFocus() {
    phoneFocusNode.unfocus();
    nameFocusNode.unfocus();
    idFocusNode.unfocus();
  }
}
