// import 'dart:html';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/version_manager.dart';
import 'package:credit_flutter/models/project_switch_model.dart';
import 'package:credit_flutter/pages/modules/mine/about/contact_us_page.dart';
import 'package:credit_flutter/pages/modules/report/new_report_details_sample_page.dart';
import 'package:credit_flutter/pages/modules/scan_code/scan_code_page.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/views/back_to_top.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/flutter_native_utils.dart';

import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/toast_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

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
import '../../../news/news_details.dart';
import '../../../pay/pay_payment/pay_checkstand_page.dart';
import 'over_scroll_behavior.dart';

class TemporaryCompanyIndexPage extends StatefulWidget {
  const TemporaryCompanyIndexPage({Key? key}) : super(key: key);

  @override
  State<TemporaryCompanyIndexPage> createState() =>
      _TemporaryCompanyIndexPageState();
}

class _TemporaryCompanyIndexPageState extends State<TemporaryCompanyIndexPage>
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

  ScrollController controller = ScrollController(keepScrollOffset: false);

  final GlobalKey _checkKey = GlobalKey();
  final GlobalKey _exampleKey = GlobalKey();

  var changeColor = false;

  var noMore = true;
  bool isInputUM = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (noMore) {
        if (controller.position.pixels >=
            controller.position.maxScrollExtent - (76 * 3)) {
          noMore = false;
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

    var connectivity = Connectivity();
    connectivity.checkConnectivity().then((result) {
      if (result != ConnectivityResult.none) {
        _initSwitch();
        _initData();
        NativeUtils.toolsMethodChannelMethodWithParams("APPAscribe", params: {
          "context": "APPAscribe",
        }).then((value) {});
      } else {
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          if (result != ConnectivityResult.none) {
            _initSwitch();
            _initData();
            NativeUtils.toolsMethodChannelMethodWithParams("APPAscribe",
                params: {
                  "context": "APPAscribe",
                }).then((value) {});
          }
        });
      }
    });
    var box = Hive.box(HiveBoxs.dataBox);
    isInputUM = box.get(FinalKeys.FIRST_OPEN_REPORT_SAMPLE) ?? false;
    UmengCommonSdk.onPageStart("company_home_page");
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    UmengCommonSdk.onPageEnd("company_home_page");
  }

  AppBar _getAppBar() {
    return AppBar(
      elevation: 0,
      titleSpacing: 0.0,
      centerTitle: true,
      backgroundColor: CustomColors.color021EC9,
      title: Text(
        FinalKeys.environment ? '慧眼查' : '慧眼查-测试',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
      // actions: [
        // InkWell(
        //   onTap: () {
        //     /// 登录后 企业首页 扫一扫
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return const ScanCodePage();
        //         },
        //       ),
        //     );
        //   },
        //   highlightColor: Colors.transparent,
        //   splashColor: Colors.transparent,
        //   child: const Image(
        //     image: AssetImage("assets/images/icon_scan_code.png"),
        //     width: 30,
        //     height: 30,
        //   ),
        // ),
        // const SizedBox(
        //   width: 18,
        // ),
      // ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: BaseBody(
        child: Stack(
          children: [
            const Column(
              children: [
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
                            // String jsonStr = Golbal.token;
                            // if (jsonStr.isNotEmpty) {

                            UmengCommonSdk.onEvent("RiskRemediation", {
                              "location": "companyIndex",
                            });

                            jumpMember();
                            cancelFocus();
                            // } else {
                            //   WidgetTools().showNotLoggedIn(context);
                            //   UmengCommonSdk.onEvent(
                            //       "ViewMembershipBenefits", {"type": "count"});
                            // }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                // image: AssetImage("assets/images/vipIcon.png"),
                                image: AssetImage(
                                    "assets/images/usButtonIcon.png"),
                                color: Colors.white,
                                width: 11,
                                height: 11,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                '风险修复',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
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
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Offstage(
                          offstage: Golbal.isSampleReport,
                          child: Container(
                            width: double.infinity,
                            // padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(
                                left: 16, top: 10, right: 16, bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: CustomColors.lightBlue,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return NewReportDetailsSamplePage();
                                    },
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        "assets/images/icon_baogaoyangli_look.png"),
                                    width: 45,
                                    height: 45,
                                  ),
                                  //
                                  Text(
                                    '点击查看报告样例',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 14, bottom: 14),
                          width: double.infinity,
                          height: 50,
                          child: const Center(
                            child: Image(
                              image: AssetImage(
                                  "assets/images/icon_home_check.jpg"),
                            ),
                          ),
                        ),
                        promptContainer,
                        inputTextFiled(
                          "请输入被查询人姓名",
                          "assets/images/nameIcon.png",
                          textNameController,
                          nameInputFormatterList,
                          TextInputType.text,
                        ),
                        addErrorPrompt(nameErrorStr),
                        inputTextFiled(
                          "请输入被查询人身份证号",
                          "assets/images/idIcon.png",
                          textIdController,
                          idInputFormatterList,
                          TextInputType.text,
                        ),
                        addErrorPrompt(idErrorStr),
                        inputTextFiled(
                            "请输入被查询人手机号",
                            "assets/images/phoneIcon.png",
                            textPhoneController,
                            phoneInputFormatterList,
                            TextInputType.number),
                        addErrorPrompt(phoneErrorStr),
                        promptInfoContainer,
                        Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 14,
                            bottom: 14,
                          ),
                          child: MaterialButton(
                            color: CustomColors.lightBlue,
                            textColor: Colors.white,
                            minWidth: ScreenTool.screenWidth - 32 - 32,
                            height: 49,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              var logOn =
                                  Golbal.token.isNotEmpty ? "已登录" : "未登录";
                              UmengCommonSdk.onEvent('enterprise_click_query', {
                                'data':
                                    'idCardName:$nameStr、idCard:$idStr、phone:$phoneStr、logOn:$logOn'
                              });

                              ///验证输入的合法性
                              if (determineLegal()) {
                                String jsonStr = Golbal.token;
                                if (jsonStr.isNotEmpty) {
                                  ///查询报告
                                  selecedInfo(context);
                                } else {
                                  // Golbal.isStorage = true;
                                  // WidgetTools().showNotLoggedIn(context);

                                  /// 调用未登录支付
                                  _loginOutPayment();
                                }
                              }
                            },
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "立即查询 ￥99",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "￥199",
                                  style: TextStyle(
                                    color: CustomColors.whiteBFColor,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _classifiedInformationView(),
                _sample(),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                      ),
                      height: 50,
                      width: double.infinity,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image:
                                AssetImage("assets/images/icon_left_line.png"),
                            width: 52,
                            height: 3,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            '精选内容',
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

            ///返回顶部按钮，传入控制器
            BackToTop(
              controller,
              bottom: 150,
            ),
          ],
        ),
      ),
    );
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
        name = "社会不良";
        break;
      case 5:
        icon = "icon_home_item5";
        name = "专业证书";
        break;
      case 6:
        icon = "icon_home_item6";
        name = "工商信息";
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
              return const PopupWindowDialog(
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
              return const PopupWindowDialog(
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

  _payment({
    PaymentFromType fromType = PaymentFromType.paymentFromSeachType,
    PaymentListDisplayType displayType =
        PaymentListDisplayType.paymentListAllDisplay,
  }) {
    if (isInputUM == true) {
      UmengCommonSdk.onEvent(
          "SeeReportSamplePurchaseLaterBuy", {"type": "count"});
    }

    ///获取报告价格 公司首页
    PayManager.getReportPrice(2, (price) {
      ///获取报告订阅价格
      PayManager.getReportPrice(4, (yearPrice) {
        PayCheakstandPage page = PayCheakstandPage(
          displayType: displayType,
          fromType: fromType,
          price: price,
          reportType: 2,
          yearPrice: yearPrice,
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
      });
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
        noMore = true;
        _controller.finishLoad(noMore: false);
      } else {
        noMore = false;
        _controller.finishLoad(noMore: true);
      }
      setState(() {});
    });
  }

  Widget addExample() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return NewReportDetailsSamplePage();
              },
            ),
          );
        },
        child: const Center(
          child: Text(
            '查看完整报告样例',
            style: TextStyle(
              fontSize: 12.0,
              color: CustomColors.connectColor,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 1,
            ),
          ),
        ),
      ),
    );
  }

  void jumpMember() {
    // UserModel.getInfo(
    //   (model) {
    //     if ((model!.userInfo.owner == 1)) {
    //       StateType type = model!.userInfo.companyInfo.getVerifiedStatus();
    //       if (type != StateType.success) {
    //         jumpMemberPopWidget(type, context);
    //         return;
    //       }
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const VipPageWidget(),
    //         ),
    //       );
    //     } else {
    //       ToastUtils.showMessage("您的账号为子账号，目前不能进行");
    //     }
    //   },
    // );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ContactUsPage(),
      ),
    );
  }

  void jumpMemberPopWidget(StateType verifiedStateType, BuildContext context) {
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
          },
        );
        break;
      case StateType.waiting:

        /// 认证中
        showDialog(
          context: context,
          builder: (context) {
            return const PopupWindowDialog(
              title: "认证中",
              confirm: "知道了",
              content: "您的企业认证信息正在认证请等待审核",
              contentImage: "assets/images/waiting.png",
              showCancel: false,
              identity: "0",
            );
          },
        );
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
          },
        );
    }
  }

  void cancelFocus() {
    phoneFocusNode.unfocus();
    nameFocusNode.unfocus();
    idFocusNode.unfocus();
  }

  Widget inputTextFiled(
      String hintText,
      String iconPath,
      TextEditingController textEditingController,
      List<TextInputFormatter> inputFormatters,
      TextInputType inputType) {
    InputDecoration decoration = InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(0),
      isCollapsed: true,
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
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
        if (isInputUM == true) {
          UmengCommonSdk.onEvent("SeeReportSamplePurchaseLaterInput",
              {"location": "companyIndex", "content": str});
        }
      },
      inputFormatters: inputFormatters,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: inputType,
      decoration: decoration,
    );

    return Container(
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
      margin: const EdgeInsets.only(
        left: 16,
        top: 12,
        right: 16,
      ),
      padding: const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(iconPath),
            width: 20,
            height: 20,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: textField,
          ),
        ],
      ),
    );
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

  ///*输入请输入真实信息以确保搜索的准确性
  Widget promptContainer = Column(
    children: [
      Container(
        margin: const EdgeInsets.only(left: 16),
        child: const Text(
          "*请输入真实信息以确保搜索的准确性",
          style: TextStyle(fontSize: 12, color: CustomColors.bgRedColor),
        ),
      ),
    ],
  );

  Widget _classifiedInformationView() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(width: 1, color: CustomColors.connectColor),
          borderRadius: BorderRadius.circular((8.0)),
        ),
        padding:
            const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 10),
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _item("icon_flow_report_purchase", "报告购买"),
                _arrow(),
                _item("icon_flow_identity_authentication", "身份认证"),
                _arrow(),
                _item("icon_flow_send_message", "发送授权短信"),
                _arrow(),
                _item("icon_flow_candidate_authorization", "候选人授权"),
                _arrow(),
                _item("icon_flow_report_delivery", "报告交付"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String image, String name) {
    return Column(
      children: [
        Image(
          image: AssetImage("assets/images/$image.png"),
          width: 25,
          height: 25,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _sample() {
    return SliverToBoxAdapter(
      child: Container(
        key: _exampleKey,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return NewReportDetailsSamplePage();
                },
              ),
            );
          },
          child: const Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("assets/images/icon_left_line.png"),
                      width: 52,
                      height: 3,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      '查看完整样例',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: CustomColors.color1B7CF6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Image(
                      image: AssetImage("assets/images/icon_right_line.png"),
                      width: 52,
                      height: 3,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Image(
                  image: AssetImage("assets/images/icon_yangli.png"),
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Image(
                        image: AssetImage("assets/images/icon_home_item1.png"),
                        width: 18,
                        height: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '学历信息',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Image(
                        image: AssetImage("assets/images/icon_home_item2.png"),
                        width: 18,
                        height: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '专业证书信息',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage("assets/images/icon_home_item3.png"),
                        width: 18,
                        height: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '司法信息',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ],
                  )),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Image(
                        image: AssetImage("assets/images/icon_home_item4.png"),
                        width: 18,
                        height: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '金融风险',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Image(
                        image: AssetImage("assets/images/icon_home_item5.png"),
                        width: 18,
                        height: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '个人工商信息',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        image: AssetImage("assets/images/icon_home_item6.png"),
                        width: 18,
                        height: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '社会不良',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ],
                  )),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _arrow() {
    return const Icon(
      Icons.arrow_right_alt,
      color: CustomColors.darkGrey,
      size: 18,
    );
  }

  void _initSwitch() {
    VersionManager.projectSwitch((object) {
      var model = object as ProjectSwitchModel;
      for (var a in model.data) {
        switch (a.id) {
          case 1:
            Golbal.isSampleReport = a.status == 0;
            break;
          case 2:
            Golbal.bottomReport = a.status == 1;
            break;
          case 3:
            Golbal.reportOrder = a.status;
            break;
        }
      }
      setState(() {});
    });
  }

  /// -  @description: 未登录支付逻辑
  /// -  @Date: 2023-08-28 13:48
  /// -  @parm:
  /// -  @return {*}
  ///
  void _loginOutPayment() {
    /// 1. 先判断是否存在临时身份
    /// 有临时身份沿用临时身份的token
    /// 没有临时身份分配临时身份
    UserModel.getTempUserInfo((model) {
      if (model != null) {
        _payment(
          fromType: PaymentFromType.paymentFromQuickBuyType,
          displayType: PaymentListDisplayType.paymentListOnlyOtherDisplay,
        );
      } else {
        LoginManager.userGuestLogin((message) {
          _payment(
            fromType: PaymentFromType.paymentFromQuickBuyType,
            displayType: PaymentListDisplayType.paymentListOnlyOtherDisplay,
          );
        });
      }
    });
  }
}
