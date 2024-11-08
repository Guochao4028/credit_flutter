import 'dart:async';
import 'dart:io';

import 'package:credit_flutter/manager/back_check_company_manager.dart';
import 'package:credit_flutter/models/back_check_company_list_model.dart';
import 'package:credit_flutter/pages/modules/company/company_ranking_new_page.dart';
import 'package:credit_flutter/pages/modules/company/exam_reminder/exam_reminder_page.dart';
import 'package:credit_flutter/pages/modules/company/new_company_details.dart';
import 'package:credit_flutter/pages/modules/company/report_page.dart';
import 'package:credit_flutter/pages/modules/company/search/search_page.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/public_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../define/define_keys.dart';
import '../../../../utils/log.dart';
import '../salary_evaluation/salary_evaluation_page.dart';
import 'views/company_home_view.dart';

/// *
/// -  @Date: 2022-08-12 14:53
/// -  @LastEditTime: 2022-08-12 14:56
/// -  @Description: 背调公司首页
///
class BackToneCompanyPage extends StatefulWidget {
  const BackToneCompanyPage({Key? key}) : super(key: key);

  @override
  State<BackToneCompanyPage> createState() => _BackToneCompanyPageState();
}

class _BackToneCompanyPageState extends State<BackToneCompanyPage>
    implements CompanyHomeViewListener, ClickListener {
  DateTime now = DateTime.now();

  CompanyBackgroundCheckView? view;

  //综合排名
  List<BackCheckCompanyListItemModel> comprehensiveRankingList = [];

  //公司列表
  List<BackCheckCompanyListItemModel> companyList = [];

  //综合排名["综合排名", "点评", "评分"]
  List<Map<String, dynamic>> screeningList = [
    {
      "title": "综合排名",
      "isSelected": true,
      "isHidden": true,
      "id": "1",
      "isRepeat": false,
      "direction": "",
      "type": 1,
    },
    {
      "title": "点评",
      "isSelected": false,
      "isHidden": true,
      "id": "2",
      "isRepeat": false,
      "direction": "",
      "type": 3,
    },
    {
      "title": "评分",
      "isSelected": false,
      "isHidden": false,
      "id": "3",
      "isRepeat": true,
      "direction": "a",
      "type": 1,
    },
  ];

  Map<String, dynamic> currentScreening = {
    "title": "综合排名",
    "isSelected": true,
    "isHidden": true,
    "id": "1",
    "isRepeat": false,
    "direction": "",
    "type": 1,
  };

  double expandedHeight = 0.0;

  ///滚动监听设置
  final ScrollController _scrollController = ScrollController();

  /// 头部搜索栏隐藏
  bool isHidden = true;

  bool isScreeningHidden = true;

  bool _isLoding = false;
  bool _isRefreshing = false;
  String loadingText = "加载中.....";
  bool _isLoadMore = true;

  //当前页
  int currentPage = 0;

  //每页多少条
  int pageSize = 10;

  //总条数
  int total = 0;

  PageController? _pageController;
  Timer? _timer;

  var current = 0;

  @override
  void initState() {
    super.initState();
    Log.e("name---BackToneCompanyPage");

    _initUI();
    _reminderPopup();
    _pageController = PageController(
      viewportFraction: 1,
      initialPage: 0,
    );
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    closeTimer();
  }

  @override
  Widget build(BuildContext context) {
    double statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Listener(
        child: view!.homeView(
          statusHeight,
          _scrollController,
          isHidden,
          isScreeningHidden,
          comprehensiveRankingList,
          companyList,
          screeningList,
          _isLoadMore,
          _pageController,
        ),
      ),
    );
  }

  void _initUI() {
    view = CompanyBackgroundCheckView(clickListener: this);

    _scrollController.addListener(() {
      ///监听滚动位置设置导航栏颜色
      setState(() {
        expandedHeight = 0.0;

        double titleViewHeight = 131, feedbackHeight = 131 - 60;

        expandedHeight += titleViewHeight;
        expandedHeight += feedbackHeight;

        if (comprehensiveRankingList.isNotEmpty) {
          expandedHeight += 190;
        }
        // isHidden = _scrollController.offset > 200 ? false : true;
        isHidden = _scrollController.offset > 30 ? false : true;
        isScreeningHidden =
            _scrollController.offset > expandedHeight ? false : true;
        // if (_scrollController.position.pixels ==
        //     _scrollController.position.maxScrollExtent) {
        //   /// 加载更多操作
        //   _onLoad();
        // }
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          /// 加载更多操作
          _onLoad();
        }
      });
    });

    _initData();
  }

  void _initData() {
    currentPage = 1;
    Map<String, dynamic> pame = {
      "pageNum": currentPage,
      "pageSize": pageSize,
      "type": 1,
    };
    BackCheckCompanyManager.list(pame, (listModel) {
      setState(() {
        BackCheckCompanyListModel liModel =
            listModel as BackCheckCompanyListModel;
        total = liModel.total;
        pageSize = liModel.pageSize;
        currentPage = liModel.currentPage;
        companyList = liModel.data;
        // if (liModel.data.length > 3) {
        //   for (var i = 0; i < 3; i++) {
        //     comprehensiveRankingList.add(liModel.data[i]);
        //   }
        // }

        BackCheckCompanyManager.list({"pageNum": 1, "pageSize": 3, "type": 2},
            (cListModel) {
          BackCheckCompanyListModel liModel =
              cListModel as BackCheckCompanyListModel;
          comprehensiveRankingList.add(liModel.data[1]);
          comprehensiveRankingList.add(liModel.data.first);
          comprehensiveRankingList.add(liModel.data.last);
          setState(() {});
        });
      });
    });
  }

  /// *
  /// -  @description: 刷新
  /// -  @Date: 2022-08-18 14:03
  /// -  @parm:
  /// -  @return {*}
  ///
  Future _onRefresh() async {
    currentPage = 1;
    _isLoadMore = true;

    int type = currentScreening["type"];

    Map<String, dynamic> pame = {
      "pageNum": currentPage,
      "pageSize": pageSize,
      "type": type,
    };
    BackCheckCompanyManager.list(pame, (listModel) {
      setState(() {
        BackCheckCompanyListModel liModel =
            listModel as BackCheckCompanyListModel;
        total = liModel.total;
        pageSize = liModel.pageSize;
        currentPage = liModel.currentPage;
        companyList = liModel.data;
        if (comprehensiveRankingList.isEmpty) {
          BackCheckCompanyManager.list({"pageNum": 1, "pageSize": 3, "type": 2},
              (cListModel) {
            BackCheckCompanyListModel liModel =
                cListModel as BackCheckCompanyListModel;
            comprehensiveRankingList.add(liModel.data[1]);
            comprehensiveRankingList.add(liModel.data.first);
            comprehensiveRankingList.add(liModel.data.last);
            setState(() {});
          });
        }
      });
    });
    return "";
  }

  /// *
  /// -  @description: 加载更多
  /// -  @Date: 2022-08-18 14:03
  /// -  @parm:
  /// -  @return {*}
  ///
  Future _onLoad() async {
    int type = currentScreening["type"];
    //自定义方法执行下拉操作
    int num = companyList.length;
    if (num >= total) {
      _isLoadMore = false;
    } else {
      currentPage++;
      Map<String, dynamic> param = {
        "pageNum": currentPage,
        "pageSize": pageSize,
        "type": type,
      };
      BackCheckCompanyManager.list(param, (listModel) {
        BackCheckCompanyListModel liModel =
            listModel as BackCheckCompanyListModel;

        companyList.addAll(liModel.data);
        setState(() {});
      });
    }
    return "";
  }

  @override
  tapFeedback() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ReportPage(
          id: "1",
          type: "2",
        ),
      ),
    );
  }

  @override
  tapMore() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CompanyRnkingNewPage(),
      ),
    );
  }

  /// *
  /// -  @description: 搜索页
  /// -  @Date: 2022-08-18 14:00
  /// -  @parm:
  /// -  @return {*}
  ///
  @override
  tapSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SearchPage(),
      ),
    );
  }

  /// *
  /// -  @description: 跳转详情页
  /// -  @Date: 2022-08-18 13:59
  /// -  @parm:
  /// -  @return {*}
  ///
  @override
  tapCompanyInfo(BackCheckCompanyListItemModel model) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewCompanyDerailsPage(companyId: model.id),
      ),
    );
  }

  @override
  tapScreening(Map<String, dynamic> model) {
    String tem = model["direction"];
    int type = model["type"];
    String idStr = model["id"];

    if (tem.isNotEmpty) {
      String temId = currentScreening["id"];
      if (idStr == temId) {
        if (tem == "a") {
          tem = "d";
          type = 2;
        } else {
          tem = "a";
          type = 4;
        }
      } else {
        tem = "d";
        type = 2;
      }

      model["direction"] = tem;
      model["type"] = type;
    }

    model["isSelected"] = true;

    for (Map<String, dynamic> item in screeningList) {
      item["isSelected"] = false;
    }
    for (Map<String, dynamic> item in screeningList) {
      if (item["id"] == model["id"]) {
        item["isSelected"] = true;
        bool isRepeat = item["isRepeat"];
        if (isRepeat) {
          item["direction"] = tem;
        }
      }
    }
    currentScreening = model;
    setState(() {
      if (_scrollController.offset > expandedHeight) {
        _scrollController.animateTo(expandedHeight,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });
    _onRefresh();
  }

  @override
  refreshPull() {
    _onRefresh();
  }

  @override
  certificateReminder() {
    //证书提醒
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ExamReminderPage(),
      ),
    );
  }

  @override
  salaryEvaluation() {
    //薪资测评
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SalaryEvaluationPage(),
      ),
    );
  }

  var reminderPopup = 0;
  List<Map<String, dynamic>> reminderPopupList = [];

  void _reminderPopup() {
    var time = DateTime.now();
    now = DateTime(time.year, time.month, time.day);
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList = sp.getStringList(FinalKeys.SHARED_EVENT_REMINDER);
      if (strList != null) {
        for (var map in strList) {
          Map<String, dynamic> bean = StringTools.json2Map(map);
          var time = bean["time"] as String;
          var split = time.split("-");
          //判断是否过期
          var choice = DateTime(
              int.parse(split[0]), int.parse(split[1]), int.parse(split[2]));
          var before = now.isBefore(choice);
          var atSameMomentAs = choice.isAtSameMomentAs(now);
          var inDays = choice.difference(now).inDays;
          if ((before || atSameMomentAs) && bean["remind"] >= inDays) {
            reminderPopupList.add(bean);
          }
        }
        if (reminderPopupList.isNotEmpty) {
          var bean = reminderPopupList[reminderPopup];
          sleep(const Duration(milliseconds: 250));
          var time = bean["time"] as String;
          var split = time.split("-");
          var choice = DateTime(
              int.parse(split[0]), int.parse(split[1]), int.parse(split[2]));
          var inDays = choice.difference(now).inDays;
          var title = bean["title"];
          _showTips("距离$title还有$inDays天，提醒您记得参加考试哦", false);

          // Future(() {
          //   for (var bean in data) {}
          // });
        }
      }
    });
  }

  void _showTips(String rejectionReason, bool showFunction) {
    showDialog(
        context: context,
        builder: (context) {
          return PublicDialog(
            title: "提示",
            content: rejectionReason,
            cancelTitle: "知道了",
            showFunction: showFunction,
            clickListener: this,
          );
        });
  }

  @override
  void onCancel() {
    reminderPopup++;
    if (reminderPopup < reminderPopupList.length) {
      var bean = reminderPopupList[reminderPopup];
      sleep(const Duration(milliseconds: 250));
      var time = bean["time"] as String;
      var split = time.split("-");
      var choice = DateTime(
          int.parse(split[0]), int.parse(split[1]), int.parse(split[2]));
      var inDays = choice.difference(now).inDays;
      var title = bean["title"];
      _showTips("距离$title还有$inDays天，提醒您记得参加考试哦", false);
    }
  }

  @override
  void onConfirm() {}

  @override
  tapRankingList() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CompanyRnkingNewPage(),
      ),
    );
  }

  @override
  onPointerDown() {
    closeTimer();
  }

  @override
  onPointerUp() {
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer timer) {
        // if (current > 0) {
        //   current = 0;
        // } else {
        //   current = 1;
        // }
        current = current == 0 ? 1 : 0;
        // _pageController?.animateToPage(
        //   current,
        //   duration: const Duration(milliseconds: 650),
        //   curve: Curves.ease,
        // );
      },
    );
  }

  void closeTimer() {
    _timer?.cancel();
  }
}