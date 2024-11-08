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
import 'package:credit_flutter/utils/new_popup_window.dart';
import 'package:credit_flutter/utils/public_dialog.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import 'new_report_details_page.dart';

/// @Description: 报告页
class NewCompanyReportHomePage extends StatefulWidget {
  const NewCompanyReportHomePage({Key? key}) : super(key: key);

  @override
  State<NewCompanyReportHomePage> createState() =>
      _NewCompanyReportHomePageState();
}

class _NewCompanyReportHomePageState extends State<NewCompanyReportHomePage>
    implements ClickListener {
  @override
  void initState() {
    //初始化主页面
    super.initState();
    page = 1;
    status = Golbal.currentIndex;
    _initData();
    UmengCommonSdk.onPageStart("company_authorization_list_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("company_authorization_list_page");
  }

  //授权状态：1已授权，2未授权，3已拒绝， 4年付已授权
  int status = 1;

  //当前页
  int page = 1;

  final _searchController = TextEditingController();

  List<ReportHomeDataBean> authorizeList = [];

  // final _controller = EasyRefreshController();
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //导航
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
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
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // 返回一个 Sliver 数组给外部可滚动组件。
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(),
                width: double.infinity,
                height: 77,
                child: Row(
                  children: [
                    _addItemTop("assets/images/icon_authorized.png", 1, () {
                      _refreshData(1);
                    }),
                    _addItemTop(
                        "assets/images/icon_pending_authorization.png", 2, () {
                      _refreshData(2);
                    }),
                    _addItemTop("assets/images/icon_rejected1.png", 3, () {
                      _refreshData(3);
                    }),
                    _addItemTop("assets/images/icon_authorized_year.png", 4,
                        () {
                      _refreshData(4);
                    }),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: _SliverAppBarDelegate(
                maxHeight: 90,
                minHeight: 90,
                child: Container(
                    width: double.infinity,
                    height: 90,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _addTxtItemTop("已授权", 1, () {
                              _refreshData(1);
                            }),
                            _addTxtItemTop("待授权", 2, () {
                              _refreshData(2);
                            }),
                            _addTxtItemTop("已拒绝", 3, () {
                              _refreshData(3);
                            }),
                            _addTxtItemTop("年付已授权", 4, () {
                              _refreshData(4);
                            }),
                          ],
                        ),
                        _addSearch(),
                        Container(
                          height: 10,
                          color: CustomColors.colorF1F4F9,
                        ),
                      ],
                    )),
              ),
            ),
          ];
        },
        body: EasyRefresh(
          // header: WidgetTools().getClassicalHeader(),
          // footer: WidgetTools().getClassicalFooter(),
          controller: _controller,
          // noMoreRefresh: true,
          onRefresh: _onRefresh,
          onLoad: _onLoad,
          child: _buildList(),
        ),
      ),
      // body: CustomScrollView(
      //   slivers: [
      //     SliverToBoxAdapter(
      //       child: Container(
      //         padding: const EdgeInsets.only(top: 10),
      //         width: double.infinity,
      //         height: 87,
      //         color: Colors.white,
      //         child: Row(
      //           children: [
      //             _addItemTop("assets/images/icon_authorized.png", 1, () {
      //               _refreshData(1);
      //             }),
      //             _addItemTop("assets/images/icon_pending_authorization.png", 2,
      //                 () {
      //               _refreshData(2);
      //             }),
      //             _addItemTop("assets/images/icon_rejected1.png", 3, () {
      //               _refreshData(3);
      //             }),
      //             _addItemTop("assets/images/icon_authorized_year.png", 4, () {
      //               _refreshData(4);
      //             }),
      //           ],
      //         ),
      //       ),
      //     ),
      //     SliverPersistentHeader(
      //       pinned: true,
      //       floating: true,
      //       delegate: _SliverAppBarDelegate(
      //         maxHeight: 27,
      //         minHeight: 27,
      //         child: Container(
      //           width: double.infinity,
      //           height: 27,
      //           color: Colors.white,
      //           child: Row(
      //             children: [
      //               _addTxtItemTop("已授权", 1, () {
      //                 _refreshData(1);
      //               }),
      //               _addTxtItemTop("待授权", 2, () {
      //                 _refreshData(2);
      //               }),
      //               _addTxtItemTop("已拒绝", 3, () {
      //                 _refreshData(3);
      //               }),
      //               _addTxtItemTop("年付已授权", 4, () {
      //                 _refreshData(4);
      //               }),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //     SliverToBoxAdapter(
      //       child: _addSearch(),
      //     ),
      //     SliverToBoxAdapter(
      //       child: Container(
      //         height: 10,
      //         color: CustomColors.colorF1F4F9,
      //       ),
      //     ),
      //     // SliverToBoxAdapter(
      //     //   child: EasyRefresh(
      //     //     header: WidgetTools().getClassicalHeader(),
      //     //     footer: WidgetTools().getClassicalFooter(),
      //     //     controller: _controller,
      //     //     enableControlFinishRefresh: true,
      //     //     enableControlFinishLoad: true,
      //     //     onRefresh: _onRefresh,
      //     //     onLoad: _onLoad,
      //     //     child: _buildList(),
      //     //   ),
      //     // ),
      //   ],
      // ),
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
            child: const Column(
              children: [
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
        padding: const EdgeInsets.all(0),
        itemCount: authorizeList.length,
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
              // _showTips("待用户同意授权后才能查看报告请，您耐心等待。", false);
              authorizedTip(model.id.toString());
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
      );
    }
  }

  Widget _addItemTop(String assetName, int type, GestureTapCallback callback) {
    return Expanded(
        child: InkWell(
      onTap: callback,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(width: 77, height: 77, image: AssetImage(assetName)),
        ],
      ),
    ));
  }

  Widget _addTxtItemTop(String title, int type, GestureTapCallback callback) {
    return Expanded(
      child: InkWell(
        onTap: callback,
        child: SizedBox(
          height: 25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Offstage(
                    offstage: !(type == status),
                    child: Container(
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
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  void _refreshData(int type) {
    Golbal.reportId = "";
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
    ///TODO: 后期需要改，现在直接那已授权的数据筛选，本地做ß
    if (status != 4) {
      Map<String, dynamic> pame = {
        "status": status,
        "searchName": _searchController.text.toString(),
        "pageNum": page,
        "pageSize": 10,
        "id": Golbal.reportId,
        "hideLoading": true,
      };
      ReportHomeManager.getAuthorizeList(pame, (model) {
        setState(() {
          ReportHomeBean reportHomeBean = model as ReportHomeBean;
          if (page == 1) {
            authorizeList.clear();
            _controller.finishRefresh(IndicatorResult.success);
            if (authorizeList.length < 10) {
              _controller.finishLoad(IndicatorResult.noMore);
            }
          } else {
            if (authorizeList.length < 10) {
              _controller.finishLoad(IndicatorResult.noMore);
            } else {
              _controller.finishLoad(IndicatorResult.success);
            }
          }

          authorizeList.addAll(reportHomeBean.data);
          if (status == 1) {
            authorizeList.clear();
            List<ReportHomeDataBean> tempAuthorizList = [];
            tempAuthorizList.addAll(reportHomeBean.data);
            Iterable<ReportHomeDataBean> a =
                tempAuthorizList.where((element) => element.reportType != 4);
            authorizeList.addAll(a);
          }

          if (status == 2) {
            /// 获取授权中数据
            ReportHomeManager.getAuthorizeList({
              "status": 4,
              "searchName": _searchController.text.toString(),
              "pageNum": page,
              "pageSize": 10,
              "id": Golbal.reportId,
              "hideLoading": true,
            }, (model1) {
              ReportHomeBean reportHomeBean1 = model1 as ReportHomeBean;
              authorizeList.addAll(reportHomeBean1.data);
              setState(() {});
            });
          }
        });
      });
    } else {
      Map<String, dynamic> pame = {
        "status": 1,
        "searchName": _searchController.text.toString(),
        "pageNum": page,
        "pageSize": 100,
        "id": Golbal.reportId,
        "hideLoading": true,
      };
      ReportHomeManager.getAuthorizeList(pame, (model) {
        setState(() {
          if (page == 1) {
            authorizeList.clear();
            _controller.finishRefresh(IndicatorResult.success);
            if (authorizeList.length < 10) {
              _controller.finishLoad(IndicatorResult.noMore);
            }
          } else {
            if (authorizeList.length < 10) {
              _controller.finishLoad(IndicatorResult.noMore);
            } else {
              _controller.finishLoad(IndicatorResult.success);
            }
          }
          ReportHomeBean reportHomeBean = model as ReportHomeBean;
          List<ReportHomeDataBean> tempAuthorizList = [];

          authorizeList.clear();
          tempAuthorizList.addAll(reportHomeBean.data);
          Iterable<ReportHomeDataBean> a =
              tempAuthorizList.where((element) => element.reportType == 4);
          authorizeList.addAll(a);
        });
      });
    }
  }

  void authorizedTip(String authId) {
    showDialog(
      context: context,
      builder: (context) {
        return NewPopupWindowDialog(
          title: "提示",
          confirm: "发送短信",
          cancel: "取消",
          content: "待被调人同意授权后才能查看报告，点击【发送短信】可再次发送授权短信",
          contentAlign: TextAlign.center,
          contentEdgeInsets: const EdgeInsets.only(left: 18, right: 18),
          contentStyle: const TextStyle(fontSize: 16),
          showCancel: true,
          cancelOnTap: () {
            //取消文案
            Navigator.of(context).pop();
          },
          confirmOnTap: () {
            //确定
            ReportHomeManager.reportAuthMessageAgain({"authId": authId}, (str) {
              Navigator.of(context).pop();
              ToastUtils.showMessage("授权短信发送成功");
            });
          },
        );
      },
    );
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}