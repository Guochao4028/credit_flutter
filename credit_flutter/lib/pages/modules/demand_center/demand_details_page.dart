/// *
/// -  @Date: 2022-08-19 11:22
/// -  @LastEditTime: 2022-09-27 13:41
/// -  @Description:
///
/// *
/// -  @Date: 2022-06-16 14:24
/// -  @LastEditTime: 2022-09-19 14:02
/// -  @Description:首页
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/company/report_page.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../manager/demand_center_manager.dart';
import '../../../models/demand_details_bean.dart';

class DemandDetailsPage extends StatefulWidget {
  String id;
  String userId;

  DemandDetailsPage({Key? key, required this.id, required this.userId})
      : super(key: key);

  @override
  State<DemandDetailsPage> createState() => _DemandDetailsPageState();
}

class _DemandDetailsPageState extends State<DemandDetailsPage> {
  String _userId = "";
  String phone = "";
  String title = "";
  String budget = "";
  String days = "";
  String time = "";
  String description = "";

  @override
  void initState() {
    super.initState();

    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorEDF6F6,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "需求详情",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          InkWell(
            onTap: () {
              _launchUrl("tel:${phone}");
            },
            child: Column(
              children: const [
                Icon(
                  Icons.phone,
                  color: Colors.black,
                  size: 22,
                ),
                Text(
                  "电话",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          if (widget.userId != _userId)
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReportPage(
                          id: widget.id,
                          type: "3",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.report_gmailerrorred,
                        color: Colors.black,
                        size: 22,
                      ),
                      Text(
                        "举报",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            margin: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                addItem("需求标题", title),
                addItemSplitLine(),
                addItem("手机号", phone),
                addItemSplitLine(),
                addItem("金额预算", budget),
                addItemSplitLine(),
                addItem("时间有效期", days),
                addItemSplitLine(),
                addItem("发布时间", time),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              SizedBox(
                width: 32,
              ),
              Text(
                "需求描述",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding:
                const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 12),
            margin: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: CustomColors.darkGrey,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  addItem(String title, String content) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 10),

      // height: 46,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(
                color: CustomColors.darkGrey,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              content,
              style: const TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  addItemSplitLine() {
    return Container(
      width: double.infinity,
      height: 1,
      color: CustomColors.colorF5F5F5,
    );
  }

  // 初始化数据
  void _initData() async {
    DemandCenterManager.getDemandCenterInfo({
      "id": widget.id,
    }, (bean) {
      var data = bean as DemandDetailsBean;
      _userId = data.userId.toString();
      phone = data.phone;
      title = data.title;
      budget = data.budget > 0 ? "¥${data.budget.toInt()}" : "无";
      days = "${data.days}天";
      var createTime = DateTime.fromMillisecondsSinceEpoch(data.createTime);
      time =
          "${createTime.year}-${createTime.month}-${createTime.day} ${createTime.hour}:${createTime.minute}:${createTime.second}";
      description = data.description;
      setState(() {});
    });
  }

  Future<void> _launchUrl(String uri) async {
    if (!await launchUrl(Uri.parse(uri))) {
      throw 'Could not launch $uri';
    }
  }
}
