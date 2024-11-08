import 'package:credit_flutter/pages/modules/company/salary_evaluation/remuneration_report_page.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../../define/define_colors.dart';
import '../../../../manager/salary_evaluation_manager.dart';
import '../../../../models/salary_evaluation_bean.dart';
import '../../../../tools/widget_tool.dart';

class SalaryEvaluationSearchPage extends StatefulWidget {
  const SalaryEvaluationSearchPage({Key? key}) : super(key: key);

  @override
  State<SalaryEvaluationSearchPage> createState() =>
      _SalaryEvaluationSearchPageState();
}

class _SalaryEvaluationSearchPageState
    extends State<SalaryEvaluationSearchPage> {
  var content = TextEditingController();

  final EasyRefreshController _controller = EasyRefreshController();

  List<SalaryEvaluationBean> totalData = [];

  //当前页
  int pageNum = 1;

  @override
  void initState() {
    //初始化主页面
    super.initState();
    // _initView();
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
      body: BaseBody(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, right: 16),
              // padding: const EdgeInsets.only(),
              decoration: const BoxDecoration(
                color: CustomColors.colorF3F3F3,
                borderRadius: BorderRadius.all(
                  Radius.circular(17.5),
                ),
              ),
              child: TextField(
                onChanged: (text) {
                  pageNum = 1;
                  _initData();
                },
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                maxLines: 1,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(50),
                ],
                controller: content,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_sharp,
                    size: 18,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                  isCollapsed: true,
                  hintText: "请输入职位名称",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: CustomColors.darkGrey,
                  ),
                ),
              ),
              // child: Row(
              //   children: [
              //     const Icon(
              //       Icons.search_sharp,
              //       size: 18,
              //     ),
              //     const SizedBox(
              //       width: 6,
              //     ),
              //   ],
              // ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: EasyRefresh(
                header: WidgetTools().getClassicalHeader(),
                footer: WidgetTools().getClassicalFooter(),
                controller: _controller,
                onRefresh: () async {
                  pageNum = 1;
                  _initData();
                },
                onLoad: () async {
                  pageNum++;
                  _initData();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var data = totalData[index];
                    return WidgetTools().salaryQuerySearchItem(context, data,
                        () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RemunerationReportPage(
                            labelId: data.id.toString(),
                          ),
                        ),
                      );
                    });
                  },
                  itemCount: totalData.length,
                  shrinkWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initData() {
    Map<String, dynamic> map = {
      "pageNum": pageNum,
      "pageSize": 10,
      "content": content.text.toString(),
    };
    SalaryEvaluationManager.getSalarySearch(map, (list) {
      if (pageNum == 1) {
        _controller.finishRefresh();
        _controller.resetLoadState();
        totalData.clear();
      }
      totalData.addAll(list as List<SalaryEvaluationBean>);
      if (totalData.length >= (pageNum * 10)) {
        // 没有更多
        _controller.finishLoad(success: true, noMore: true);
      } else {
        _controller.finishLoad(success: true, noMore: false);
      }
      setState(() {});
    });
  }
}
