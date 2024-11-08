/// *
/// -  @Date: 2022-09-06 17:06
/// -  @LastEditTime: 2022-09-06 17:08
/// -  @Description:人员管理
///

import 'package:credit_flutter/define/define_block.dart';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/company_manager.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/models/person_management_list_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/mine/personnel_management/management_views/person_management_views.dart';
import 'package:credit_flutter/pages/modules/mine/personnel_management/popup_add_person_dialog.dart';
import 'package:credit_flutter/pages/modules/mine/vip/vip_page.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class PersonnelManagementPage extends StatefulWidget {
  const PersonnelManagementPage({Key? key}) : super(key: key);

  @override
  State<PersonnelManagementPage> createState() =>
      _PersonnelManagementPageState();
}

class _PersonnelManagementPageState extends State<PersonnelManagementPage>
    implements
        PersonManagementClickListener,
        AddPersonClickListener,
        ClickListener {
  PersonManagementView? view;

  String personNumber = "0";

  /// 人员是否注册过
  bool isRegistered = true;

  PopupAddPersonDialog? dialog;

  List<PersonManagementListItemModel> personList = [];
  PersonManagementListItemModel? _model;

  UserModel? _uModel;

  @override
  void initState() {
    _initUI();
    _initData();
    super.initState();
    UmengCommonSdk.onPageStart("personnel_management_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("personnel_management_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.lightBlue,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "人员管理",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: personList.isNotEmpty
          ? view?.contentView(personList, personNumber)
          : view?.emptyContentView(personNumber),
    );
  }

  _initUI() {
    view = PersonManagementView(clickListener: this);
  }

  _initData() {
    personList.clear();
    UserModel.getInfo((model) {
      _uModel = model;
      CompanyManager.companyPersonNumber({}, (str) {
        personNumber = str;
        CompanyManager.companyPersonManagementList(
            {"pageNum": 1, "pageSize": 10}, (list) {
          for (var element in list) {
            personList.add(element);
          }
          setState(() {});
        });
      });
    });
  }

  @override

  /// *
  /// -  @description: 添加管理员
  /// -  @Date: 2022-09-07 14:35
  /// -  @parm:
  /// -  @return {*}
  ///
  tapAddingAdministrator() {
    // UserModel.getInfo((model) {
    int vIPType = _uModel?.userInfo.companyInfo.vipType ?? 0;

    if (vIPType > 0) {
      int pn = int.parse(personNumber);

      if (pn > 0) {
        dialog = PopupAddPersonDialog(
          personNumber: personNumber,
          clickListener: this,
        );

        return showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, on) {
                return dialog!;
              });
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return PopupWindowDialog(
                title: "提示",
                confirm: "去购买",
                cancel: "取消",
                content: "管理人员不足，请先购买管理员人数",
                showCancel: true,
                identity: "999",
                clickListener: this,
                contentAlign: TextAlign.center,
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return PopupWindowDialog(
              title: "提示",
              confirm: "去购买",
              cancel: "取消",
              content: "请您先开通会员并购买管理人数",
              showCancel: true,
              identity: "999",
              clickListener: this,
              contentAlign: TextAlign.center,
            );
          });
    }
    // });
  }

  @override

  /// *
  /// -  @description: 充值
  /// -  @Date: 2022-09-07 14:35
  /// -  @parm:
  /// -  @return {*}
  ///
  tapRecharge() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VipPageWidget(),
      ),
    ).then((value) => _initData());
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> confirmMap) {
    int tpye = int.parse(confirmMap["identity"]);
    int id = _model?.id ?? 0;

    ///tpye : 0 删除， 1启用, 2,禁用, 3，已过期
    switch (tpye) {
      case 0:

        ///删除
        CompanyManager.companyUserDelete({"id": id}, (str) {
          ToastUtils.showMessage("删除成功");
          _initData();
        });
        break;
      case 1:

        ///启用
        CompanyManager.companyUserStatus({"status": 1, "id": id}, (str) {
          ToastUtils.showMessage("启用成功");
          _initData();
        });

        break;
      case 2:

        ///禁用
        CompanyManager.companyUserStatus({"status": 0, "id": id}, (str) {
          ToastUtils.showMessage("禁用成功");
          _initData();
        });
        break;
      case 3:

        ///激活
        CompanyManager.companyUserStatus({"status": 1, "id": id}, (str) {
          ToastUtils.showMessage("激活成功");
          _initData();
        });

        break;
      case 999:

        ///人数不足，去购买
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VipPageWidget(),
          ),
        ).then((value) => _initData());

        break;
      default:
    }
  }

  @override
  void validation(String phoneNumber, NetworkObjectCallBack callBack) {
    ///验证账号是否注册
    LoginManager.phoneCheck({"telPhone": phoneNumber}, (message) {
      if (message.isSuccess == true) {
        isRegistered = false;

        callBack(1);
      } else {
        callBack(0);
      }
    });
  }

  @override
  tapItemOperation(int tpye, PersonManagementListItemModel model) {
    _model = model;

    ///tpye : 0 删除， 1启用, 2,禁用, 3，已过期
    String confirm = "";
    String content = "";
    String identity = tpye.toString();
    switch (tpye) {
      case 0:

        ///删除
        content = "是否删除该账号，删除后将不能查看该账号的数据";
        confirm = "确定";

        break;
      case 1:

        ///启用
        content = "您确定要启用该人员吗？";
        confirm = "启用";
        break;
      case 2:

        ///禁用
        content = "您确定要禁用该人员吗？禁用后该人员将无法使用";
        confirm = "禁用";

        break;
      case 3:

        ///激活
        content = "是否使用1名管理人员资格";
        confirm = "激活";
        break;
      default:
    }

    if (tpye == 1 || tpye == 2) {
      // int pn = int.parse(personNumber);
      // if (pn <= 0) {
      //   content = "启用人数不足请购买管理员人数";
      //   confirm = "去购买";
      //   identity = "999";
      // }
      ///判断会员是否到期

      if (_uModel != null) {
        String maturityTime = _uModel!.userInfo.companyInfo.maturityTime;

        var time = DateTime.parse(maturityTime);
        var now = DateTime.now();
        var tatTime = time.difference(now);
        if (tatTime.inDays < 0) {
          content = "会员到期添加管理人员页面不能使用，请您先开通会员并购买管理员人数";
          confirm = "去购买";
          identity = "999";
        }
      }
    }

    if (tpye == 3) {
      ///判断会员是否到期
      // UserModel.getInfo((model) {
      if (_uModel != null) {
        String maturityTime = _uModel!.userInfo.companyInfo.maturityTime;

        var time = DateTime.parse(maturityTime);
        var now = DateTime.now();
        var tatTime = time.difference(now);
        if (tatTime.inDays < 0) {
          content = "会员到期添加管理人员页面不能使用，请您先开通会员并购买管理员人数";
          confirm = "去购买";
          identity = "999";
        }
      }
      // });

      ///判断人数
      int pn = int.parse(personNumber);
      if (pn == 0) {
        content = "管理人员不足，请先购买管理员人数";
        confirm = "去购买";
        identity = "999";
      }
    }

    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            title: "提示",
            confirm: confirm,
            cancel: "取消",
            content: content,
            showCancel: true,
            identity: identity,
            clickListener: this,
            contentAlign: TextAlign.center,
          );
        });
  }

  @override
  void onAffirm(Map<String, dynamic> confirmMap) {
    ///添加人员
    String jobTitle = confirmMap["id"];
    String name = confirmMap["name"];
    String phone = confirmMap["phone"];

    UserModel.getInfo((model) {
      if (model != null) {
        if (model.userInfo.telPhone != phone) {
          CompanyManager.companyAddCompanyUser({
            "jobTitle": jobTitle,
            "name": name,
            "phone": phone,
          }, (str) {
            ToastUtils.showMessage("添加人员成功");
            _initData();
          });
        } else {
          ToastUtils.showMessage("不能添加自己为管理员");
        }
      }
    });
  }
}
