import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/pages/modules/company/exam_reminder/appointment_reminder_page.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../define/define_colors.dart';
import '../../../../tools/string_tool.dart';
import 'edit_reminder_page.dart';

class ExamReminderPage extends StatefulWidget {
  const ExamReminderPage({Key? key}) : super(key: key);

  @override
  State<ExamReminderPage> createState() => _ExamReminderPageState();
}

class _ExamReminderPageState extends State<ExamReminderPage> {
  //置顶
  Map<String, dynamic>? top;

  //没过期
  List<Map<String, dynamic>> notExpired = [];

  //过期
  List<Map<String, dynamic>> expired = [];

  //集合
  List<Map<String, dynamic>> all = [];

  //当前时间
  DateTime now = DateTime.now();

  @override
  void initState() {
    //初始化主页面
    super.initState();
    var time = DateTime.now();

    now = DateTime(time.year, time.month, time.day);
    _initView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.lightGreyFB,
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
          "考试提醒",
          style: TextStyle(
            color: CustomColors.greyBlack,
            fontSize: 17,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const AppointmentReminderPage(),
                ),
              )
                  .then((value) {
                if (value != null) {
                  _initView();
                }
              });
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
      body: Column(
        children: [
          addTop(),
          Expanded(
            child: addBody(),
          ),
        ],
      ),
    );
  }

  Widget addBody() {
    if (all.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) {
          var data = all[index];
          return WidgetTools().examReminderItem(context, data, now, () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => EditReminderPage(
                  type: 2,
                  keyID: data["key"],
                ),
              ),
            )
                .then((value) {
              if (value != null) {
                _initView();
              }
            });
          });
        },
        itemCount: all.length,
        shrinkWrap: true,
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 85),
        width: double.infinity,
        child: Column(
          children: const [
            Image(
              image: AssetImage("assets/images/icon_reminder_default.png"),
              width: 242,
              height: 186,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "暂无添加考试内容",
              style: TextStyle(
                fontSize: 16,
                color: CustomColors.darkGrey,
              ),
            )
          ],
        ),
      );
    }
  }

  void _initView() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList = sp.getStringList(FinalKeys.SHARED_EVENT_REMINDER);
      all.clear();
      notExpired.clear();
      expired.clear();
      if (strList != null) {
        top = null;
        for (var map in strList) {
          Map<String, dynamic> bean = StringTools.json2Map(map);
          var time = bean["time"] as String;
          var split = time.split("-");
          var choice = DateTime(
              int.parse(split[0]), int.parse(split[1]), int.parse(split[2]));
          var atSameMomentAs = now.isAtSameMomentAs(choice);
          var before = now.isBefore(choice);
          if (bean["topping"]) {
            //是否在choice之后 false
            if (before || atSameMomentAs) {
              //没过期
              top = bean;
            } else {
              //过期了
              top = null;
              expired.add(bean);
            }
          } else {
            //判断是否过期
            if (before || atSameMomentAs) {
              //当前
              notExpired.add(bean);
            } else {
              //过期
              expired.add(bean);
            }
          }
        }

        notExpired.sort(((a, b) {
          var aSplit = a["time"].split("-");
          var aChoice = DateTime(
              int.parse(aSplit[0]), int.parse(aSplit[1]), int.parse(aSplit[2]));

          var bSplit = b["time"].split("-");
          var bChoice = DateTime(
              int.parse(bSplit[0]), int.parse(bSplit[1]), int.parse(bSplit[2]));
          if (aChoice.isBefore(bChoice)) {
            return -1;
          } else {
            return 1;
          }
        }));
        all.addAll(notExpired);
        expired.sort(((a, b) {
          var aSplit = a["time"].split("-");
          var aChoice = DateTime(
              int.parse(aSplit[0]), int.parse(aSplit[1]), int.parse(aSplit[2]));

          var bSplit = b["time"].split("-");
          var bChoice = DateTime(
              int.parse(bSplit[0]), int.parse(bSplit[1]), int.parse(bSplit[2]));
          if (aChoice.isBefore(bChoice)) {
            return 1;
          } else {
            return -1;
          }
        }));
        all.addAll(expired);
      }
      setState(() {});
    });
  }

  addTop() {
    if (top != null) {
      var key = top!["key"];
      var title = top!["title"];
      var time = top!["time"];
      var split = time.split("-");
      var choice = DateTime(
          int.parse(split[0]), int.parse(split[1]), int.parse(split[2]));
      var inDays = choice.difference(now).inDays;

      return InkWell(
        onTap: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => EditReminderPage(
                type: 2,
                keyID: key,
              ),
            ),
          )
              .then((value) {
            if (value != null) {
              _initView();
            }
          });
        },
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              const SizedBox(
                width: 23,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: CustomColors.greyBlack,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "目标日期：$time",
                      style: const TextStyle(
                        color: CustomColors.darkGrey99,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$inDays",
                style: const TextStyle(
                  color: CustomColors.greyBlack,
                  fontSize: 90,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 5, top: 2, right: 5, bottom: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: CustomColors.connectColor,
                ),
                child: const Text(
                  "Days",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
