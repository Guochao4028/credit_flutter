/// *
/// -  @Date: 2023-09-04 18:26
/// -  @LastEditTime: 2023-09-04 18:29
/// -  @Description: 综合页面 公司
///

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/news_manager.dart';
import 'package:credit_flutter/manager/version_manager.dart';
import 'package:credit_flutter/models/faq_model.dart';
import 'package:credit_flutter/models/news_details_model.dart';
import 'package:credit_flutter/models/news_list_model.dart';
import 'package:credit_flutter/models/project_switch_model.dart';
import 'package:credit_flutter/pages/modules/home/pages/company_page/over_scroll_behavior.dart';
import 'package:credit_flutter/pages/modules/home/pages/index_synthesis/views/index_synthesis_company_disk_view.dart';
import 'package:credit_flutter/pages/modules/home/pages/index_synthesis/views/index_synthesis_company_faq_view.dart';
import 'package:credit_flutter/pages/modules/report/new_report_details_sample_page.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/views/back_to_top.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/flutter_native_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class IndexSynthesisCompanyView extends StatefulWidget {
  IndexSynthesisCompanyViewListener? listener;

  IndexSynthesisCompanyView({Key? key, this.listener}) : super(key: key);

  @override
  State<IndexSynthesisCompanyView> createState() =>
      _IndexSynthesisCompanyViewState();
}

class _IndexSynthesisCompanyViewState extends State<IndexSynthesisCompanyView> {
  IndexSynthesisCompanyViewListener? _listener;

  ///处理姓名
  final textNameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  ///处理身份证
  final textIdController = TextEditingController();
  FocusNode idFocusNode = FocusNode();

  ///名字错误信息
  String nameErrorStr = "";

  ///身份证号错误信息
  String idErrorStr = "";

  ///名字信息
  String nameStr = "";

  ///身份证号信息
  String idStr = "";

  ///当前步骤
  int step = 1;

  ///当前选中
  int currentlySelected = 0;

  bool isOne = true;

  bool isTwo = false;

  bool isThree = false;

  List faqList = [];

  List<TextInputFormatter> nameInputFormatterList = [
    FilteringTextInputFormatter.deny(
      RegExp(
          "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"),
    ),
    LengthLimitingTextInputFormatter(20),
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
    _listener = widget.listener;
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
        _initFAQ();
        _initData();
        NativeUtils.toolsMethodChannelMethodWithParams("APPAscribe", params: {
          "context": "APPAscribe",
        }).then((value) {});
      } else {
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          if (result != ConnectivityResult.none) {
            _initSwitch();
            _initFAQ();
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
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenTool.screenHeight,
      width: ScreenTool.screenWidth,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              scrollBehavior: OverScrollBehavior(),
              controller: controller,
              slivers: [
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
                            margin: const EdgeInsets.only(
                                left: 16, top: 10, right: 16, bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: CustomColors.lightBlue,
                            ),
                            child: InkWell(
                              onTap: () {
                                _listener?.sampleReport();
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
                              UmengCommonSdk.onEvent('NotLoggedInputInfo', {
                                'data':
                                    'idCardName:$nameStr、idCard:$idStr、logOn:$logOn'
                              });

                              ///检查登录状态
                              ///1，没登录去登录
                              ///2，登录 正常逻辑
                              // String loginToken = Golbal.token;
                              // if (loginToken.isEmpty) {
                              //   WidgetTools().showNotLoggedIn(context);
                              // } else {
                                ///验证输入的合法性
                                if (determineLegal()) {
                                  _listener?.purchasingEmployerReport({
                                    "idCard": idStr,
                                    "idCardName": nameStr,
                                  });
                                }
                              // }
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
                      _listener?.tapNews(newsData);
                    });
                  }, childCount: newsList.length),
                ),
              ],
            ),
          ),

          ///返回顶部按钮，传入控制器
          BackToTop(
            controller,
            bottom: 150,
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

  void cancelFocus() {
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
        idErrorStr = "";
        setState(() {});

        if (textEditingController == textNameController) {
          nameStr = str;
        } else if (textEditingController == textIdController) {
          idStr = str;
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
  ///
  bool determineLegal() {
    bool flag = true;
    if (!verifyName()) {
      flag = false;
    } else if (!verifyId()) {
      flag = false;
    }

    setState(() {});
    return flag;
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
    return const SliverToBoxAdapter(child: IndexSynthesisCompanyDiskView());
  }

  Widget _sample() {
    return SliverToBoxAdapter(
      child: Container(
        // height: 560,
        key: _exampleKey,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),

        child: IndexSynthesisCompanyFAQView(
          faqList: faqList,
        ),
      ),
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

  void _initFAQ() {
    VersionManager.getFAQ((list) {
      FAQModel model = list[0];
      model.isSeleced = true;
      faqList = list;
      setState(() {});
    });
  }
}

abstract class IndexSynthesisCompanyViewListener {
  /// *
  /// -  @description: 查看报告样例
  /// -  @Date: 2023-09-07 10:28
  ///
  void sampleReport();

  /// *
  /// -  @description: 购买雇主报告
  /// -  @Date: 2023-09-07 10:52
  ///
  void purchasingEmployerReport(Map<String, dynamic> map);

  /// *
  /// -  @description: 查看精选内容 ， 详情
  /// -  @Date: 2023-09-07 10:28
  ///
  void tapNews(NewsDetailsModel newsModel);
}
