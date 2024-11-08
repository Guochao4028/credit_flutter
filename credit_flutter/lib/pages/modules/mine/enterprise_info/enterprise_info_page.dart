// import 'dart:js' as js;

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/manager/enterprise_info_manager.dart';
import 'package:credit_flutter/models/networking_message_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/event_bus.dart';
import 'package:credit_flutter/utils/flutter_native_utils.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/new_popup_window.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

/// @Description: 企业认证
class EnterpriseInfoPage extends StatefulWidget {
  //type=1编辑公司信息 type=2新增公司
  final int type;

  const EnterpriseInfoPage({Key? key, this.type = 1}) : super(key: key);

  @override
  State<EnterpriseInfoPage> createState() => _EnterpriseInfoPageState();
}

class _EnterpriseInfoPageState extends State<EnterpriseInfoPage> {
  String userID = "";

  //头像
  var headImgUrl = "";

  //营业执照
  var businessLicense = TextEditingController();
  var isBusinessLicense = false;

  //对外展示
  var externalDisplay = TextEditingController();
  var isExternalDisplay = false;

  //公司性质
  var isCompanyType = false;
  var companyType = TextEditingController();

  //公司主行业
  var isMainIndustry = false;
  var mainIndustry = TextEditingController();

  //公司规模
  var isScale = false;
  var scale = TextEditingController();

  //公司地址
  var address = TextEditingController();
  var isAddress = false;

  //联系方式
  var contactDetails = TextEditingController();
  var isContactDetails = false;

  //联系人
  var contact = TextEditingController();
  var isContact = false;

  //法人名称
  var legalName = TextEditingController();
  var isLegalName = false;

  //法人手机号
  var legalPhone = TextEditingController();
  var isLegalPhone = false;

  //使用人
  var accountPerson = TextEditingController();
  var isAccountPerson = false;

  //营业执照
  var isBusinessImage = false;
  var businessImage = "";

  //身份证
  var isIDCardImage = false;
  var idCardImage = "";

  var mType = -1;

  var addAgencyCode = "";

  var refusedReason = "";

  var isNewShow = true;

  StateType companyVerifiedStatus = StateType.none;

  List<Map<String, dynamic>> natureList = [
    {"name": "国有企业", "isSelect": false},
    {"name": "集体企业", "isSelect": false},
    {"name": "私营企业", "isSelect": false},
    {"name": "个体工商户", "isSelect": false},
    {"name": "合伙企业", "isSelect": false},
    {"name": "联营企业", "isSelect": false},
    {"name": "股份合作制企业", "isSelect": false},
    {"name": "有限责任公司", "isSelect": false},
    {"name": "股份有限公司", "isSelect": false}
  ];

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

  List<Map<String, dynamic>> scaleList = [
    {"name": "0-10人", "isSelect": false},
    {"name": "20-50人", "isSelect": false},
    {"name": "50-100人", "isSelect": false},
    {"name": "100-200人", "isSelect": false},
    {"name": "300-500人", "isSelect": false},
    {"name": "500人以上", "isSelect": false}
  ];

  TextInputFormatter formatter = FilteringTextInputFormatter.deny(RegExp(
      "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"));

  TextInputFormatter formatterNO = FilteringTextInputFormatter.deny(RegExp(
      "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"));

