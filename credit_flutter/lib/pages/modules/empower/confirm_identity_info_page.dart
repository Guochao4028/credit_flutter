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
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/empower_manager.dart';
import 'package:credit_flutter/pages/modules/empower/trailer_page.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/utils/flutter_native_utils.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///确认身份信息
class ConfirmIdentityInfoPage extends StatefulWidget {
  int type = 1;
  String companyName = "";
  String idCard = "";
  String name = "";
  String reportAuthId = "";

  ConfirmIdentityInfoPage({
    Key? key,
    required this.type,
    required this.companyName,
    required this.idCard,
    required this.name,
    required this.reportAuthId,
  }) : super(key: key);

  @override
  State<ConfirmIdentityInfoPage> createState() =>
      _ConfirmIdentityInfoPageState();
}

class _ConfirmIdentityInfoPageState extends State<ConfirmIdentityInfoPage> {
  final ScrollController _scrollController = ScrollController();

  ///处理姓名
  final textNameController = TextEditingController();
  List<TextInputFormatter> nameInputFormatterList = [
    FilteringTextInputFormatter.deny(
      RegExp(
          "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"),
    ),
    LengthLimitingTextInputFormatter(20),
  ];

  ///处理身份证
  final textIdController = TextEditingController();

  List<TextInputFormatter> idInputFormatterList = [
    FilteringTextInputFormatter.allow(RegExp(r'[X,x,0-9]')),
    LengthLimitingTextInputFormatter(18),
  ];

  ///学历
  bool academicQualifications = false;
  List<MenuItem> academicQualificationsList = [
    MenuItem(title: "博士"),
    MenuItem(title: "研究生"),
    MenuItem(title: "本科"),
    MenuItem(title: "专科"),
    MenuItem(title: "中专/高中"),
    MenuItem(title: "其他"),
  ];
  final academicQualificationsController = TextEditingController();
  List<TextInputFormatter> academicQualificationsInputFormatterList = [
    FilteringTextInputFormatter.deny(
      RegExp(
          "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"),
    ),
    LengthLimitingTextInputFormatter(18),
  ];

  //学位
  bool bachelorOfScience = false;
  List<MenuItem> bachelorOfScienceList = [
    MenuItem(title: "博士"),
    MenuItem(title: "硕士"),
    MenuItem(title: "学士"),
  ];
  final bachelorOfScienceController = TextEditingController();
  List<TextInputFormatter> bachelorOfScienceInputFormatterList = [
    FilteringTextInputFormatter.deny(
      RegExp(
          "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"),
    ),
    LengthLimitingTextInputFormatter(18),
  ];

  List<bool> certificateBools = [false];
  List<Map<String, dynamic>> certificate = [
    {
      "title": "请选择证书",
      "agree": false,
      "content": "",
      "level": "",
      "particularYear": "",
      "provinceName": "",
      "province": "",
      "drivingLicenseName": "",
      "drivingLicense": "",
      "englishLevel": "",
    }
  ];

  List<MenuItem> certificateList = [
    MenuItem(title: "法律职业资格证"),
    MenuItem(title: "教师资格证"),
    MenuItem(title: "会计专业资格证"),
    MenuItem(title: "行驶证"),
    MenuItem(title: "英语四六级"),
  ];

  List<String> accountingLevel = ["无", "初级", "中级"];
  List<String> fiscalYear = [];

  List<Map<String, dynamic>> accountingProvince = [
    {"value": "11", "name": "北京"},
    {"value": "12", "name": "天津"},
    {"value": "13", "name": "河北"},
    {"value": "14", "name": "山西"},
    {"value": "15", "name": "内蒙古"},
    {"value": "16", "name": "辽宁"},
    {"value": "17", "name": "吉林"},
    {"value": "18", "name": "黑龙江"},
    {"value": "19", "name": "上海"},
    {"value": "20", "name": "江苏"},
    {"value": "21", "name": "浙江"},
    {"value": "22", "name": "安徽"},
    {"value": "23", "name": "福建"},
    {"value": "24", "name": "江西"},
    {"value": "25", "name": "山东"},
    {"value": "26", "name": "河南"},
    {"value": "27", "name": "湖北"},
    {"value": "28", "name": "湖南"},
    {"value": "29", "name": "广东"},
    {"value": "30", "name": "广西"},
    {"value": "31", "name": "海南"},
    {"value": "32", "name": "四川"},
    {"value": "33", "name": "重庆"},
    {"value": "34", "name": "贵州"},
    {"value": "35", "name": "云南"},
    {"value": "36", "name": "西藏"},
    {"value": "37", "name": "陕西"},
    {"value": "38", "name": "甘肃"},
    {"value": "39", "name": "青海"},
    {"value": "40", "name": "宁夏"},
    {"value": "41", "name": "新疆"},
    {"value": "42", "name": "兵团"}
  ];

