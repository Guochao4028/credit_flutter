import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/report_home_manager.dart';
import 'package:credit_flutter/models/company_report_home_bean.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/empower/notification_statement_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_status/pay_success_input_phone_page.dart';
import 'package:credit_flutter/pages/modules/report/finance_part_report_details_page.dart';
import 'package:credit_flutter/pages/modules/report/new_report_details_page.dart';
import 'package:credit_flutter/pages/modules/report/report_details_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/new_popup_window.dart';
import 'package:credit_flutter/utils/public_dialog.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import 'part_report_details_page.dart';

/// @Description: 报告页
class PersonalReportHomePage extends StatefulWidget {
  const PersonalReportHomePage({Key? key}) : super(key: key);

  @override
  State<PersonalReportHomePage> createState() => _PersonalReportHomePageState();
}

class _PersonalReportHomePageState extends State<PersonalReportHomePage>
    implements ClickListener {
  @override
  void initState() {
    //初始化主页面
    super.initState();
    page = 1;
    status = Golbal.currentIndex;
    _initData();
    UmengCommonSdk.onPageStart("personal_authorization_list_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("personal_authorization_list_page");
  }

  //授权状态：1已授权，2未授权，3已拒绝
  int status = 1;

  //当前页
  int page = 1;

  final _searchController = TextEditingController();

  List<CompanyReportHomeData> authorizeList = [];

  final _controller = EasyRefreshController();

  CompanyReportHomeData? companyReportHomeData;

  //type==2 去认证
  int type = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航
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
                ],
              ),
              _addSearch(),
              const SizedBox(
                height: 10,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: CustomColors.colorF1F4F9,
                  ),
                ),
              ),
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
        itemBuilder: (context, index) {
          var model = authorizeList[index];
          return WidgetTools().showPersonalAuthorizationItem(context, model,
              () {
            companyReportHomeData = null;
            if (model.authorizationStatus == 1) {
              //查看报告
              StatefulWidget builder;
              if (model.reportType == 5) {
                builder = PartReportDetailsPage(
                  reportId: model.reportId.toString(),
                  authId: model.id.toString(),
                );
              } else if (model.reportType == 6) {
                builder = FinancePartReportDetailsPage(
                  reportId: model.reportId.toString(),
                  authId: model.id.toString(),
                );
              } else {
                builder = NewReportDetailsPage(
                  reportId: model.reportId.toString(),
                  authId: model.id.toString(),
                );
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return builder;
                  },
                ),
              );
            } else if (model.authorizationStatus == 2) {
              if (model.phone.isNotEmpty) {
                authorizedTip(model.id.toString());
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => PaySuccessInputPhonePage(
                              orderNo: model.orderId.toString(),
                            )),
                    (route) => route == null);
              }
            } else if (model.authorizationStatus == 3) {
              //3.已拒绝
              type = 0;
              _showTips(model.rejectionReason, "", "知道了", false);
            }
          });
        },
        itemCount: authorizeList.length,
        shrinkWrap: true,
      );
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
          Image(width: 77, height: 77, image: AssetImage(assetName)),
          Text(
            title,
            style: TextStyle(
              color: type == status
                  ? CustomColors.connectColor
                  : CustomColors.darkGrey,
              fontSize: 14,
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
  void _initData() {
    Map<String, dynamic> pame = {
      "status": status,
      "searchName": _searchController.text.toString(),
      "pageNum": page,
      "pageSize": 10,
      "id": Golbal.reportId,
      "hideLoading": true,
    };

    // Golbal.loginType == "2 自查"
    // Golbal.loginType == "3 查别人"
    pame["requestUserType"] = Golbal.loginType == "2" ? "2" : "1";
    pame["userType"] = Golbal.loginType == "2" ? "2" : "3";

    ReportHomeManager.getPersonList(pame, (model) {
      setState(() {
        CompanyReportHomeBean bean = model as CompanyReportHomeBean;
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
        authorizeList.addAll(bean.data);
        if (status == 2) {
          /// 获取授权中数据
          pame["status"] = 4;
          ReportHomeManager.getPersonList(pame, (model1) {
            CompanyReportHomeBean bean1 = model1 as CompanyReportHomeBean;
            authorizeList.addAll(bean1.data);
            setState(() {});
          });
        }
      });
    });
  }

  void _showTips(String rejectionReason, String functionTitle,
      String cancelTitle, bool showFunction) {
    showDialog(
        context: context,
        builder: (context) {
          return PublicDialog(
            title: "提示",
            content: rejectionReason,
            functionTitle: functionTitle,
            cancelTitle: cancelTitle,
            showFunction: showFunction,
            clickListener: this,
          );
        });
  }

  @override
  void onCancel() {
    if (companyReportHomeData != null) {
      // ReportHomeManager.reportAuthPersonRefuseAuth({
      //   "id": companyReportHomeData?.id.toString(),
      // }, (model) {
      //   ToastUtils.showMessage("拒绝成功");
      //   authorizeList.remove(companyReportHomeData);
      //   setState(() {});
      // });

      ReportHomeManager.reportAuthPersonRefuseAuth({
        "id": companyReportHomeData?.reportAuthId.toString(),
      }, (model) {
        ToastUtils.showMessage("拒绝成功");
        authorizeList.remove(companyReportHomeData);
        setState(() {});
      });
    }
  }

  @override
  void onConfirm() {
    if (companyReportHomeData != null) {
      ReportHomeManager.getCompanyNameForMessage(
          {"id": companyReportHomeData!.reportAuthId.toString()}, (str) {
        var companyName = str["companyName"];
        var idCard = str["idCard"];
        var name = str["name"];
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => NotificationStatementPage(
              type: companyReportHomeData!.reportType == 4 ? 3 : 2,
              companyName: companyName.toString(),
              idCard: idCard.toString(),
              name: name.toString(),
              reportAuthId: companyReportHomeData!.reportAuthId.toString(),
            ),
          ),
        )
            .then((value) {
          if (value != null) {
            _initData();
          }
        });
      });

      // ReportHomeManager.reportAuthMessageAgain({}, (str) {
      //   ToastUtils.showMessage("短信已发送，请前往短信进行授权");
      //   //通知公司授权
      //   _personAgreeAuth();
      // });
    }
    if (type == 2) {
      ///去认证
      ReportHomeManager.smsCheck((message) {
        ToastUtils.showMessage("短信已发送，请前往短信进行验证");
      });
    }
  }

  void lookReport(String id, int reportType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReportDetailsPage(
          reportAuthId: id,
          reportType: reportType,
        ),
      ),
    );
  }

  void ifRealName(CompanyReportHomeData data) {
    UserModel.getInfo((model) {
      if (model != null) {
        var userVerifiedStatus = model.userInfo.getUserVerifiedStatus();
        //  /// -  @description: 实名制认证状态(0 未认证 1已认证 2认证中 3失败)
        if (userVerifiedStatus) {
          companyReportHomeData = data;
          //2.待授权
          type = 1;
          _showTips("${data.companyName}申请查看您的员工背调报告，是否同意授权", "同意", "拒绝", true);
        } else {
          type = 2;
          _showTips("请您先进行实名认证，如已实名请退出重新登录！", "认证", "取消", true);
        }
      }
    });
  }

  void _personAgreeAuth() {
    ReportHomeManager.reportAuthPersonAgreeAuth({
      "id": companyReportHomeData?.id.toString(),
    }, (model) {
      ToastUtils.showMessage("授权成功");
      authorizeList.remove(companyReportHomeData);
      setState(() {});
    });
  }
}
