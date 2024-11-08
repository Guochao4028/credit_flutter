import 'dart:async';
import 'dart:io';

import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../define/define_colors.dart';
import 'edit_reminder_page.dart';

class AppointmentReminderPage extends StatefulWidget {
  const AppointmentReminderPage({Key? key}) : super(key: key);

  @override
  State<AppointmentReminderPage> createState() =>
      _AppointmentReminderPageState();
}

//定义回调
typedef MyCallBack = Function();

//回调监听
class MyCallBackListener {
  final MyCallBack myCallBack;

  MyCallBackListener({required this.myCallBack});
}

class _AppointmentReminderPageState extends State<AppointmentReminderPage> {
  GlobalKey current = GlobalKey();
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    int month = now.month;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          alignment: Alignment.centerRight,
          color: CustomColors.greyBlack,
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          "预约提醒",
          style: TextStyle(
            color: CustomColors.greyBlack,
            fontSize: 17,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditReminderPage(
                    type: 1,
                    keyID: -1,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                  color: CustomColors.greyBlack,
                  size: 22,
                ),
                Text(
                  "添加",
                  style: TextStyle(
                    color: CustomColors.greyBlack,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 18,
          ),
        ],
      ),
      body: Container(
        color: CustomColors.lightGreyFB,
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var data = dataList[index];
                  return WidgetTools().appointmentReminderItem(
                    context,
                    index,
                    month,
                    current,
                    data,
                    MyCallBackListener(myCallBack: () {
                      setState(() {});
                    }),
                  );
                },
                itemCount: dataList.length,
                shrinkWrap: true,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  List<Map<String, dynamic>> list = [];
                  for (var outer in dataList) {
                    var data = outer["data"];
                    for (var inner in data) {
                      var isCheck = inner["isCheck"];
                      if (isCheck) {
                        list.add(inner);
                      }
                    }
                  }
                  if (list.isEmpty) {
                    ToastUtils.showMessage("请至少选择一项");
                    return;
                  }
                  for (var use in list) {
                    var time = use["time"] as String;
                    var split = time.split("-");
                    var choice = DateTime(
                        now.year, int.parse(split[0]), int.parse(split[1]));
                    //是否在choice之后 false
                    var after = now.isBefore(choice);
                    if (after) {
                      use["time"] =
                          "${choice.year}-${choice.month}-${choice.day}";
                    } else {
                      //加一年
                      use["time"] =
                          "${choice.year + 1}-${choice.month}-${choice.day}";
                    }
                  }
                  _saveData(list).then((value) {
                    ToastUtils.showMessage("保存成功");
                    Navigator.of(context).pop("success");
                  });
                },
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: CustomColors.connectColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(24.0),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 50, top: 8, right: 50, bottom: 8),
                    child: const Text(
                      "提交",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> addView(int month) {
    List<Widget> viewList = [];
    for (int index = 0; index < dataList.length; index++) {
      var data = dataList[index];
      var appointmentReminderItem = WidgetTools().appointmentReminderItem(
        context,
        index + 1,
        month,
        current,
        data,
        MyCallBackListener(myCallBack: () {
          setState(() {});
        }),
      );
      viewList.add(appointmentReminderItem);
    }
    return viewList;
  }

  Future<String> _saveData(List<Map<String, dynamic>> list) async {
    await EasyLoading.show();
    List<String> dataList = [];
    for (var data in list) {
      sleep(const Duration(milliseconds: 5));
      var title = data["name"] as String;
      var time = data["time"] as String;
      var dateTime = DateTime.now();
      Map<String, dynamic> newsMap = {
        "key": dateTime.millisecondsSinceEpoch,
        "title": title,
        "time": time,
        "topping": false,
        "remind": 3,
      };
      dataList.add(StringTools.map2Json(newsMap));
    }
    saveDataModel(dataList);
    await EasyLoading.dismiss();
    return "成功";
  }

  void saveDataModel(List<String> dataList) {
    Log.d("---saveDataModel");
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList = sp.getStringList(FinalKeys.SHARED_EVENT_REMINDER);
      strList ??= [];
      strList.addAll(dataList);
      sp.setStringList(FinalKeys.SHARED_EVENT_REMINDER, strList);
    });
  }

  List<Map<String, dynamic>> dataList = [
    {
      "month": "一月",
      "data": [
        {
          "name": "广东公务员考试",
          "time": "01-03",
          "isCheck": false,
        },
        {
          "name": "托福",
          "time": "01-05",
          "isCheck": false,
        },
        {
          "name": "雅思(IELTS)",
          "time": "01-08",
          "isCheck": false,
        },
        {
          "name": "自学考试",
          "time": "01-08",
          "isCheck": false,
        },
        {
          "name": "2021年下半年中小学教师资格考试(面试)",
          "time": "01-08",
          "isCheck": false,
        },
        {
          "name": "GRE考试(9号)",
          "time": "01-09",
          "isCheck": false,
        },
        {
          "name": "GRE考试(23号)",
          "time": "01-23",
          "isCheck": false,
        },
        {
          "name": "GRE考试(27号)",
          "time": "01-27",
          "isCheck": false,
        },
      ],
    },
    {
      "month": "二月",
      "data": [
        {
          "name": "雅思(IELTS)",
          "time": "02-12",
          "isCheck": false,
        },
        {
          "name": "GRE考试(18号)",
          "time": "02-18",
          "isCheck": false,
        },
        {
          "name": "GRE考试(26号)",
          "time": "02-26",
          "isCheck": false,
        },
        {
          "name": "托福(19号)",
          "time": "02-19",
          "isCheck": false,
        },
        {
          "name": "托福(20号)",
          "time": "02-20",
          "isCheck": false,
        },
        {
          "name": "证券从业(云)考试",
          "time": "02-26",
          "isCheck": false,
        },
      ],
    },
    {
      "month": "三月",
      "data": [
        {
          "name": "托福",
          "time": "03-02",
          "isCheck": false,
        },
        {
          "name": "雅思(IELTS)",
          "time": "03-03",
          "isCheck": false,
        },
        {
          "name": "2022年上半年中小学教师资格考试(笔试)",
          "time": "03-12",
          "isCheck": false,
        },
        {
          "name": "基金从业(预约式)",
          "time": "03-12",
          "isCheck": false,
        },
        {
          "name": "GRE考试(13号)",
          "time": "03-13",
          "isCheck": false,
        },
        {
          "name": "GRE考试(19号)",
          "time": "03-19",
          "isCheck": false,
        },
        {
          "name": "公共英语",
          "time": "03-19",
          "isCheck": false,
        },
        {
          "name": "文物保护工程从业资格",
          "time": "03-26",
          "isCheck": false,
        },
        {
          "name": "计算机等级考试",
          "time": "03-26",
          "isCheck": false,
        },
      ],
    },
    {
      "month": "四月",
      "data": [
        {
          "name": "托福",
          "time": "04-03",
          "isCheck": false,
        },
        {
          "name": "雅思(IELTS)",
          "time": "04-09",
          "isCheck": false,
        },
        {
          "name": "咨询工程师(投资 9号)",
          "time": "04-09",
          "isCheck": false,
        },
        {
          "name": "咨询工程师(投资 10号)",
          "time": "04-10",
          "isCheck": false,
        },
        {
          "name": "初级护师(9号)",
          "time": "04-09",
          "isCheck": false,
        },
        {
          "name": "初级护师(10号)",
          "time": "04-10",
          "isCheck": false,
        },
        {
          "name": "卫生资格(9号)",
          "time": "04-09",
          "isCheck": false,
        },
        {
          "name": "卫生资格(10号)",
          "time": "04-10",
          "isCheck": false,
        },
        {
          "name": "卫生资格(16号)",
          "time": "04-16",
          "isCheck": false,
        },
        {
          "name": "卫生资格(17号)",
          "time": "04-17",
          "isCheck": false,
        },
        {
          "name": "主管护师(9号)",
          "time": "04-09",
          "isCheck": false,
        },
        {
          "name": "主管护师(10号)",
          "time": "04-10",
          "isCheck": false,
        },
        {
          "name": "主管护师(16号)",
          "time": "04-16",
          "isCheck": false,
        },
        {
          "name": "主管护师(17号)",
          "time": "04-17",
          "isCheck": false,
        },
        {
          "name": "基金从业(第一次统考)",
          "time": "04-16",
          "isCheck": false,
        },
        {
          "name": "自学考试",
          "time": "04-16",
          "isCheck": false,
        },
        {
          "name": "专八考试",
          "time": "04-23",
          "isCheck": false,
        },
        {
          "name": "执业护士(23号)",
          "time": "04-23",
          "isCheck": false,
        },
        {
          "name": "专八考试(24号)",
          "time": "04-24",
          "isCheck": false,
        },
        {
          "name": "GRE考试(24号)",
          "time": "04-24",
          "isCheck": false,
        },
        {
          "name": "GRE考试(29号)",
          "time": "04-29",
          "isCheck": false,
        },
      ],
    },
    {
      "month": "五月",
      "data": [
        {
          "name": "托福",
          "time": "05-04",
          "isCheck": false,
        },
        {
          "name": "雅思(IELTS)",
          "time": "05-07",
          "isCheck": false,
        },
        {
          "name": "BEC初级",
          "time": "05-14",
          "isCheck": false,
        },
        {
          "name": "监理工程师(14号)",
          "time": "05-14",
          "isCheck": false,
        },
        {
          "name": "监理工程师(15号)",
          "time": "05-15",
          "isCheck": false,
        },
        {
          "name": "2022年上半年中小学教师资格考试(笔试 14号)",
          "time": "05-14",
          "isCheck": false,
        },
        {
          "name": "2022年上半年中小学教师资格考试(笔试 15号)",
          "time": "05-15",
          "isCheck": false,
        },
        {
          "name": "注册建筑师(14号)",
          "time": "05-14",
          "isCheck": false,
        },
        {
          "name": "注册建筑师(15号)",
          "time": "05-15",
          "isCheck": false,
        },
        {
          "name": "注册建筑师(21号)",
          "time": "05-21",
          "isCheck": false,
        },
        {
          "name": "注册建筑师(22号)",
          "time": "05-22",
          "isCheck": false,
        },
        {
          "name": "BEC高级",
          "time": "05-21",
          "isCheck": false,
        },
        {
          "name": "银行专业资格考试",
          "time": "05-21",
          "isCheck": false,
        },
        {
          "name": "BEC中级",
          "time": "05-28",
          "isCheck": false,
        },
        {
          "name": "期货从业资格考试",
          "time": "05-28",
          "isCheck": false,
        },
        {
          "name": "GRE考试",
          "time": "05-28",
          "isCheck": false,
        },
        {
          "name": "房地产经纪人(28号)",
          "time": "05-28",
          "isCheck": false,
        },
        {
          "name": "房地产经纪人(29号)",
          "time": "05-29",
          "isCheck": false,
        },
        {
          "name": "注册核安全工程师(28号)",
          "time": "05-28",
          "isCheck": false,
        },
        {
          "name": "注册核安全工程师(29号)",
          "time": "05-29",
          "isCheck": false,
        },
        {
          "name": "计算机等级考试",
          "time": "05-28",
          "isCheck": false,
        },
        {
          "name": "软件水平考试(28号)",
          "time": "05-28",
          "isCheck": false,
        },
        {
          "name": "软件水平考试(29号)",
          "time": "05-29",
          "isCheck": false,
        },
        {
          "name": "证券从业(专场)考试",
          "time": "05-28",
          "isCheck": false,
        },
      ],
    },
    {
      "month": "六月",
      "data": [
        {
          "name": "雅思(IELTS)",
          "time": "06-04",
          "isCheck": false,
        },
        {
          "name": "托福",
          "time": "06-04",
          "isCheck": false,
        },
        {
          "name": "GRE考试(5号)",
          "time": "06-05",
          "isCheck": false,
        },
        {
          "name": "GRE考试(18号)",
          "time": "06-18",
          "isCheck": false,
        },
        {
          "name": "高考",
          "time": "06-07",
          "isCheck": false,
        },
        {
          "name": "四六级考试",
          "time": "06-11",
          "isCheck": false,
        },
        {
          "name": "注册计量师(一级、二级)11号",
          "time": "06-11",
          "isCheck": false,
        },
        {
          "name": "注册计量师(一级、二级)12号",
          "time": "06-12",
          "isCheck": false,
        },
        {
          "name": "机动车检测维修士、机动车检测维修工程师(11号)",
          "time": "06-11",
          "isCheck": false,
        },
        {
          "name": "机动车检测维修士、机动车检测维修工程师(12号)",
          "time": "06-12",
          "isCheck": false,
        },
        {
          "name": "执业医师考试",
          "time": "06-13",
          "isCheck": false,
        },
        {
          "name": "临床执业医师",
          "time": "06-13",
          "isCheck": false,
        },
        {
          "name": "临床助理医师",
          "time": "06-13",
          "isCheck": false,
        },
        {
          "name": "经济师(高级)",
          "time": "06-18",
          "isCheck": false,
        },
        {
          "name": "社会工作者考试(18号)",
          "time": "06-18",
          "isCheck": false,
        },
        {
          "name": "社会工作者考试(19号)",
          "time": "06-19",
          "isCheck": false,
        },
        {
          "name": "一、二、三级翻译资格(18号)",
          "time": "06-18",
          "isCheck": false,
        },
        {
          "name": "一、二、三级翻译资格(19号)",
          "time": "06-19",
          "isCheck": false,
        },
        {
          "name": "公路水运工程助理试验检测师、试验检测师(18号)",
          "time": "06-18",
          "isCheck": false,
        },
        {
          "name": "公路水运工程助理试验检测师、试验检测师(19号)",
          "time": "06-19",
          "isCheck": false,
        },
        {
          "name": "不动产登记代理人(18号)",
          "time": "06-18",
          "isCheck": false,
        },
        {
          "name": "不动产登记代理人(19号)",
          "time": "06-19",
          "isCheck": false,
        },
        {
          "name": "专四考试",
          "time": "06-19",
          "isCheck": false,
        },
      ],
    },
    {
      "month": "七月",
      "data": [
        {
          "name": "证券从业(专场)考试",
          "time": "07-02",
          "isCheck": false,
        },
        {
          "name": "证券从业(统一)考试",
          "time": "07-02",
          "isCheck": false,
        },
        {
          "name": "自学考试",
          "time": "07-02",
          "isCheck": false,
        },
        {
          "name": "托福",
          "time": "07-03",
          "isCheck": false,
        },
        {
          "name": "雅思(IELTS)",
          "time": "07-07",
          "isCheck": false,
        },
        {
          "name": "基金从业",
          "time": "07-09",
          "isCheck": false,
        },
        {
          "name": "期货从业资格考试",
          "time": "07-16",
          "isCheck": false,
        },
        {
          "name": "执业兽医",
          "time": "07-17",
          "isCheck": false,
        },
        {
          "name": "GRE考试",
          "time": "07-24",
          "isCheck": false,
        },
      ],
    },
    {
      "month": "八月",
      "data": [
        {
          "name": "雅思(IELTS)",
          "time": "08-06",
          "isCheck": false,
        },
        {
          "name": "托福",
          "time": "08-21",
          "isCheck": false,
        },
        {
          "name": "临床助理医师(第一次笔试)",
          "time": "08-19",
          "isCheck": false,
        },
        {
          "name": "执业医师考试(第一次笔试)",
          "time": "08-19",
          "isCheck": false,
        },
        {
          "name": "临床执业医师(第一次笔试)",
          "time": "08-20",
          "isCheck": false,
        },
        {
          "name": "GRE考试",
          "time": "08-26",
          "isCheck": false,
        },
        {
          "name": "注册会计师(专业阶段)",
          "time": "08-26",
          "isCheck": false,
        },
        {
          "name": "注册会计师(综合阶段)",
          "time": "08-27",
          "isCheck": false,
        },
      ],
    },
    {
      "month": "九月",
      "data": [
        {
          "name": "雅思(IELTS)",
          "time": "09-03",
          "isCheck": false,
        },
        {
          "name": "设备监理师(3号)",
          "time": "09-03",
          "isCheck": false,
        },
        {
          "name": "设备监理师(4号)",
          "time": "09-04",
          "isCheck": false,
        },
        {
          "name": "GRE考试(3号)",
          "time": "09-03",
          "isCheck": false,
        },
        {
          "name": "GRE考试(16号)",
          "time": "09-16",
          "isCheck": false,
        },
        {
          "name": "GRE考试(23号)",
          "time": "09-23",
          "isCheck": false,
        },
        {
          "name": "中级会计职称考试",
          "time": "09-03",
          "isCheck": false,
        },
        {
          "name": "托福",
          "time": "09-04",
          "isCheck": false,
        },
        {
          "name": "演出经纪人资格",
          "time": "09-17",
          "isCheck": false,
        },
        {
          "name": "法律职业资格考试(客观题)",
          "time": "09-17",
          "isCheck": false,
        },
        {
          "name": "资产评估师",
          "time": "09-17",
          "isCheck": false,
        },
        {
          "name": "注册测绘师",
          "time": "09-17",
          "isCheck": false,
        },
        {
          "name": "公共英语",
          "time": "09-17",
          "isCheck": false,
        },
        {
          "name": "精算师",
          "time": "09-17",
          "isCheck": false,
        },
        {
          "name": "期货从业资格考试",
          "time": "09-24",
          "isCheck": false,
        },
        {
          "name": "证券从业(云)考试",
          "time": "09-24",
          "isCheck": false,
        },
        {
          "name": "银行专业资格考试",
          "time": "09-24",
          "isCheck": false,
        },
        {
          "name": "注册验船师",
          "time": "09-24",
          "isCheck": false,
        },
        {
          "name": "广播电视编辑记者、播音员主持人资格",
          "time": "09-24",
          "isCheck": false,
        },
        {
          "name": "计算机等级考试",
          "time": "09-24",
          "isCheck": false,
        },
        {
          "name": "审计师",
          "time": "09-25",
          "isCheck": false,
        },
      ],
    },
    {
      "month": "十月",
      "data": [
        {
          "name": "雅思(IELTS)",
          "time": "10-08",
          "isCheck": false,
        },
        {
          "name": "托福",
          "time": "10-09",
          "isCheck": false,
        },
        {
          "name": "出版专业资格",
          "time": "10-15",
          "isCheck": false,
        },
        {
          "name": "GRE考试(10号)",
          "time": "10-10",
          "isCheck": false,
        },
        {
          "name": "GRE考试(16号)",
          "time": "10-16",
          "isCheck": false,
        },
        {
          "name": "GRE考试(23号)",
          "time": "10-23",
          "isCheck": false,
        },
        {
          "name": "法律职业资格考试(主观题)",
          "time": "10-16",
          "isCheck": false,
        },
        {
          "name": "自学考试",
          "time": "10-22",
          "isCheck": false,
        },
        {
          "name": "城乡规划师",
          "time": "10-22",
          "isCheck": false,
        },
        {
          "name": "矿业权评估师",
          "time": "10-22",
          "isCheck": false,
        },
        {
          "name": "成人高考",
          "time": "10-22",
          "isCheck": false,
        },
        {
          "name": "2022年下半年中小学教师资格考试(笔试)",
          "time": "10-29",
          "isCheck": false,
        },
        {
          "name": "基金从业",
          "time": "10-29",
          "isCheck": false,
        },
        {
          "name": "房地产经纪人",
          "time": "10-29",
          "isCheck": false,
        },
        {
          "name": "中级注册安全工程师",
          "time": "10-29",
          "isCheck": false,
        },
        {
          "name": "拍卖师(纸笔作答)",
          "time": "10-29",
          "isCheck": false,
        },
        {
          "name": "统计师",
          "time": "10-30",
          "isCheck": false,
        },
      ],
    },
    {
      "month": "十一月",
      "data": [
        {
          "name": "托福",
          "time": "11-02",
          "isCheck": false,
        },
        {
          "name": "雅思(IELTS)",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "导游资格证考试",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "执业药师考试",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "注册土木工程师(岩土、港口与航道工程、水利水电工程、道路工程)",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "电气工程师",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "注册公用设备工程师",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "注册结构工程师",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "注册化工工程师",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "注册环保工程师",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "证券从业(统一)考试",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "一级消防工程师",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "软件水平考试",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "一、二、三级翻译资格",
          "time": "11-05",
          "isCheck": false,
        },
        {
          "name": "GRE考试(6号)",
          "time": "11-06",
          "isCheck": false,
        },
        {
          "name": "GRE考试(13号)",
          "time": "11-13",
          "isCheck": false,
        },
        {
          "name": "GRE考试(26号)",
          "time": "11-26",
          "isCheck": false,
        },
        {
          "name": "一级造价工程师",
          "time": "11-12",
          "isCheck": false,
        },
        {
          "name": "房地产估价师",
          "time": "11-12",
          "isCheck": false,
        },
        {
          "name": "经济师(初中级)",
          "time": "11-12",
          "isCheck": false,
        },
        {
          "name": "临床助理医师(第二次笔试)",
          "time": "11-12",
          "isCheck": false,
        },
        {
          "name": "执业医师考试(第二次笔试)",
          "time": "11-12",
          "isCheck": false,
        },
        {
          "name": "临床执业医师(第二次笔试)",
          "time": "11-12",
          "isCheck": false,
        },
        {
          "name": "BEC高级",
          "time": "11-19",
          "isCheck": false,
        },
        {
          "name": "一级建造师",
          "time": "11-19",
          "isCheck": false,
        },
        {
          "name": "税务师",
          "time": "11-19",
          "isCheck": false,
        },
        {
          "name": "BEC初级",
          "time": "11-26",
          "isCheck": false,
        },
        {
          "name": "拍卖师(实际操作)",
          "time": "11-27",
          "isCheck": false,
        },
      ],
    },
    {
      "month": "十二月",
      "data": [
        {
          "name": "雅思(IELTS)",
          "time": "12-03",
          "isCheck": false,
        },
        {
          "name": "托福",
          "time": "12-03",
          "isCheck": false,
        },
        {
          "name": "计算机等级考试",
          "time": "12-03",
          "isCheck": false,
        },
        {
          "name": "BEC中级",
          "time": "12-03",
          "isCheck": false,
        },
        {
          "name": "GRE考试(9号)",
          "time": "12-09",
          "isCheck": false,
        },
        {
          "name": "GRE考试(18号)",
          "time": "12-18",
          "isCheck": false,
        },
        {
          "name": "GRE考试(30号)",
          "time": "12-30",
          "isCheck": false,
        },
        {
          "name": "四六级考试",
          "time": "12-17",
          "isCheck": false,
        },
      ],
    },
  ];
}
