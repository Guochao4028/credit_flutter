import 'dart:math';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/manager/report_home_manager.dart';
import 'package:credit_flutter/models/report_home_bean.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/mine/asset/asset_management_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/public_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'new_report_details_page.dart';

import 'package:material_segmented_control/material_segmented_control.dart';

/// @Description: 报告页
class CompanyReportHomePage extends StatefulWidget {
  const CompanyReportHomePage({Key? key}) : super(key: key);

  @override
  State<CompanyReportHomePage> createState() => _CompanyReportHomePageState();
}

class _CompanyReportHomePageState extends State<CompanyReportHomePage>
    implements ClickListener {
  @override
  void initState() {
    //初始化主页面
    super.initState();
    page = 1;
    status = Golbal.currentIndex;
    _initData();
  }

  //授权状态：1已授权，2未授权，3已拒绝， 4年付已授权
  int status = 1;

  //当前页
  int page = 1;

  int _currentSelection = 0;
  Map<int, Widget> _children = {
    0: Text('全部'),
    1: Text('年付'),
  };
  int reportType = 0;

  final _searchController = TextEditingController();

  List<ReportHomeDataBean> authorizeList = [];

  final _controller = EasyRefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Text(
              "报告",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  _addItemTop("assets/images/icon_authorized.png", "已授权", 1,
                      () {
                    _refreshData(1);
                  }),
                  _addItemTop(
                      "assets/images/icon_pending_authorization.png", "待授权", 2,
                      () {
                    _refreshData(2);
                  }),
                  _addItemTop("assets/images/icon_rejected1.png", "已拒绝", 3, () {
                    _refreshData(3);
                  }),
                  // _addItemTop(
                  //     "assets/images/icon_authorized_year.png", "年付已授权", 4, () {
                  //   _refreshData(4);
                  // }),
                ],
              ),
              // _addSearch(),
              const SizedBox(
                height: 10,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: CustomColors.colorF1F4F9,
                  ),
                ),
              ),
              _addSegmented(),
              Expanded(
                child: EasyRefresh(
                  header: WidgetTools().getClassicalHeader(),
                  footer: WidgetTools().getClassicalFooter(),
                  controller: _controller,
                  enableControlFinishRefresh: true,
                  enableControlFinishLoad: true,
                  onRefresh: _onRefresh,
                  onLoad: _onLoad,
                  child: _buildList(),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildList() {
    if (authorizeList.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            margin: const EdgeInsets.only(top: 31),
            width: double.infinity,
            child: Column(
              children: const [
                Image(
                  image: AssetImage("assets/images/icon_report_default.png"),
                  width: 247,
                  height: 135,
                ),
                Text(
                  "暂无内容",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.darkGrey,
                  ),
                )
              ],
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          var model = authorizeList[index];
          return WidgetTools().showReportHomeItem(context, model, () {
            if (model.authorizationStatus == 1) {
              //1.已授权
              if (model.buyStatus == 0) {
                // 0.未购买
                // buttonText = "去购买";
                PayManager.getReportPrice(model.reportType, (price) {
                  if (Golbal.isWX == true) {
                    PayWXMiniProgramClass.price = price;
                    PayWXMiniProgramClass.reportType = model.reportType;
                    PayWXMiniProgramClass.reportAuthId = model.id.toString();
                    PayWXMiniProgramClass.toPay(
                        PaymentFromType.paymentFromReportListType);
                  } else {
                    PayCheakstandPage page = PayCheakstandPage(
                      displayType: PaymentListDisplayType.paymentListAllDisplay,
                      fromType: PaymentFromType.paymentFromReportListType,
                      price: price,
                      reportType: model.reportType,
                      reportAuthId: model.id.toString(),
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => page,
                      ),
                    );
                  }
                });
              } else {
                //1.已购买
                lookReport(model.reportId.toString(), model.id.toString(),
                    model.reportType);
              }
            } else if (model.authorizationStatus == 2) {
              //2.待授权
              // buttonText = "待授权";
              _showTips("待用户同意授权后才能查看报告请，您耐心等待。", false);
            } else if (model.authorizationStatus == 3) {
              //3.已拒绝
              // buttonText = "拒绝原因";
              _showTips(model.rejectionReason, true);
            } else {
              lookReport(model.reportId.toString(), model.id.toString(),
                  model.reportType);
            }
          });
        },
        itemCount: authorizeList.length,
        shrinkWrap: true,
      );
    }
  }

  Widget _addItemTop(
      String assetName, String title, int type, GestureTapCallback callback) {
    return Expanded(
        child: InkWell(
      onTap: callback,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(width: 77, height: 79, image: AssetImage(assetName)),
          SizedBox(
            width: 70,
            height: 20,
            child: Center(
              child: Stack(
                children: [
                  Offstage(
                    offstage: !(type == status),
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 15, left: 19, right: 19),
                      decoration: const BoxDecoration(
                        color: CustomColors.colorF07F,
                        borderRadius: BorderRadius.all(
                          Radius.circular(9),
                        ),
                      ),
                      width: 36,
                      height: 5,
                    ),
                  ),
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: type == status
                            ? CustomColors.connectColor
                            : CustomColors.darkGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _addSearch() {
    Image search = const Image(
      image: AssetImage("assets/images/icon_search_one.png"),
      width: 15,
      height: 15,
    );

    return Container(
      margin: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
      width: double.infinity,
      height: 35,
      decoration: const BoxDecoration(
        color: CustomColors.colorF7F8FC,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          TextField(
            maxLines: 1,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.deny(RegExp(
                  "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"))
            ],
            controller: _searchController,
            // textInputAction: TextInputAction.search,
            onChanged: (text) {
              // if (text.isEmpty) {
              _onRefresh();
              // }
            },
            // onEditingComplete: () {
            //   if (_searchController.text.isNotEmpty) {
            //     _onRefresh();
            //   }
            // },
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
                fontSize: 14, color: CustomColors.textDarkColor),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              isCollapsed: true,
              prefixIcon: search,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 41,
              ),
              border: InputBorder.none,
              hintText: "请输入姓名",
              hintStyle:
                  const TextStyle(fontSize: 14, color: CustomColors.darkGrey99),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addSegmented() {
    return Offstage(
        offstage: status != 1,
        child: Container(
          width: double.infinity,
          child: MaterialSegmentedControl(
            children: _children,
            selectionIndex: _currentSelection,
            selectedColor: CustomColors.whiteBlueColor,
            unselectedColor: Colors.white,
            selectedTextStyle: TextStyle(color: Colors.white),

            onSegmentTapped: (int value) {
              // _currentSelection = value;
              setState(() {
                // _currentSelection = value;
                _currentSelection = value;
                if (value == 0) {
                  reportType = 0;
                } else {
                  reportType = 4;
                }
                _refreshData(1);
              });
            },
            // onSegmentTapped: (index) {
            //   setState(() {
            //     _currentSelection = index;
            // //   });
            // },
          ),
        ));
  }

  void _refreshData(int type) {
    Golbal.reportId = "";
    if (type > 1) {
      reportType = 0;
    }
    status = type;
    Golbal.currentIndex = type;
    _onRefresh();
    setState(() {});
  }

  Future _onRefresh() async {
    Golbal.reportId = "";
    page = 1;
    _initData();
  }

  Future _onLoad() async {
    Golbal.reportId = "";
    page++;
    _initData();
  }

  // 初始化数据
  void _initData() async {
    Map<String, dynamic> pame = {
      "status": status,
      "searchName": _searchController.text.toString(),
      "pageNum": page,
      "pageSize": 100,
      "id": Golbal.reportId,
      "hideLoading": true,
    };
    if (_currentSelection == 1 && status == 1) {
      pame.addAll({"reportType": 4});
    }

    ReportHomeManager.getAuthorizeList(pame, (model) {
      setState(() {
        if (page == 1) {
          authorizeList.clear();
          if (authorizeList.length < 10) {
            _controller.finishRefresh(success: true, noMore: false);
          } else {
            _controller.finishRefresh(success: true, noMore: true);
          }
          _controller.finishLoad(success: true, noMore: false);
        } else {
          if (authorizeList.length < 10) {
            _controller.finishLoad(success: true, noMore: false);
          } else {
            _controller.finishLoad(success: true, noMore: true);
          }
        }
        ReportHomeBean reportHomeBean = model as ReportHomeBean;

        authorizeList.addAll(reportHomeBean.data);
      });
    });
  }

  void _showTips(String rejectionReason, bool showFunction) {
    showDialog(
        context: context,
        builder: (context) {
          return PublicDialog(
            title: "提示",
            content: rejectionReason,
            functionTitle: "去查看",
            cancelTitle: "知道了",
            showFunction: showFunction,
            clickListener: this,
          );
        });
  }

  @override
  void onCancel() {}

  @override
  void onConfirm() {
    //资产管理
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AssetManagementPage(),
      ),
    );
  }

  void lookReport(String reportId, String authId, int reportType) {
    /// 校验账号合法性
    Golbal.checkAccount((success, userModel) {
      if (userModel != null) {
        UserInfo userInfo = userModel.userInfo;
        if (success == true) {
          ///查看报告
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => ReportDetailsPage(
          //       reportAuthId: id,
          //       reportType: reportType,
          //     ),
          //   ),
          // );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewReportDetailsPage(
                reportId: reportId,
                authId: authId,
              ),
            ),
          );
        } else {
          Navigator.pushNamed(context, "/childAccountInfo",
              arguments: {"childStatus": userInfo.childStatus});
        }
      }
      setState(() {});
    });
  }
}