  @override
  void initState() {
    //初始化主页面
    super.initState();
    isNewShow = false;
    // EnterpriseInfoManager.newShow((Message message) {
    //   setState(() {
    //     if (PlatformUtils.isIOS) {
    //       isNewShow = false;
    //     } else {
    //       isNewShow = message.isSuccess;
    //     }
    //   });
    // });

    var platform = ImagePicker.platform;
    if (platform is ImagePickerAndroid) {
      platform.useAndroidPhotoPicker = true;
    }

    if (widget.type == 1) {
      UserModel.getInfo((model) {
        if (model != null) {
          userID = model.userInfo.id.toString();
          var companyInfo = model.userInfo.companyInfo;

          companyInfo = model.userInfo.companyInfo;
          headImgUrl = companyInfo.headImgUrl;
          businessLicense.text = companyInfo.licenceName;
          externalDisplay.text = companyInfo.name;
          companyType.text = companyInfo.nature;
          mainIndustry.text = companyInfo.mainIndustry;
          scale.text = companyInfo.scale;
          address.text = companyInfo.companyAddress;
          contactDetails.text = companyInfo.contactWay;
          contact.text = companyInfo.contact;

          accountPerson.text = companyInfo.accountPerson;
          legalName.text = companyInfo.legalPersonName;
          legalPhone.text = companyInfo.legalPersonPhone;

          businessImage = companyInfo.licenceImg;
          idCardImage = companyInfo.idCardImg;

          companyVerifiedStatus = companyInfo.getVerifiedStatus();

          addAgencyCode = companyInfo.agencyCode;
          refusedReason = companyInfo.refusedReason;
          setState(() {});

          ifAgent();
        }
      });
    }
    UmengCommonSdk.onPageStart("enterprise_info_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("enterprise_info_page");
  }

  @override
  Widget build(BuildContext context) {
    initJs();
    return WillPopScope(
      onWillPop: () {
        _closePage();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            alignment: Alignment.centerRight,
            color: Colors.black,
            onPressed: () {
              _closePage();
            },
          ),
          title: const Text(
            "企业信息",
            style: TextStyle(color: CustomColors.textDarkColor, fontSize: 17),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  if (companyVerifiedStatus == StateType.fail)
                    _authentication("审核不通过：$refusedReason"),
                  // _headPortrait(),
                  // _information(logo, name, score, phone),
                  // _introduction(introduction),
                  // const SizedBox(
                  //   height: 22.5,
                  // ),
                  //String title, int maxLength, TextEditingController content,
                  //       String hintText, bool error
                  _itemEnter("营业执照名称", 50, businessLicense, "请输入营业执照名称",
                      isBusinessLicense, TextInputType.text, 1, formatter),
                  _itemEnter("对外展示名称", 50, externalDisplay, "请输入对外展示名称",
                      isExternalDisplay, TextInputType.text, 2, formatter),
                  _itemChoose("公司性质", "请选择公司性质", isCompanyType, companyType,
                      () {
                    _showSelect(natureList, companyType, 1);
                  }),
                  Container(
                    color: CustomColors.colorF1F4F9,
                    height: 10,
                  ),
                  _itemChoose("公司主行业", "请选择公司主行业", isMainIndustry, mainIndustry,
                      () {
                    _showSelect(industryList, mainIndustry, 2);
                  }),
                  _itemChoose("公司规模", "请选择公司规模", isScale, scale, () {
                    _showSelect(scaleList, scale, 3);
                  }),
                  _itemEnter("公司地址", 100, address, "请输入公司地址", isAddress,
                      TextInputType.text, 3, formatterNO),
                  Container(
                    color: CustomColors.colorF1F4F9,
                    height: 10,
                  ),
                  _itemEnter("联系方式", 11, contactDetails, "请输入联系方式",
                      isContactDetails, TextInputType.phone, 4, formatterNO),
                  if (isContactDetails) addErrorPrompt("请输入正确的手机号码"),
                  _itemEnter("联系人", 10, contact, "请输入联系人", isContact,
                      TextInputType.text, 5, formatter),
                  _itemEnter("法人名称", 10, legalName, "请输入法人名称", isLegalName,
                      TextInputType.text, 6, formatter),
                  _itemEnter("法人手机号", 11, legalPhone, "请输入法人联系方式", isLegalPhone,
                      TextInputType.phone, 7, formatterNO),
                  if (isLegalPhone) addErrorPrompt("请输入正确的手机号码"),
                  _itemEnter("使用人", 5, accountPerson, "列如：经理，主管，hr人事",
                      isAccountPerson, TextInputType.text, 8, formatter),
                  _enterpriseInfo(businessImage, idCardImage, isBusinessImage,
                      isIDCardImage),
                  _submit(),
                  // _info(website, mail, address)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //icon_business_license_error.png
  // icon_camera_error.png
  // icon_id_card_error.png
  Widget _authentication(String title) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
          child: Row(
            children: [
              const Image(
                image: AssetImage("assets/images/icon_error_warning.png"),
                width: 13,
                height: 13,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: CustomColors.darkGrey, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: CustomColors.colorF1F4F9,
          height: 10,
        ),
      ],
    );
  }

  Widget _headPortrait() {
    ImageProvider assetImage;
    if (headImgUrl.isNotEmpty) {
      assetImage = NetworkImage(headImgUrl);
    } else {
      assetImage = const AssetImage('assets/images/icon_default_avatar.jpeg');
    }

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15.0),
          width: 120,
          height: 120,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              _selectMode(3);
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(60)),
                  child: Image(
                    image: assetImage,
                    width: 120,
                    height: 120,
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Image(
                    image: AssetImage('assets/images/icon_add_header.png'),
                    width: 44,
                    height: 44,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
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
      TextInputFormatter formatter) {
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        onChanged: (text) {
                          if (error && text.isNotEmpty) {
                            setState(() {
                              if (entry == 1) {
                                //营业执照
                                isBusinessLicense = false;
                              } else if (entry == 2) {
                                isExternalDisplay = false;
                              } else if (entry == 3) {
                                isAddress = false;
                              } else if (entry == 4) {
                                isContactDetails = false;
                              } else if (entry == 5) {
                                isContact = false;
                              } else if (entry == 6) {
                                isLegalName = false;
                              } else if (entry == 7) {
                                isLegalPhone = false;
                              } else if (entry == 8) {
                                isAccountPerson = false;
                              }
                            });
                          }
                        },
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
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: CustomColors.colorC8C9CD,
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
                          style: const TextStyle(
                            fontSize: 15,
                            color: CustomColors.greyBlack,
                          ),
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

  SizedBox addErrorPrompt(String title) {
    return SizedBox(
      height: 20,
      child: Row(children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: CustomColors.warningColor,
          ),
        ),
      ]),
    );
  }

  Widget _enterpriseInfo(String businessLicense, String idCard,
      bool isBusinessLicense, bool isIDCard) {
    ImageProvider business;
    if (businessLicense.isNotEmpty) {
      business = NetworkImage(businessLicense);
    } else {
      if (isBusinessLicense) {
        business =
            const AssetImage('assets/images/icon_business_license_error.png');
      } else {
        business = const AssetImage('assets/images/icon_business_license.png');
      }
    }

    ImageProvider isIDCardImage;
    if (idCard.isNotEmpty) {
      isIDCardImage = NetworkImage(idCard);
    } else {
      if (isBusinessLicense) {
        isIDCardImage =
            const AssetImage('assets/images/icon_id_card_error.png');
      } else {
        isIDCardImage = const AssetImage('assets/images/icon_id_card.png');
      }
    }

    ImageProvider businessCamera;
    if (isBusinessLicense) {
      businessCamera = const AssetImage('assets/images/icon_camera_error.png');
    } else {
      businessCamera = const AssetImage('assets/images/icon_add_header.png');
    }

    Align addCamera() {
      return Align(
        alignment: Alignment.center,
        child: Image(
          image: businessCamera,
          width: 44,
          height: 44,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Offstage(
        offstage: isNewShow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 55,
              child: Row(children: [
                Text(
                  "企业资料",
                  style: TextStyle(
                    color: CustomColors.textDarkColor,
                    fontSize: 15,
                  ),
                ),
              ]),
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        _selectMode(1);
                      },
                      child: SizedBox(
                        width: 163,
                        height: 100,
                        child: Stack(
                          children: [
                            Image(
                              image: business,
                              width: 163,
                              height: 100,
                            ),
                            if (businessLicense.isEmpty) addCamera(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "营业执照",
                      style: TextStyle(
                        color: CustomColors.lightGrey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    SizedBox(
                      width: 163,
                      height: 100,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          _selectMode(2);
                        },
                        child: Stack(
                          children: [
                            Image(
                              image: isIDCardImage,
                              width: 163,
                              height: 100,
                            ),
                            if (idCard.isEmpty) addCamera(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "法人代表手持身份证",
                      style: TextStyle(
                        color: CustomColors.lightGrey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InkWell _submit() {
    return InkWell(
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
        if (companyVerifiedStatus == StateType.waiting) {
          _showPopView();
        } else {
          _commit();
        }
      },
    );
  }

  /// *
  /// -  @description:  提示弹窗
  /// -  @Date: 2022-07-11 10:41
  /// -  @parm:
  /// -  @return {*}

  void _showPopView() {
    showDialog(
        context: context,
        builder: (context) {
          return const PopupWindowDialog(
            title: "提示",
            confirm: "知道了",
            content: "您的企业认证信息已提交请等待审核",
            contentImage: "assets/images/successful.png",
            contentStyle: TextStyle(fontSize: 15),
            showCancel: false,
          );
        });
  }

  /// *
  /// -  @description: 校验提交
  /// -  @Date: 2022-07-11 10:39
  /// -  @parm:
  /// -  @return {*}
  ///
  void _commit() {
    //营业执照名称
    isBusinessLicense = businessLicense.text.isEmpty;
    //对外展示名称
    isExternalDisplay = externalDisplay.text.isEmpty;
    //公司性质
    isCompanyType = companyType.text.isEmpty;
    //公司主行业
    isMainIndustry = mainIndustry.text.isEmpty;
    //公司主行业
    isScale = scale.text.isEmpty;
    //公司地址
    isAddress = address.text.isEmpty;
    //联系方式
    isContactDetails = contactDetails.text.isEmpty;
    isContactDetails = !RegexUtils.verifyPhoneNumber(contactDetails.text);
    //联系人
    isContact = contact.text.isEmpty;
    //法人名称
    isLegalName = legalName.text.isEmpty;
    //法人手机号
    isLegalPhone = legalPhone.text.isEmpty;
    isLegalPhone = !RegexUtils.verifyPhoneNumber(legalPhone.text);
    //使用人
    isAccountPerson = accountPerson.text.isEmpty;
    //营业执照
    isBusinessImage = businessImage.isEmpty;
    //身份证
    isIDCardImage = idCardImage.isEmpty;
    setState(() {});
    if (!isBusinessLicense &&
        !isExternalDisplay &&
        !isCompanyType &&
        !isMainIndustry &&
        !isScale &&
        !isAddress &&
        !isContactDetails &&
        !isContact &&
        !isLegalName &&
        !isLegalPhone &&
        !isAccountPerson &&
        !isBusinessImage &&
        !isIDCardImage) {
      //校验通过
      if (widget.type == 1) {
        EnterpriseInfoManager.editInfo({
          "id": userID,
          "name": externalDisplay.text,
          "headImgUrl": headImgUrl,
          "licenceName": businessLicense.text,
          "nature": companyType.text,
          "mainIndustry": mainIndustry.text,
          "scale": scale.text,
          "companyAddress": address.text,
          "contactWay": contactDetails.text,
          "contact": contact.text,
          "legalPersonName": legalName.text,
          "legalPersonPhone": legalPhone.text,
          "accountPerson": accountPerson.text,
          "idCardImg": idCardImage,
          "licenceImg": businessImage,
          "agencyCode": addAgencyCode,
        }, (data) {
          if (data["code"] == 200) {
            ToastUtils.showMessage("提交成功");
            if (Golbal.generalAgent.isNotEmpty) {
              Golbal.generalAgent = "";
              bus.emit("refreshPage", "refreshPage");
            }
            Navigator.pop(context, "refreshPage");
          } else {
            ToastUtils.showMessage(data["msg"]);
          }
        });
      } else {
        EnterpriseInfoManager.addCompany({
          "id": userID,
          "name": externalDisplay.text,
          "headImgUrl": headImgUrl,
          "licenceName": businessLicense.text,
          "nature": companyType.text,
          "mainIndustry": mainIndustry.text,
          "scale": scale.text,
          "companyAddress": address.text,
          "contactWay": contactDetails.text,
          "contact": contact.text,
          "legalPersonName": legalName.text,
          "legalPersonPhone": legalPhone.text,
          "accountPerson": accountPerson.text,
          "idCardImg": idCardImage,
          "licenceImg": businessImage,
        }, (data) {
          if (data["code"] == 200) {
            ToastUtils.showMessage("提交成功");
            Navigator.pop(context, "refreshPage");
          } else {
            ToastUtils.showMessage(data["msg"]);
          }
        });
      }
    }
  }

  /// *
  /// -  @description: 按钮逻辑
  /// -  @Date: 2022-07-11 10:38
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _buttonContainerView() {
    Color bgColor;
    String titleStr;
    Color titleColor;
    if (companyVerifiedStatus == StateType.waiting) {
      bgColor = CustomColors.greyBlackDA;
      titleStr = "审核中";
      titleColor = CustomColors.darkGrey;
    } else {
      bgColor = CustomColors.lightBlue;
      titleStr = "提交";
      titleColor = Colors.white;
    }

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
                });
                if (type == 1) {
                  isCompanyType = false;
                } else if (type == 2) {
                  isMainIndustry = false;
                } else if (type == 3) {
                  isScale = false;
                }
                refreshPage();
              });
            },
            itemCount: natureList.length,
            shrinkWrap: true,
          ),
        );
      },
    );
  }

  void refreshPage() {
    setState(() {});
  }

  void _selectMode(int type) {
    if (PlatformUtils.isIOS || PlatformUtils.isAndroid) {
      showModalBottomSheet(
        context: context,
        // backgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            constraints: const BoxConstraints(
              maxHeight: 182,
            ),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 111,
                        child: Column(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _photograph(type);
                                  Navigator.of(context).pop();
                                },
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        "拍 照",
                                        style: TextStyle(
                                          color: CustomColors.warningColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: CustomColors.colorD1D1D1,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _photoAlbum(type);
                                  Navigator.of(context).pop();
                                },
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        "从相册选择",
                                        style: TextStyle(
                                          color: CustomColors.color5477B8,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          color: Colors.white,
                          width: double.infinity,
                          height: 55,
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "取 消",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.color5477B8,
                                    fontSize: 18,
                                  ),
                                ),
                              ]),
                        )),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else if (PlatformUtils.isWeb) {
      mType = type;
      NativeJSUtlis.selectPicture("选择图片");
    }
  }

