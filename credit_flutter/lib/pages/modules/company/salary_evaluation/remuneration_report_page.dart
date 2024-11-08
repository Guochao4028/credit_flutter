import 'package:flutter/material.dart';

import '../../../../define/define_colors.dart';
import '../../../../manager/salary_evaluation_manager.dart';
import '../../../../models/remuneration_report_bean.dart';

class RemunerationReportPage extends StatefulWidget {
  String labelId;

  RemunerationReportPage({Key? key, required this.labelId}) : super(key: key);

  @override
  State<RemunerationReportPage> createState() => _RemunerationReportPageState();
}

class _RemunerationReportPageState extends State<RemunerationReportPage> {
  String title = "";
  String content = "";
  String average = "";
  List<IncomeRangeJSONArray> mmp = [];

  @override
  void initState() {
    //初始化主页面
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.color0F1531,
      appBar: AppBar(
        backgroundColor: CustomColors.color0F1531,
        elevation: 0,
        titleSpacing: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          alignment: Alignment.centerRight,
          color: Colors.white,
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          "薪酬报告",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, right: 16),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0x14FFFFFF),
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, top: 20),
            child: const Text(
              "年薪收入预估",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, top: 5),
            child: Text(
              "平均年薪  $average/年",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, top: 5),
            child: const Text(
              "年薪收入区间分布",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, top: 15, right: 16),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0x14FFFFFF),
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Column(
              children: addAllItem(),
            ),
          ),
        ],
      ),
    );
  }

  void _initData() {
    SalaryEvaluationManager.getSalaryInfo(widget.labelId, (data) {
      var bean = data as RemunerationReportBean;
      title = bean.name;
      content = bean.description;
      average = bean.salaryAvg;
      mmp.addAll(bean.incomeRangeJSONArray);
      setState(() {});
    });
  }

  List<Widget> addAllItem() {
    List<Widget> list = [];
    for (var data in mmp) {
      var rate = data.rate;
      var value = double.parse(rate.substring(0, rate.length - 1)) * 0.01;
      switch (data.rank) {
        case "1":
          list.add(
              addItem(data.content, value, CustomColors.color5F48F3, rate));
          list.add(const SizedBox(height: 18));
          break;
        case "2":
          list.add(
              addItem(data.content, value, CustomColors.color5886F5, rate));
          list.add(const SizedBox(height: 18));
          break;
        case "3":
          list.add(
              addItem(data.content, value, CustomColors.color64BEBC, rate));
          list.add(const SizedBox(height: 18));
          break;
        case "4":
          list.add(
              addItem(data.content, value, CustomColors.colorF5AF4D, rate));
          list.add(const SizedBox(height: 18));
          break;
        case "5":
          list.add(
              addItem(data.content, value, CustomColors.colorADACAD, rate));
          list.add(const SizedBox(height: 18));
          break;
      }
    }
    return list;
  }

  Widget addItem(
      String title, double percentage, Color color, String percentageName) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: percentage,
              color: color,
              backgroundColor: CustomColors.color59ECECEC,
              // valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          percentageName,
          style: TextStyle(
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
