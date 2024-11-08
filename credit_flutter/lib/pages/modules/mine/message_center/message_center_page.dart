// import 'dart:html';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/message_center_manager.dart';
import 'package:credit_flutter/models/message_center_bean.dart';
import 'package:credit_flutter/pages/modules/mine/asset/asset_management_page.dart';
import 'package:credit_flutter/pages/modules/mine/vip/vip_page.dart';
import 'package:credit_flutter/pages/modules/report/report_details_page.dart';
import 'package:credit_flutter/pages/root/root_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class MessageCenterPage extends StatefulWidget {
  int quantity;

  MessageCenterPage({Key? key, required this.quantity}) : super(key: key);

  @override
  State<MessageCenterPage> createState() => _MessageCenterPageState();
}

class _MessageCenterPageState extends State<MessageCenterPage> {
  int quantity = 0;

//1=全部、2=未读、3=已读
  int type = 1;

  //当前页
  int currentPage = 1;

  //每页多少条
  int pageSize = 10;

  List<Data> dataList = [];

  final EasyRefreshController _controller = EasyRefreshController();
  bool isSwitch = false;

  @override
  void initState() {
    //初始化主页面
    super.initState();
    quantity = widget.quantity;
    _initView();
  }

  void _initView() {
    String read = "";

    if (type == 1) {
      read = "";
    } else if (type == 2) {
      read = "0";
    } else if (type == 3) {
      read = "1";
    }
    Map<String, dynamic> param = {
      "pageNum": currentPage,
      "pageSize": pageSize,
      "read": read,
      // "hideLoading": true,
    };
    MessageCenterManager.getMessage(param, (object) {
      MessageCenterBean bean = object as MessageCenterBean;
      setState(() {
        if (isSwitch) {
          isSwitch = false;
          dataList.addAll(bean.data);
        } else {
          if (currentPage == 1) {
            _controller.finishRefresh();
            _controller.resetLoadState();
            dataList.clear();
          }
          dataList.addAll(bean.data);
          if (dataList.length >= bean.total) {
            // 没有更多
            _controller.finishLoad(success: true, noMore: true);
          } else {
            _controller.finishLoad(success: true, noMore: false);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorF1F4F9,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1B7CF6),
        titleSpacing: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          alignment: Alignment.centerRight,
          color: Colors.white,
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          "消息中心",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Container(
                  height: 35,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      addTab("全部", 1),
                      addTab("未读", 2),
                      addTab("已读", 3),
                    ],
                  ),
                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  MessageCenterManager.messageReadAll((str) {
                    setState(() {
                      quantity = 0;
                      for (var i = 0; i < dataList.length; i++) {
                        dataList[i].readStatus = 1;
                      }
                    });
                  });
                },
                child: Row(
                  children: const [
                    SizedBox(
                      width: 10,
                    ),
                    Image(
                      image: AssetImage("assets/images/icon_eliminate.png"),
                      height: 18,
                      width: 18,
                    ),
                    Text(
                      " 全部已读",
                      style:
                          TextStyle(color: CustomColors.darkGrey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          _buildList(),
        ],
      ),
    );
  }

  Widget addTab(String name, int item) {
    Color bgColor;
    Color textColor;

    if (item == type) {
      bgColor = CustomColors.connectColor;
      textColor = Colors.white;
    } else {
      bgColor = Colors.white;
      textColor = CustomColors.darkGrey;
    }

    String num = "";
    if (quantity > 99) {
      num = "99+";
    } else {
      num = quantity.toString();
    }

    var row = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            height: 12,
            margin: const EdgeInsets.only(top: 2),
            padding:
                const EdgeInsets.only(left: 2, top: 0, right: 2, bottom: 0),
            // constraints: const BoxConstraints(
            //   minWidth: 12,
            // ),
            decoration: const BoxDecoration(
              color: Color(0xFFFF4444),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    num,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                  ),
                ),
              ],
            )),
        const SizedBox(width: 8),
      ],
    );

    return Expanded(
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          isSwitch = true;
          dataList.clear();
          type = item;
          currentPage = 1;
          setState(() {
            _initView();
          });
        },
        child: Stack(
          children: [
            Container(
              height: 35,
              decoration: ShapeDecoration(
                color: bgColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(17.5),
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ),
            ),
            if (item == 2 && quantity > 0) row
          ],
        ),
      ),
    );
  }

  void jumpOperation(Data data) {
    switch (data.type) {
      case 1:
        //报告详情
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReportDetailsPage(
              reportAuthId: data.businessId.toString(),
              reportType: 2,
            ),
          ),
        );
        break;
      case 2:
      case 3:
        // 已拒绝
        if (data.businessId > 0) {
          //拒绝
          Golbal.currentIndex = 3;
          Golbal.reportId = data.businessId.toString();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RootPage(
                        pageNumber: 1,
                        isCertigier: true,
                      )),
              (route) => route == null);
        } else {
          ToastUtils.showMessage("无报告ID");
        }
        break;
      case 4:
      case 8:
      case 9:
        if (data.businessId > 0) {
          //已授权
          Golbal.currentIndex = 1;
          Golbal.reportId = data.businessId.toString();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RootPage(
                        pageNumber: 1,
                        isCertigier: true,
                      )),
              (route) => route == null);
        } else {
          ToastUtils.showMessage("无报告ID");
        }
        break;
      case 14:
        if (data.businessId > 0) {
          //已授权
          Golbal.currentIndex = 4;
          Golbal.reportId = data.businessId.toString();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RootPage(
                        pageNumber: 1,
                        isCertigier: true,
                      )),
              (route) => route == null);
        } else {
          ToastUtils.showMessage("无报告ID");
        }
        break;
      case 5:
        //资产管理
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AssetManagementPage(),
          ),
        );
        break;
      case 6:
      case 7:
        //vip页面
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const VipPageWidget(),
          ),
        );
        break;
      case 11:
        if (data.businessId > 0) {
          //拒绝
          Golbal.currentIndex = 3;
          Golbal.reportId = data.businessId.toString();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RootPage(
                        pageNumber: 1,
                        isCertigier: true,
                      )),
              (route) => route == null);
        } else {
          ToastUtils.showMessage("无报告ID");
        }
        break;
      case 10:
      case 12:
        if (data.businessId > 0) {
          //已授权
          Golbal.currentIndex = 1;
          Golbal.reportId = data.businessId.toString();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RootPage(
                        pageNumber: 1,
                        isCertigier: true,
                      )),
              (route) => route == null);
        } else {
          ToastUtils.showMessage("无报告ID");
        }
        break;
      case 13:
      //个人首页
    }
  }

  Widget _buildList() {
    if (dataList.isEmpty) {
      return Expanded(
          child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 90),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: const [
                Image(
                  image: AssetImage("assets/images/icon_report_default.png"),
                  width: 247,
                  height: 135,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "暂无内容",
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.darkGrey,
                  ),
                )
              ],
            ),
          ),
        ],
      ));
    } else {
      return Expanded(
        child: EasyRefresh(
          header: WidgetTools().getClassicalHeader(),
          footer: WidgetTools().getClassicalFooter(),
          controller: _controller,
          onRefresh: () async {
            currentPage = 1;
            _initView();
          },
          onLoad: () async {
            currentPage++;
            _initView();
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemBuilder: (context, index) {
              var data = dataList[index];
              return WidgetTools().newsItem(context, data, () {
                jumpOperation(data);
                StatefulWidget? page;
                if (data.readStatus == 0) {
                  MessageCenterManager.messageRead(data.id.toString(), (str) {
                    setState(() {
                      data.readStatus = 1;
                      quantity--;
                    });
                  });
                }
              }, () {
                MessageCenterManager.deleteOrder([data.id.toString()], (str) {
                  setState(() {
                    dataList.remove(data);
                  });
                });
              });
            },
            itemCount: dataList.length,
          ),
        ),
      );
    }
  }
}
