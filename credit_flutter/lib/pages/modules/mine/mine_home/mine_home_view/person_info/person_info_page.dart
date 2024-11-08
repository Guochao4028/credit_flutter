/// *
/// -  @Date: 2022-09-21 15:05
/// -  @LastEditTime: 2022-09-21 15:05
/// -  @Description: 个人信息页面
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/certification/certification_process_page.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/event_bus.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import 'modify_info_page.dart';

class PersonInfoPage extends StatefulWidget {
  const PersonInfoPage({Key? key}) : super(key: key);

  @override
  State<PersonInfoPage> createState() => _PersonInfoPageState();
}

class _PersonInfoPageState extends State<PersonInfoPage> {
  List<Map<String, dynamic>> industryList = [
    {"name": "金融", "isSelect": false},
    {"name": "投资", "isSelect": false},
    {"name": "法律", "isSelect": false},
    {"name": "采购", "isSelect": false},
    {"name": "销售", "isSelect": false},
    {"name": "互联网", "isSelect": false},
    {"name": "机械机电/自动化", "isSelect": false},
    {"name": "电子电器/仪器仪表", "isSelect": false},
    {"name": "快消品/办公品", "isSelect": false},
    {"name": "房地产/建筑", "isSelect": false},
    {"name": "医疗/制药", "isSelect": false}
  ];

  String MIN_DATETIME = '1900-01-01';
  String MAX_DATETIME = '2021-11-25';
  String INIT_DATETIME = '2019-05-17';
  String DATE_FORMAT = 'yyyy年|M月|d日';

  TextInputFormatter formatter = FilteringTextInputFormatter.deny(RegExp(
      "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"));
  TextInputFormatter textFormatter = FilteringTextInputFormatter.deny(RegExp(
      "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"));
  TextInputFormatter phoneNumebrFormatter =
      FilteringTextInputFormatter.allow(RegExp("[0-9]"));

  ///名字
  var nameController = TextEditingController();
  var isName = false;

  ///手机号
  var phoneNoController = TextEditingController();
  var isPhone = false;

  ///生日
  var birthdayController = TextEditingController();
  var isBirthday = false;

  ///地址
  var addressController = TextEditingController();
  var isAddress = false;

  ///微信
  var weChatController = TextEditingController();
  var isWeChat = false;

  ///邮箱
  var emailController = TextEditingController();
  var isEmail = false;

  //实名认证
  var verifiedStatus = false;

  ///公司名称
  var companyNameController = TextEditingController();
  var isCompanyName = false;

  ///行业
  var industryController = TextEditingController();
  var isIndustry = false;

  ///职位
  var positionController = TextEditingController();
  var isPosition = false;

  //工作年限
  var workYearController = TextEditingController();
  var isWorkYear = false;

  DateTime? current;
  DateTime? cache;

