import 'dart:collection';

import 'package:credit_flutter/manager/salary_evaluation_manager.dart';
import 'package:credit_flutter/pages/modules/company/salary_evaluation/remuneration_report_page.dart';
import 'package:credit_flutter/pages/modules/company/salary_evaluation/salary_evaluation_search_page.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';

import '../../../../define/define_colors.dart';
import '../../../../models/salary_evaluation_bean.dart';

class SalaryEvaluationPage extends StatefulWidget {
  const SalaryEvaluationPage({Key? key}) : super(key: key);

  @override
  State<SalaryEvaluationPage> createState() => _SalaryEvaluationPageState();
}

class _SalaryEvaluationPageState extends State<SalaryEvaluationPage> {
  List<SalaryEvaluationBean> totalData = [];
  List<SalaryEvaluationBean> oneLevel = [];

  bool isOne = false;

  bool isTwo = false;
  List<SalaryEvaluationBean> twoLevel = [];

  bool isThree = false;
  List<SalaryEvaluationBean> threeLevel = [];

  @override
  void initState() {
    //初始化主页面
    super.initState();
    _initView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          alignment: Alignment.centerRight,
          color: CustomColors.greyBlack,
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          "选择职位",
          style: TextStyle(
            color: CustomColors.greyBlack,
            fontSize: 17,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            children: const [
              SizedBox(
                width: 16,
              ),
              Text(
                "请选择职位类型",
                style: TextStyle(
                  color: CustomColors.greyBlack,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SalaryEvaluationSearchPage(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              height: 40,
              padding: const EdgeInsets.only(left: 18),
              decoration: const BoxDecoration(
                color: CustomColors.colorF3F3F3,
                borderRadius: BorderRadius.all(
                  Radius.circular(17.5),
                ),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.search_sharp,
                    size: 18,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    "请输入职位名称",
                    style: TextStyle(
                      color: CustomColors.darkGrey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      itemBuilder: (context, index) {
                        var data = oneLevel[index];
                        return WidgetTools()
                            .salaryQueryItem(context, data.label1, isOne, () {
                          isOne = true;

                          twoLevel.clear();
                          isTwo = true;
                          HashMap<String, SalaryEvaluationBean> two = HashMap();
                          for (var bean in totalData) {
                            if (bean.label1 == data.label1) {
                              two[bean.label2] = bean;
                            }
                          }
                          two.forEach((key, value) {
                            twoLevel.add(value);
                          });

                          threeLevel.clear();
                          isThree = true;

                          twoLevel[0].isSelect = true;

                          for (var bean in totalData) {
                            if (bean.label2 == twoLevel[0].label2) {
                              threeLevel.add(bean);
                            }
                          }

                          setState(() {});

                          // isThree = true;
                        });
                      },
                      itemCount: oneLevel.length,
                      shrinkWrap: true,
                    ),
                    Visibility(
                      maintainSize: false,
                      visible: isOne,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          isOne = false;

                          twoLevel.clear();
                          isTwo = false;
                          threeLevel.clear();
                          isThree = false;
                          setState(() {});
                        },
                        child: Container(
                          color: const Color(0x80000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                maintainSize: false,
                visible: isTwo,
                child: Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xFFF6F5FA),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        var data = twoLevel[index];
                        return WidgetTools().salaryQueryTwoItem(context, data,
                            () {
                          for (var mmp in twoLevel) {
                            mmp.isSelect = false;
                          }
                          data.isSelect = true;

                          threeLevel.clear();
                          isThree = true;
                          for (var bean in totalData) {
                            if (bean.label2 == data.label2) {
                              threeLevel.add(bean);
                            }
                          }

                          setState(() {});
                        });
                      },
                      itemCount: twoLevel.length,
                      shrinkWrap: true,
                    ),
                  ),
                ),
              ),
              Visibility(
                maintainSize: false,
                visible: isThree,
                child: Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var data = threeLevel[index];
                      return WidgetTools()
                          .salaryQueryThreeItem(context, data.name, () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RemunerationReportPage(
                              labelId: data.id.toString(),
                            ),
                          ),
                        );
                      });
                    },
                    itemCount: threeLevel.length,
                    shrinkWrap: true,
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  //  @JsonKey(name: 'id')
  //   int id;
  //
  //   @JsonKey(name: 'label1')
  //   String label1;
  //
  //   @JsonKey(name: 'label2')
  //   String label2;
  //
  //   @JsonKey(name: 'name')
  //   String name;

  void _initView() {
    SalaryEvaluationManager.getSalaryLabelList((list) {
      HashMap<String, SalaryEvaluationBean> one = HashMap();
      for (var bean in list) {
        totalData.add(bean);
        one[bean.label1] = bean;
      }
      one.forEach((key, value) {
        oneLevel.add(value);
      });
      Log.i("---${oneLevel.length}");
      setState(() {});
    });
  }
}