  void _photograph(int type) async {
    ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        EnterpriseInfoManager.uploadFile(value.path, (message) {
          if (type == 1) {
            //营业执照
            businessImage = message;
            isBusinessImage = false;
          } else if (type == 2) {
            //身份证
            idCardImage = message;
            isIDCardImage = false;
          } else if (type == 3) {
            //头像
            headImgUrl = message;
          }
          refreshPage();
        });
      }
    });
  }

  void _photoAlbum(int type) async {
    ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        EnterpriseInfoManager.uploadFile(value.path, (message) {
          if (type == 1) {
            //营业执照
            businessImage = message;
            isBusinessImage = false;
          } else if (type == 2) {
            //身份证
            idCardImage = message;
            isIDCardImage = false;
          } else if (type == 3) {
            //头像
            headImgUrl = message;
          }
          refreshPage();
        });
      }
    });
  }

  void initJs() {
    // js.context["uploadPictures"] = (String data) {
    //   Log.d("uploadComplete----$data");
    //   EasyLoading.show();
    // };
    // js.context["uploadComplete"] = (String data) {
    //   Log.d("uploadComplete----$data");
    //   var decode = json.decode(data);
    //   if (mType == 1) {
    //     //营业执照
    //     businessImage = decode["data"];
    //     isBusinessImage = false;
    //   } else if (mType == 2) {
    //     //身份证
    //     idCardImage = decode["data"];
    //     isIDCardImage = false;
    //   } else if (mType == 3) {
    //     //头像
    //     headImgUrl = decode["data"];
    //   }
    //   EasyLoading.dismiss();
    //   refreshPage();
    // };
  }

  void ifAgent() {
    if (Golbal.generalAgent.isNotEmpty) {
      if (companyVerifiedStatus == StateType.none ||
          companyVerifiedStatus == StateType.fail) {
        addAgencyCode = Golbal.generalAgent;
      } else if (companyVerifiedStatus == StateType.waiting) {
        //认证中
        Golbal.generalAgent = "";
      } else {
        var agency = "";
        if (addAgencyCode.isNotEmpty) {
          //不为空
          agency = addAgencyCode;
        } else {
          agency = Golbal.generalAgent;
        }
        EnterpriseInfoManager.getAgencyName(agency, (str) {
          if (addAgencyCode.isNotEmpty) {
            Golbal.generalAgent = "";
            //已经是代理商了
            showDialog(
              context: context,
              builder: (context) {
                return PopupWindowDialog(
                  title: "提示",
                  confirm: "知道了",
                  content: "您已经是$str的代理\n无需认证",
                  contentStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  showCancel: false,
                );
              },
            );
          } else {
            addAgencyCode = Golbal.generalAgent;
            showDialog(
              context: context,
              builder: (context) {
                return NewPopupWindowDialog(
                  title: "提示",
                  confirm: "是",
                  cancel: "否",
                  content: "是否成为$str的代理",
                  contentStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  cancelOnTap: () {
                    //取消
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                  confirmOnTap: () {
                    //确定
                    _commit();
                  },
                );
              },
            );
          }
        });
      }
    }
  }

  void _closePage() {
    //        bus.emit("switch_bottom_page", 2);
    if (Golbal.generalAgent.isNotEmpty &&
        (companyVerifiedStatus == StateType.none ||
            companyVerifiedStatus == StateType.fail)) {
      showDialog(
          context: context,
          builder: (context) {
            return NewPopupWindowDialog(
              title: "提示",
              confirm: "是",
              cancel: "否",
              content: "您确定放弃成为代理吗",
              contentStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              cancelOnTap: () {
                //取消文案
                Navigator.of(context).pop();
              },
              confirmOnTap: () {
                //确定
                Golbal.generalAgent = "";
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
            );
          });
    } else {
      Navigator.pop(context, true);
    }
  }
}