  @override
  void initState() {
    //初始化主页面
    super.initState();
    _initData();
    UmengCommonSdk.onPageStart("person_info_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("person_info_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorF1F4F9,
      appBar: AppBar(
        backgroundColor: CustomColors.lightBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "个人信息",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
      body: GestureDetector(
        // onPanDown: () {
        //   searchModule.closeKeyboard(context);
        // },
        onPanDown: (details) {
          closeKeyboard(context);
        },
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _itemEnter("姓名", 10, nameController, "请输入您的姓名", isName,
                      TextInputType.text, 1, formatter, 1),
                  _itemNotEnter("手机号", phoneNoController.text),
                  _itemChoose("生日", "请选择您的生日", isBirthday, birthdayController,
                      () {
                    closeKeyboard(context);
                    _showPicker();
                  }),
                  _itemEnter("地址", 50, addressController, "请输入您的所在地址",
                      isAddress, TextInputType.text, 1, textFormatter, 2),
                  _itemEnter(
                    "微信",
                    50,
                    weChatController,
                    "请输入您的微信号",
                    isWeChat,
                    TextInputType.text,
                    1,
                    FilteringTextInputFormatter.allow(
                        RegExp("[A-Z,a-z,0-9]|[_]")),
                    3,
                  ),
                  _itemEnter("邮箱", 50, emailController, "请输入您的邮箱号", isEmail,
                      TextInputType.emailAddress, 1, textFormatter, 4),

                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    color: Colors.white,
                    height: 52.5,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Text(
                                "身份认证",
                                style: TextStyle(
                                  color: CustomColors.textDarkColor,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    _goRealName();
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        verifiedStatus ? "已认证" : "未认证",
                                        style: TextStyle(
                                          color: verifiedStatus
                                              ? CustomColors.lightGrey
                                              : CustomColors.lightBlue,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: CustomColors.colorF1F4F9,
                    height: 10,
                  ),
                  _itemEnter("公司名称", 50, companyNameController, "请输入您的公司名称",
                      isCompanyName, TextInputType.text, 1, formatter, 5),
                  _itemChoose("行业", "请选择您的所在行业", isIndustry, industryController,
                      () {
                    closeKeyboard(context);
                    _showSelect(industryList, industryController, 1);
                  }),
                  _itemEnter("职位", 10, positionController, "请输入您的职位名称",
                      isPosition, TextInputType.text, 1, formatter, 6),
                  _itemEnter(
                      "工作年限",
                      2,
                      workYearController,
                      "请输入您的工作年限",
                      isWorkYear,
                      TextInputType.number,
                      1,
                      phoneNumebrFormatter,
                      7),
                  // _submit(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell _submit() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: 49,
        margin: const EdgeInsets.only(left: 30, right: 30, top: 70, bottom: 37),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24.5)),
          child: _buttonContainerView(),
        ),
      ),
      onTap: () {
        _commit();
      },
    );
  }

