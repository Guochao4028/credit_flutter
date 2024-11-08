import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/select_replace_company_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/mine/my_company/select_replace_company_page.dart';
import 'package:credit_flutter/tools/login_tool.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../login/login_type_page.dart';

/// @Description: 我的公司
class MyCompanyPage extends StatefulWidget {
  const MyCompanyPage({Key? key}) : super(key: key);

  @override
  State<MyCompanyPage> createState() => _MyCompanyPageState();
}

class _MyCompanyPageState extends State<MyCompanyPage>
    implements ClickListener {
  CompanyInfo? companyInfo;

  String logoName = "";
  String name = "";
  String scale = "";
  String mainIndustry = "";
  int owner = 1;

  @override
  void initState() {
    //初始化主页面
    super.initState();
    UmengCommonSdk.onPageStart("my_company_page");
    _initView();
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("my_company_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "我的公司",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 75,
                height: 75,
                margin: const EdgeInsets.only(top: 56, bottom: 16),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Container(
                    color: CustomColors.color3189F6,
                    width: double.infinity,
                    height: 49,
                    alignment: Alignment.center,
                    child: Text(
                      logoName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
            ],
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            width: double.infinity,
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    "公司规模",
                    style:
                        TextStyle(color: CustomColors.greyBlack, fontSize: 16),
                  ),
                ),
                Text(
                  scale,
                  style: const TextStyle(
                      color: CustomColors.greyBlack, fontSize: 16),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            width: double.infinity,
            height: 1,
            color: const Color(0x1A000000),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            width: double.infinity,
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    "所属行业",
                    style:
                        TextStyle(color: CustomColors.greyBlack, fontSize: 16),
                  ),
                ),
                Text(
                  mainIndustry,
                  style: const TextStyle(
                      color: CustomColors.greyBlack, fontSize: 16),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            width: double.infinity,
            height: 1,
            color: const Color(0x1A000000),
          ),
          _changeCompany(),
        ],
      ),
    );
  }

  Widget _changeCompany() {
    if (owner == 1) {
      //主账号
      return InkWell(
        child: Container(
          width: double.infinity,
          height: 49,
          margin: const EdgeInsets.only(left: 30, top: 77, right: 30),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(24.5)),
            child: Container(
              color: CustomColors.lightBlue,
              width: double.infinity,
              height: 49,
              alignment: Alignment.center,
              child: const Text(
                "更换公司",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => const SelectReplaceCompanyPage(),
              ))
              .then((value) => {
                    if (value != null)
                      {
                        MineHomeManager.userGetUserInfo((message) {
                          _initView();
                        })
                      }
                  });
        },
      );
    } else {
      return Row(
        children: [
          Expanded(
              child: InkWell(
            child: Container(
              width: double.infinity,
              height: 49,
              margin: const EdgeInsets.only(left: 30, top: 77),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(24.5)),
                child: Container(
                  color: CustomColors.colorE6F0FE,
                  width: double.infinity,
                  height: 49,
                  alignment: Alignment.center,
                  child: const Text(
                    "离开公司",
                    style: TextStyle(
                      color: CustomColors.connectColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              showTips();
            },
          )),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: InkWell(
            child: Container(
              width: double.infinity,
              height: 49,
              margin: const EdgeInsets.only(top: 77, right: 30),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(24.5)),
                child: Container(
                  color: CustomColors.lightBlue,
                  width: double.infinity,
                  height: 49,
                  alignment: Alignment.center,
                  child: const Text(
                    "更换公司",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => const SelectReplaceCompanyPage(),
                  ))
                  .then((value) => {
                        if (value != null)
                          {
                            MineHomeManager.userGetUserInfo((message) {
                              _initView();
                            })
                          }
                      });
            },
          )),
        ],
      );
    }
  }

  void showTips() {
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            title: "提示",
            confirm: "确认",
            cancel: "取消",
            content: "您是否要离开目前公司",
            showCancel: true,
            clickListener: this,
          );
        });
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> confirmMap) {
    //离开
    SelectReplaceCompanyManager.companyLeaveCompany((object) {
      ToastUtils.showMessage("操作成功");
      // _loginOut();
      LoginTools.loginOut(context);

    });
  }

  void _initView() {
    UserModel.getInfo((model) {
      if (model != null) {
        owner = model.userInfo.owner;
        companyInfo = model.userInfo.companyInfo;
        name = model.userInfo.companyInfo.licenceName;
        if (name.isNotEmpty && name.length > 1) {
          logoName = name.substring(0, 2);
        } else {
          logoName = name;
        }
        scale = model.userInfo.companyInfo.scale;
        mainIndustry = model.userInfo.companyInfo.mainIndustry;
        setState(() {});
      }
    });
  }

  // void _loginOut() {
  //   ///清空用户数据
  //   UserModel.removeUserInfo();
  //   // 获得实例
  //   Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  //   // 取出数据
  //   prefs.then((sp) {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => const LoginTypePage(),
  //     ));
  //   });
  // }
}