  List<Map<String, dynamic>> drivingLicense = [
    {"val": "01", "name": "大型汽车"},
    {"val": "02", "name": "小型汽车"},
    {"val": "03", "name": "使馆汽车"},
    {"val": "04", "name": "领馆汽车"},
    {"val": "05", "name": "境外汽车"},
    {"val": "06", "name": "外籍汽车"},
    {"val": "07", "name": "两三轮摩托"},
    {"val": "08", "name": "轻便摩托车"},
    {"val": "09", "name": "使馆摩托车"},
    {"val": "10", "name": "领馆摩托车"},
    {"val": "11", "name": "境外摩托车"},
    {"val": "12", "name": "外籍摩托车"},
    {"val": "13", "name": "农用运输车"},
    {"val": "14", "name": "拖拉机"},
    {"val": "15", "name": "挂车"},
    {"val": "16", "name": "教练汽车"},
    {"val": "17", "name": "教练摩托车"},
    {"val": "26", "name": "香港入境车"},
    {"val": "27", "name": "教练摩托车"},
  ];

  List<String> englishLevel = ["四级", "六级"];

  bool isReading = false;

  Map<String, String> putMap = {};

  static const _channel = MethodChannel(FinalKeys.NATIVE_CHANNEL_PAY);

  @override
  void initState() {
    super.initState();
    textNameController.text = widget.name;
    textIdController.text = widget.idCard;
    putMap["authId"] = widget.reportAuthId;
    DateTime now = DateTime.now();
    for (var i = 1995; i < now.year; i++) {
      fiscalYear.insert(0, "$i年");
    }
    setState(() {});

    ///微信支付通道，用于处理微信支付结果
    _channel.setMethodCallHandler((call) async {
      setState(() {
        _processingCallback(call.arguments);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "确认身份信息",
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
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                  left: 16, top: 10, right: 16, bottom: 0),
              children: [
                Row(
                  children: [
                    Container(
                      height: 14,
                      width: 3,
                      decoration: const BoxDecoration(
                        color: CustomColors.connectColor,
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "身份信息",
                      style: TextStyle(
                        color: CustomColors.greyBlack,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "请核对姓名及身份证号信息",
                      style: TextStyle(
                        color: CustomColors.colorE50505,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  height: 1,
                  color: CustomColors.darkGreyE5,
                ),
                _identityInfoInputBox(
                  "姓      名",
                  "请输入姓名",
                  textNameController,
                  nameInputFormatterList,
                  TextInputType.text,
                ),
                _identityInfoInputBox(
                  "身份证号",
                  "请输入身份证号",
                  textIdController,
                  idInputFormatterList,
                  TextInputType.text,
                ),
                const SizedBox(height: 15),
                _redundancy(),
                // Container(
                //   margin:
                //   const EdgeInsets.only(left: 16, top: 40, right: 16, bottom: 10),
                //   height: 40,
                //   decoration: BoxDecoration(
                //     color: isReading
                //         ? CustomColors.connectColor
                //         : CustomColors.colorC8C8C8,
                //     borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                //   ),
                //   child: InkWell(
                //     highlightColor: Colors.transparent,
                //     splashColor: Colors.transparent,
                //     onTap: () {
                //       if (isReading) {
                //         _extractData();
                //       }
                //     },
                //     child: const Center(
                //       child: Text(
                //         "提交",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 15,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // Row(
                //   children: [
                //     const SizedBox(width: 30),
                //     InkWell(
                //       onTap: () {
                //         setState(() {
                //           isReading = !isReading;
                //         });
                //       },
                //       child: Image(
                //         width: 15,
                //         height: 15,
                //         image: isReading == false
                //             ? const AssetImage("assets/images/radioNormal.png")
                //             : const AssetImage("assets/images/radioSelectBlue.png"),
                //       ),
                //     ),
                //     const SizedBox(width: 5),
                //     const Expanded(
                //       child: Text(
                //         "我已确认填写信息真实有效，电子文件和纸质文件都具备有同等的法律效力。",
                //         style: TextStyle(
                //           color: CustomColors.darkGrey,
                //           fontSize: 10,
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 30),
                //   ],
                // ),
                const SizedBox(height: 18),
              ],
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 16, top: 40, right: 16, bottom: 10),
            height: 40,
            decoration: BoxDecoration(
              color: isReading
                  ? CustomColors.connectColor
                  : CustomColors.colorC8C8C8,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (isReading) {
                  _extractData();
                }
              },
              child: const Center(
                child: Text(
                  "提交",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 30),
              InkWell(
                onTap: () {
                  setState(() {
                    isReading = !isReading;
                  });
                },
                child: Image(
                  width: 15,
                  height: 15,
                  image: isReading == false
                      ? const AssetImage("assets/images/radioNormal.png")
                      : const AssetImage("assets/images/radioSelectBlue.png"),
                ),
              ),
              const SizedBox(width: 5),
              const Expanded(
                child: Text(
                  "我已确认填写信息真实有效，电子文件和纸质文件都具备有同等的法律效力。",
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _identityInfoInputBox(
      String title,
      // String content,
      String hintText,
      TextEditingController textEditingController,
      List<TextInputFormatter> inputFormatters,
      TextInputType inputType) {
    InputDecoration decoration = InputDecoration(
      isCollapsed: true,
      border: InputBorder.none,
      // counterText: content,
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
    );

    return Container(
      decoration: const BoxDecoration(
        color: CustomColors.colorF6FAFF,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      margin: const EdgeInsets.only(
        top: 9,
      ),
      padding: const EdgeInsets.only(
        left: 18,
        top: 12,
        right: 18,
        bottom: 12,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: TextField(
              controller: textEditingController,
              onChanged: (str) {
                // setState(() {});
                if (textEditingController == textNameController) {
                  // nameStr = str;
                } else if (textEditingController == textIdController) {
                  // idStr = str;
                }
              },
              inputFormatters: inputFormatters,
              cursorColor: CustomColors.greyBlack,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: inputType,
              decoration: decoration,
            ),
          ),
        ],
      ),
    );
  }

  _selectItem(bool isSelect, String title, List<MenuItem> list) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          decoration: BoxDecoration(
            color:
                isSelect ? CustomColors.colorF6FAFF : const Color(0x0D999999),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 18,
            top: 12,
            right: 18,
            bottom: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: CustomColors.darkGrey99,
                    fontSize: 14,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFCDCDCD),
              )
            ],
          ),
        ),
        items: [
          if (isSelect)
            ...list.map(
              (item) {
                return DropdownMenuItem<MenuItem>(
                  value: item,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    width: double.infinity,
                    color:
                        item.select ? CustomColors.colorF6FAFF : Colors.white,
                    child: Row(
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            color: item.select
                                ? CustomColors.connectColor
                                : CustomColors.greyBlack,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
        onChanged: (value) {
          var value2 = value as MenuItem;
          for (var item in list) {
            item.select = false;
          }
          Log.i("---${list.toString()}");
          if (list.contains(value2)) {
            list[list.indexOf(value2)].select = true;
          }
          Log.i("---${list.toString()}");
          setState(() {});
          // MenuItems.onChanged(context, value as MenuItem);
        },
        dropdownStyleData: DropdownStyleData(
          width: ScreenTool.screenWidth - 32,
          padding: const EdgeInsets.symmetric(vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          elevation: 4,
          offset: const Offset(0, 4),
        ),
        menuItemStyleData: const MenuItemStyleData(
          // customHeights: [
          //   if (academicQualifications) ...List<double>.filled(list.length, 48),
          // ],
          padding: EdgeInsets.all(0),
        ),
      ),
    );
  }

  _selectItemInput(
      bool isSelect,
      String hintText,
      TextEditingController textEditingController,
      List<TextInputFormatter> inputFormatters,
      TextInputType inputType) {
    InputDecoration decoration = InputDecoration(
      isCollapsed: true,
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
    );

    return Container(
      decoration: BoxDecoration(
        color: isSelect ? CustomColors.colorF6FAFF : const Color(0x0D999999),
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      margin: const EdgeInsets.only(
        top: 9,
      ),
      padding: const EdgeInsets.only(
        left: 18,
        top: 12,
        right: 18,
        bottom: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              inputFormatters: inputFormatters,
              cursorColor: CustomColors.greyBlack,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: inputType,
              decoration: decoration,
            ),
          ),
        ],
      ),
    );
  }

  String _getAcademicQualifications() {
    String name = "学历层次";
    for (var item in academicQualificationsList) {
      if (item.select) {
        name = item.title;
      }
    }
    return name;
  }

  String _getBachelorOfScience() {
    String name = "学位类型";
    for (var item in bachelorOfScienceList) {
      if (item.select) {
        name = item.title;
      }
    }
    return name;
  }

  _listSelectItem(
      bool isSelect, Map<String, dynamic> item, List<MenuItem> list) {
    String title = item["title"];
    bool agree = item["agree"];

    List<String> toLock = [];
    for (var data in certificate) {
      toLock.add(data["title"]);
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          decoration: BoxDecoration(
            color:
                isSelect ? CustomColors.colorF6FAFF : const Color(0x0D999999),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 18,
            top: 12,
            right: 18,
            bottom: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelect
                        ? CustomColors.darkGrey
                        : CustomColors.darkGrey99,
                    fontSize: 14,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFCDCDCD),
              )
            ],
          ),
        ),
        items: [
          if (isSelect)
            ...list.map(
              (item) {
                bool enabled = toLock.contains(item.title);
                bool select = false;
                if (item.title == title) {
                  select = true;
                }
                return DropdownMenuItem<MenuItem>(
                  enabled: select ? true : !enabled,
                  value: item,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    width: double.infinity,
                    color: select ? CustomColors.colorF6FAFF : Colors.white,
                    child: Row(
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            color: select
                                ? CustomColors.connectColor
                                : (enabled
                                    ? const Color(0xFFC0C4CC)
                                    : CustomColors.greyBlack),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
        onChanged: (value) {
          var value2 = value as MenuItem;
          item["title"] = value2.title;
          item["content"] = "";
          setState(() {});
          _toBottom();
        },
        dropdownStyleData: DropdownStyleData(
          isOverButton: true,
          width: ScreenTool.screenWidth - 32,
          padding: const EdgeInsets.symmetric(vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          elevation: 4,
          offset: const Offset(0, 4),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.all(0),
        ),
      ),
    );
  }

  _addItemSelectInput(Map<String, dynamic> item) {
    String title = item["title"];
    switch (title) {
      case "法律职业资格证":
        return _newSelectItemInput(
            "请输入法律职业资格证书编号", item, [], TextInputType.text);
      case "教师资格证":
        return _newSelectItemInput("请输入教师资格证书编号", item, [], TextInputType.text);
      case "会计专业资格证":
        return Column(
          children: [
            const SizedBox(height: 10),
            _accountingItem("请选择报考级别", item, accountingLevel, 1),
            const SizedBox(height: 10),
            _accountingItem("请选择报考年份", item, fiscalYear, 2),
            const SizedBox(height: 10),
            _accountingProvinceItem("请选择报考省份", item, accountingProvince, 1),
          ],
        );
      case "行驶证":
        return Column(
          children: [
            const SizedBox(height: 10),
            _accountingProvinceItem("请选择号牌种类", item, drivingLicense, 2),
            const SizedBox(height: 1),
            _newSelectItemInput("请输入车牌号", item, [], TextInputType.text),
          ],
        );
      case "英语四六级":
        return Column(
          children: [
            const SizedBox(height: 10),
            _accountingItem("请选择考试等级", item, englishLevel, 3),
            const SizedBox(height: 1),
            _newSelectItemInput("请输入成绩单编号", item, [], TextInputType.text),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  _newSelectItemInput(String hintText, Map<String, dynamic> item,
      List<TextInputFormatter> inputFormatters, TextInputType inputType) {
    bool agree = item["agree"];
    final controller = TextEditingController();
    controller.text = item["content"];

    InputDecoration decoration = InputDecoration(
      isCollapsed: true,
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
    );

    return Container(
      decoration: BoxDecoration(
        color: agree ? CustomColors.colorF6FAFF : const Color(0x0D999999),
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      margin: const EdgeInsets.only(
        top: 9,
      ),
      padding: const EdgeInsets.only(
        left: 18,
        top: 12,
        right: 18,
        bottom: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (str) {
                item["content"] = str;
              },
              inputFormatters: inputFormatters,
              cursorColor: CustomColors.greyBlack,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: inputType,
              decoration: decoration,
            ),
          ),
        ],
      ),
    );
  }

  _accountingItem(
      String title, Map<String, dynamic> item, List<String> list, int type) {
    bool agree = item["agree"];
    String content = "";
    if (type == 1) {
      content = item["level"];
    } else if (type == 2) {
      content = item["particularYear"];
    } else {
      content = item["englishLevel"];
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          decoration: BoxDecoration(
            color: agree ? CustomColors.colorF6FAFF : const Color(0x0D999999),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 18,
            top: 12,
            right: 18,
            bottom: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  content.isNotEmpty ? content : title,
                  style: TextStyle(
                    color:
                        agree ? CustomColors.darkGrey : CustomColors.darkGrey99,
                    fontSize: 14,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFCDCDCD),
              )
            ],
          ),
        ),
        items: [
          ...list.map(
            (item) {
              // bool enabled = toLock.contains(item.title);
              bool select = false;
              if (item == title) {
                select = true;
              }
              return DropdownMenuItem<String>(
                value: item,
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  width: double.infinity,
                  color: select ? CustomColors.colorF6FAFF : Colors.white,
                  child: Row(
                    children: [
                      Text(
                        item,
                        style: TextStyle(
                          color: select
                              ? CustomColors.connectColor
                              : CustomColors.greyBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        onChanged: (value) {
          var value2 = value as String;
          if (type == 1) {
            item["level"] = value2;
          } else if (type == 2) {
            item["particularYear"] = value2;
          } else {
            item["englishLevel"] = value2;
          }
          setState(() {});
        },
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          isOverButton: true,
          width: ScreenTool.screenWidth - 32,
          padding: const EdgeInsets.symmetric(vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          elevation: 4,
          offset: const Offset(0, 4),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.all(0),
        ),
      ),
    );
  }

  _accountingProvinceItem(String title, Map<String, dynamic> item,
      List<Map<String, dynamic>> list, int type) {
    bool agree = item["agree"];
    String name = "";

    if (type == 1) {
      name = item["provinceName"];
      // item["province"];
    } else {
      name = item["drivingLicenseName"];
      // item["drivingLicense"];
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          decoration: BoxDecoration(
            color: agree ? CustomColors.colorF6FAFF : const Color(0x0D999999),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 18,
            top: 12,
            right: 18,
            bottom: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name.isNotEmpty ? name : title,
                  style: TextStyle(
                    color:
                        agree ? CustomColors.darkGrey : CustomColors.darkGrey99,
                    fontSize: 14,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFCDCDCD),
              )
            ],
          ),
        ),
        items: [
          ...list.map(
            (item) {
              // bool enabled = toLock.contains(item.title);
              bool select = false;
              var item2 = item["name"];
              if (item2 == title) {
                select = true;
              }
              return DropdownMenuItem<Map<String, dynamic>>(
                value: item,
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  width: double.infinity,
                  color: select ? CustomColors.colorF6FAFF : Colors.white,
                  child: Row(
                    children: [
                      Text(
                        item2,
                        style: TextStyle(
                          color: select
                              ? CustomColors.connectColor
                              : CustomColors.greyBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        onChanged: (value) {
          var value2 = value as Map<String, dynamic>;
          if (type == 1) {
            item["provinceName"] = value2["name"];
            item["province"] = value2["value"];
          } else {
            item["drivingLicenseName"] = value2["name"];
            item["drivingLicense"] = value2["val"];
          }
          setState(() {});
        },
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          isOverButton: true,
          width: ScreenTool.screenWidth - 32,
          padding: const EdgeInsets.symmetric(vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          elevation: 4,
          offset: const Offset(0, 4),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.all(0),
        ),
      ),
    );
  }

  void _toBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250), curve: Curves.ease);
    });
  }

  void _extractData() {
    if (textNameController.text.isEmpty) {
      ToastUtils.showMessage("请输入姓名");
      return;
    }
    putMap["name"] = textNameController.text.toString();
    if (textIdController.text.isEmpty) {
      ToastUtils.showMessage("请输入身份证号");
      return;
    }
    putMap["idNo"] = textIdController.text.toString();
    if (academicQualifications) {
      if (_getAcademicQualifications() == "学历层次") {
        ToastUtils.showMessage("请选择学历层次");
        return;
      }
      if (academicQualificationsController.text.isEmpty) {
        ToastUtils.showMessage("请输入学历层次17或18位编号");
        return;
      }
      putMap["diplomaNumber"] =
          academicQualificationsController.text.toString();
    }
    if (bachelorOfScience) {
      if (_getBachelorOfScience() == "学位类型") {
        ToastUtils.showMessage("请选择学位类型");
        return;
      }
      if (bachelorOfScienceController.text.isEmpty) {
        ToastUtils.showMessage("请输入学位类型16或17位编号");
        return;
      }
      putMap["certificateNumber"] = bachelorOfScienceController.text.toString();
    }
    for (var item in certificate) {
      bool agree = item["agree"];
      String title = item["title"];
      if (agree) {
        //选中了
        switch (title) {
          case "法律职业资格证":
            String content = item["content"];
            if (content.isEmpty) {
              ToastUtils.showMessage("请输入法律职业资格证书编号");
              return;
            }
            putMap["certificateNum"] = content;
            break;
          case "教师资格证":
            String content = item["content"];
            if (content.isEmpty) {
              ToastUtils.showMessage("请输入教师资格证书编号");
              return;
            }
            putMap["teacherCertificateNo"] = content;
            break;
          case "会计专业资格证":
            //请选择报考级别
            String level = item["level"];
            if (level.isEmpty) {
              ToastUtils.showMessage("请选择报考级别");
              return;
            }
            if (level == "初级") {
              putMap["examinationLevel"] = "2";
            } else if (level == "中级") {
              putMap["examinationLevel"] = "1";
            } else {
              putMap["examinationLevel"] = "无";
            }
            //请选择报考年份
            String particularYear = item["particularYear"];
            if (particularYear.isEmpty) {
              ToastUtils.showMessage("请选择报考年份");
              return;
            }
            putMap["examinationYear"] = particularYear;
            //请选择报考省份
            String provinceName = item["provinceName"];
            String province = item["province"];
            if (province.isEmpty) {
              ToastUtils.showMessage("请选择报考省份");
              return;
            }
            putMap["examinationProvince"] = province;
            break;
          case "行驶证":
            //请选择号牌种类
            String drivingLicenseName = item["drivingLicenseName"];
            String drivingLicense = item["drivingLicense"];
            if (drivingLicense.isEmpty) {
              ToastUtils.showMessage("请选择号牌种类");
              return;
            }
            putMap["plateType"] = drivingLicense;
            //请选择车牌号
            String content = item["content"];
            if (content.isEmpty) {
              ToastUtils.showMessage("请选择车牌号");
              return;
            }
            putMap["plateNo"] = drivingLicense;
            break;
          case "英语四六级":
            //请选择考试等级
            String englishLevel = item["englishLevel"];
            if (englishLevel.isEmpty) {
              ToastUtils.showMessage("请选择考试等级");
              return;
            }
            //请输入成绩单号
            String content = item["content"];
            if (content.isEmpty) {
              ToastUtils.showMessage("请输入成绩单号");
              return;
            }
            if (englishLevel == "四级") {
              putMap["CETA4"] = content;
            } else if (englishLevel == "六级") {
              putMap["CETA6"] = content;
            }
            break;
        }
      }
    }
    // putMap["reportType"] = widget.type.toString();
    Log.i("---${putMap.toString()}");
    _showTip();
  }

  _showTip() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return UnconstrainedBox(
          constrainedAxis: Axis.horizontal,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 38, right: 38),
            padding: const EdgeInsets.only(top: 26),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "提示",
                  style: TextStyle(
                    color: CustomColors.greyBlack,
                    fontSize: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(28),
                  child: Text(
                    "请再次确认所填写的信息，一经提交后，将不能修改",
                    style: TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: CustomColors.lightGreyFB,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Center(
                            child: Text(
                              "取消",
                              style: TextStyle(
                                fontSize: 16,
                                color: CustomColors.greyBlack,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: CustomColors.lightGreyFB,
                    ),
                    Expanded(
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            ///reportAuth/messagePrepareSign
                            ///
                            if (PlatformUtils.isWeb) {
                              putMap["appScheme"] =
                                  "http://m.dev.nowcheck.cn:8989/empowerPage?authId=${widget.reportAuthId}";
                            } else {
                              putMap["appScheme"] = "esign://hyc/signBack";
                            }
                            EmpowerManager.getMessagePrepareSign(putMap, (map) {
                              arouseSign(map.toString());
                            });
                          },
                          child: const Center(
                            child: Text(
                              "确认",
                              style: TextStyle(
                                fontSize: 16,
                                color: CustomColors.connectColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void arouseSign(String url) {
    if (PlatformUtils.isWeb) {
      NativeJSUtlis.openEmpower(url);
    } else {
      NativeUtils.toolsMethodChannelMethodWithParams("CertificationProcess",
          params: {
            "context": "AuthorSign",
            "url": url,
          }).then((value) {
        if (value.containsKey("result")) {

          Log.e("------------------------");
          Navigator.of(context)
            ..pop()
            ..pop()
            ..pop("renovate");

          bool result = value["result"];
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TrailerPage(
                type: result ? 1 : 2,
              ),
            ),
          );
        }
      });
    }
  }

  /// *
  /// -  @description: 处理ios授权回调
  /// -  @Date: 2023-03-24 14:35
  /// -  @parm:
  /// -  @return {*}
  void _processingCallback(Map map) {
    Navigator.of(context)
      ..pop()
      ..pop()
      ..pop("renovate");
    bool result = map["result"];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrailerPage(
          type: result ? 1 : 2,
        ),
      ),
    );
  }

  Widget _redundancy() {
    if (widget.type == 5) {
      return const SizedBox();
    } else {
      return Column(
        children: [
          Row(
            children: [
              Container(
                height: 14,
                width: 3,
                decoration: const BoxDecoration(
                  color: CustomColors.connectColor,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                "教育经历",
                style: TextStyle(
                  color: CustomColors.greyBlack,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                "（选填）",
                style: TextStyle(
                  color: CustomColors.darkGrey99,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: CustomColors.darkGreyE5,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    academicQualifications = !academicQualifications;
                  });
                },
                child: Image(
                  width: 15,
                  height: 15,
                  image: academicQualifications == false
                      ? const AssetImage("assets/images/radioNormal.png")
                      : const AssetImage("assets/images/radioSelectBlue.png"),
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                "高等教育学历信息",
                style: TextStyle(
                  color: CustomColors.darkGrey99,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          _selectItem(academicQualifications, _getAcademicQualifications(),
              academicQualificationsList),
          _selectItemInput(academicQualifications, "请输入17或18位编号",
              academicQualificationsController, [], TextInputType.text),
          const SizedBox(height: 5),
          Row(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    bachelorOfScience = !bachelorOfScience;
                  });
                },
                child: Image(
                  width: 15,
                  height: 15,
                  image: bachelorOfScience == false
                      ? const AssetImage("assets/images/radioNormal.png")
                      : const AssetImage("assets/images/radioSelectBlue.png"),
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                "高等教育学位信息",
                style: TextStyle(
                  color: CustomColors.darkGrey99,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          _selectItem(bachelorOfScience, _getBachelorOfScience(),
              bachelorOfScienceList),
          _selectItemInput(bachelorOfScience, "请输入16或17位编号",
              bachelorOfScienceController, [], TextInputType.text),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                height: 14,
                width: 3,
                decoration: const BoxDecoration(
                  color: CustomColors.connectColor,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                "资格证书信息",
                style: TextStyle(
                  color: CustomColors.greyBlack,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                "（选填）",
                style: TextStyle(
                  color: CustomColors.darkGrey99,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: CustomColors.darkGreyE5,
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var item = certificate[index];
              String title = item["title"];
              bool agree = item["agree"];
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Log.i("list-------${agree}");
                          setState(() {
                            item["agree"] = !agree;
                          });
                        },
                        child: Image(
                          width: 15,
                          height: 15,
                          image: agree == false
                              ? const AssetImage(
                                  "assets/images/radioNormal.png")
                              : const AssetImage(
                                  "assets/images/radioSelectBlue.png"),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "证书信息",
                        style: TextStyle(
                          color: CustomColors.darkGrey99,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _listSelectItem(agree, item, certificateList),
                  _addItemSelectInput(item),
                ],
              );
            },
            itemCount: certificate.length,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_box_outlined),
                color: const Color(0xFFC7C7C7),
                onPressed: () {
                  certificate.add({
                    "title": "请选择证书",
                    "agree": true,
                    "content": "",
                    "level": "",
                    "particularYear": "",
                    "provinceName": "",
                    "province": "",
                    "drivingLicenseName": "",
                    "drivingLicense": "",
                    "englishLevel": "",
                  });
                  setState(() {});
                  _toBottom();
                },
              ),
            ],
          ),
        ],
      );
    }
  }
}

class MenuItem {
  //标题
  String title;

  //选中
  bool select = false;

  MenuItem({
    required this.title,
  });
}