  Widget _buttonContainerView() {
    Color bgColor;
    String titleStr;
    Color titleColor;

    bgColor = CustomColors.lightBlue;
    titleStr = "保存";
    titleColor = Colors.white;

    return Container(
      color: bgColor,
      width: double.infinity,
      height: 49,
      alignment: Alignment.center,
      child: Text(
        titleStr,
        style: TextStyle(
          color: titleColor,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _itemEnter(
      String title,
      int maxLength,
      TextEditingController content,
      String hintText,
      bool error,
      TextInputType keyboardType,
      int entry,
      TextInputFormatter formatter,
      int type) {
    InputDecoration inputDecoration = InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(0),
      isCollapsed: true,
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 15,
        color: error ? CustomColors.warningColor : CustomColors.lightGrey,
      ),
    );

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      color: Colors.white,
      height: 52.5,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CustomColors.textDarkColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => ModifyInfoPage(
                              type: type, content: content.text.toString()),
                        ),
                      )
                          .then((value) {
                        if (value != null) {
                          switch (type) {
                            case 1:
                              nameController.text = value.toString();
                              break;
                            case 2:
                              addressController.text = value.toString();
                              break;
                            case 3:
                              weChatController.text = value.toString();
                              break;
                            case 4:
                              emailController.text = value.toString();
                              break;
                            case 5:
                              companyNameController.text = value.toString();
                              break;
                            case 6:
                              positionController.text = value.toString();
                              break;
                            case 7:
                              workYearController.text = value.toString();
                              break;
                          }
                          setState(() {});
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          onChanged: (text) {},
                          keyboardType: keyboardType,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(maxLength),
                            formatter
                          ],
                          controller: content,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: inputDecoration,
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: CustomColors.colorC8C9CD,
                  size: 12,
                ),
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: error ? CustomColors.warningColor : CustomColors.colorF1F4F9,
          )
        ],
      ),
    );
  }

  Widget _itemNotEnter(
    String title,
    String hintText,
  ) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      color: Colors.white,
      height: 52.5,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CustomColors.textDarkColor,
                    fontSize: 15,
                  ),
                ),
                const Expanded(child: SizedBox(width: 10)),
                Text(
                  hintText,
                  style: const TextStyle(
                    color: CustomColors.lightGrey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemChoose(String title, String hintText, bool error,
      TextEditingController content, GestureTapCallback callback) {
    InputDecoration inputDecoration = InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(0),
      isCollapsed: true,
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 15,
        color: error ? CustomColors.warningColor : CustomColors.lightGrey,
      ),
    );

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      color: Colors.white,
      height: 52.5,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: callback,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CustomColors.textDarkColor,
                      fontSize: 15,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: content,
                          enabled: false,
                          readOnly: true,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: inputDecoration,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: CustomColors.colorC8C9CD,
                    size: 12,
                  ),
                ],
              ),
            ),
            Container(
              height: 0.5,
              color:
                  error ? CustomColors.warningColor : CustomColors.colorF1F4F9,
            )
          ],
        ),
      ),
    );
  }

  void _showSelect(List<Map<String, dynamic>> natureList,
      TextEditingController controller, int type) {
    showDialog(
      context: context,
      builder: (ctx) {
        if (controller.text.isNotEmpty) {
          for (var item in natureList) {
            if (item["name"] == controller.text) {
              item["isSelect"] = true;
            }
          }
        }

        return Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _showSelectList(natureList, controller, type),
          ],
        );
      },
    );
  }

  Widget _showSelectList(List<Map<String, dynamic>> natureList,
      TextEditingController companyType, int type) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          constraints: const BoxConstraints(
            maxHeight: 454,
          ),
          width: double.infinity,
          margin: const EdgeInsets.only(left: 37.5, right: 37.5),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              // var data = natureList[index];
              return WidgetTools()
                  .showSelectViewItem(context, natureList[index], () {
                setState(() {
                  for (var item in natureList) {
                    item["isSelect"] = false;
                  }
                  natureList[index]["isSelect"] =
                      !natureList[index]["isSelect"];
                  companyType.text = natureList[index]["name"];
                  Navigator.of(context).pop();
                  setState(() {});

                  LoginManager.modify({"industry": industryController.text},
                      (message) {
                    ToastUtils.showMessage("保存成功");
                  });
                });
              });
            },
            itemCount: natureList.length,
            shrinkWrap: true,
          ),
        );
      },
    );
  }

  void _showPicker() {
    current ??= DateTime.now();
    showDialog(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _showSelectDate(),
          ],
        );
      },
    );
  }

  Widget _showSelectDate() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          height: 310,
          width: 300,
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: DateTimePickerWidget(
                  minDateTime: DateTime.parse(MIN_DATETIME),
                  maxDateTime: DateTime.now(),
                  initDateTime: current ?? DateTime.now(),
                  dateFormat: DATE_FORMAT,
                  pickerTheme: const DateTimePickerTheme(
                    backgroundColor: Colors.white,
                    itemTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    pickerHeight: 260.0,
                    itemHeight: 49.0,
                    showTitle: false,
                  ),
                  onChange: (dateTime, selectedIndex) {
                    cache = dateTime;
                  },
                ),
              ),
              Container(
                  height: 38.5,
                  child: Column(
                    children: [
                      Container(
                        height: 0.5,
                        color: CustomColors.colorF1F4F9,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "取消",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: CustomColors.lightGrey,
                                  ),
                                ),
                              ),
                              onTap: () {
                                cache = null;
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Container(
                            height: 38,
                            width: 0.7,
                            color: CustomColors.colorF1F4F9,
                          ),
                          Expanded(
                            child: InkWell(
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "确定",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: CustomColors.lightBlue,
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  current = cache;
                                  birthdayController.text = formatDate(
                                      current ?? DateTime.now(),
                                      ['yyyy', '-', 'mm', '-', 'dd']);
                                  Navigator.of(context).pop();
                                });

                                LoginManager.modify(
                                    {"birthday": birthdayController.text},
                                    (message) {
                                  ToastUtils.showMessage("保存成功");
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  void _commit() {
    ///名字
    // isName = nameController.text.isEmpty;

    ///手机号
    // isPhone = phoneNoController.text.isEmpty;
    // if (!isPhone) {
    //   isPhone = !RegexUtils.verifyPhoneNumber(phoneNoController.text);
    // }

    ///生日
    // isBirthday = birthdayController.text.isEmpty;

    ///地址
    // isAddress = addressController.text.isEmpty;

    ///微信
    // isWeChat = weChatController.text.isEmpty;

    ///邮箱
    // isEmail = emailController.text.isEmpty;
    // if (!isEmail) {
    //   isEmail = !StringTools.isEmail(emailController.text);
    // }
    if (emailController.text.isNotEmpty &&
        !StringTools.isEmail(emailController.text)) {
      ToastUtils.showMessage("请输入正确的邮箱");
      return;
    }

    ///公司名称
    // isCompanyName = companyNameController.text.isEmpty;

    ///行业
    // isIndustry = industryController.text.isEmpty;

    ///职位
    // isPosition = positionController.text.isEmpty;

    //工作年限
    // isWorkYear = workYearController.text.isEmpty;

    setState(() {});

    // if (!isWorkYear &&
    //     !isPosition &&
    //     !isIndustry &&
    //     !isCompanyName &&
    //     !isEmail &&
    //     !isAddress &&
    //     !isWeChat &&
    //     !isBirthday &&
    //     !isPhone &&
    //     !isName) {
    LoginManager.modify({
      "address": addressController.text,
      "birthday": birthdayController.text,
      "companyName": companyNameController.text,
      "email": emailController.text,
      "industry": industryController.text,
      "name": nameController.text,
      "position": positionController.text,
      "wechatId": weChatController.text,
      "workAge": workYearController.text,
    }, (message) {
      ToastUtils.showMessage("提交成功");
      Navigator.pop(context, "refreshPage");
    });
    // }
  }

  void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    /// 键盘是否是弹起状态
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _initData() {
    LoginManager.userGetUserInfo((object) {
      var info = object as UserInfo;

      UserModel.getInfo((model) {
        if (model != null) {
          model.userInfo = info;
          UserModel.saveUserInfo(model.toJson());
          if (info.getUserVerifiedStatus()) {
            bus.emit("real_name_refresh");
          }
        }
      });

      ///名字
      nameController.text = info?.nickName ?? "";

      ///手机号
      phoneNoController.text = info?.telPhone ?? "";

      ///生日
      String birthdayStr = info?.birthday ?? "";
      if (birthdayStr.isNotEmpty) {
        birthdayController.text = formatDate(
            DateTime.parse(birthdayStr), ['yyyy', '-', 'mm', '-', 'dd']);
      } else {
        birthdayController.text = birthdayStr;
      }

      ///地址
      addressController.text = info?.address ?? "";

      ///微信
      weChatController.text = info?.wechatId ?? "";

      ///邮箱
      emailController.text = info?.email ?? "";

      ///实名认证
      verifiedStatus = info?.getUserVerifiedStatus() ?? false;

      ///公司名称
      companyNameController.text = info?.companyName ?? "";

      ///行业
      industryController.text = info?.industry ?? "";

      ///职位
      positionController.text = info?.position ?? "";

      ///工作年限
      workYearController.text = info?.workAge ?? "";

      setState(() {});
    });
    // UserModel.getInfo()
  }

  void _goRealName() {
    if (!verifiedStatus) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const CertificationProcessPage();
          },
        ),
      ).then(
        (value) {
          if (value != null) {
            var certifyId = value["certifyId"];
            var result = value["result"];
            if (result) {
              _updatePersonalInfo(certifyId);
            }
          }
        },
      );
    }
  }

  void _updatePersonalInfo(String certifyId) {
    LoginManager.authCheck(
      {"certifyId": certifyId},
      (message) {
        _refreshData();
        ToastUtils.showMessage("实名认证成功");
      },
    );
  }

  void _refreshData() {
    LoginManager.userGetUserInfo((object) {
      var info = object as UserInfo;

      UserModel.getInfo((model) {
        if (model != null) {
          model.userInfo = info;
          UserModel.saveUserInfo(model.toJson());
          bus.emit("real_name_refresh");
        }
      });

      ///实名认证
      verifiedStatus = info?.getUserVerifiedStatus() ?? false;

      setState(() {});
    });
  }
}
