import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/pages/modules/company/exam_reminder/select_time_page.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../define/define_colors.dart';

class EditReminderPage extends StatefulWidget {
  //1创建  2编辑
  final int type;
  final int keyID;

  const EditReminderPage({Key? key, required this.type, required this.keyID})
      : super(key: key);

  @override
  State<EditReminderPage> createState() => _EditReminderPageState();
}

class _EditReminderPageState extends State<EditReminderPage>
    implements ClickListener {
  var titleName = TextEditingController();

  bool currentState = false;
  bool flag = false;

  var remind = 3;
  var time = "";
  var now = DateTime.now();
  DateTime? current;
  DateTime? cache;

  String DATE_FORMAT = 'yyyy年|M月|d日';

  //1:删除 2:置顶
  var type = 0;

  @override
  void initState() {
    //初始化主页面
    super.initState();
    time = formatDate(now, ['yyyy', '-', 'mm', '-', 'dd']);
    _initView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          alignment: Alignment.centerRight,
          color: CustomColors.greyBlack,
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          "编辑",
          style: TextStyle(
            color: CustomColors.greyBlack,
            fontSize: 17,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 16,
          top: 10,
          right: 16,
          bottom: 10,
        ),
        color: CustomColors.colorEDF6F6,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        const Image(
                          image:
                              AssetImage("assets/images/icon_event_title.png"),
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (text) {},
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(20),
                              FilteringTextInputFormatter.deny(RegExp(
                                  "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"))
                            ],
                            controller: titleName,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                              isCollapsed: true,
                              hintText: "请输入标题",
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: CustomColors.darkGrey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: const Color(0xFF979797),
                  ),
                  SizedBox(
                    height: 50,
                    child: InkWell(
                      onTap: () {
                        closeKeyboard(context);
                        _showPicker();
                      },
                      child: Row(
                        children: [
                          const Image(
                            image:
                                AssetImage("assets/images/icon_event_date.png"),
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            "日期",
                            style: TextStyle(
                              color: CustomColors.greyBlack,
                              fontSize: 15,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              time,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: CustomColors.connectColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: CustomColors.greyBlack,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: const Color(0xFF979797),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        const Image(
                          image: AssetImage("assets/images/icon_event_top.png"),
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          "置顶",
                          style: TextStyle(
                            color: CustomColors.greyBlack,
                            fontSize: 15,
                          ),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Switch(
                            value: flag,
                            onChanged: (value) {
                              if (currentState) {
                                //当前是置顶的
                                operationButton();
                              } else {
                                //当前不是置顶
                                if (value) {
                                  ifOtherTopping();
                                } else {
                                  //不是置顶要取消
                                  operationButton();
                                }
                              }
                            })
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: const Color(0xFF979797),
                  ),
                  SizedBox(
                    height: 50,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                SelectTimePage(remind: remind),
                          ),
                        )
                            .then((value) {
                          if (value != null) {
                            remind = value;
                            refreshPage();
                          }
                        });
                      },
                      child: Row(
                        children: [
                          const Image(
                            image: AssetImage(
                                "assets/images/icon_event_reminder.png"),
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            "提醒",
                            style: TextStyle(
                              color: CustomColors.greyBlack,
                              fontSize: 15,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              getTime(),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: CustomColors.connectColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: CustomColors.greyBlack,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _submit(),
            if (widget.type == 2) _delete(),
          ],
        ),
      ),
    );
  }

  void _initView() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList = sp.getStringList(FinalKeys.SHARED_EVENT_REMINDER);
      if (strList != null) {
        for (var map in strList) {
          Map<String, dynamic> bean = StringTools.json2Map(map);
          if (bean["key"] == widget.keyID) {
            titleName.text = bean["title"];
            remind = bean["remind"];
            flag = bean["topping"];
            currentState = flag;
            time = bean["time"];
          }
        }
        refreshPage();
      }
    });
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
                  // minDateTime: DateTime.parse(MIN_DATETIME),
                  maxDateTime: DateTime(now.year + 10, now.month, now.day),
                  minDateTime: now,
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
              SizedBox(
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
                              current = cache;
                              time = formatDate(current ?? DateTime.now(),
                                  ['yyyy', '-', 'mm', '-', 'dd']);
                              Navigator.of(context).pop();
                              refreshPage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void refreshPage() {
    setState(() {});
  }

  /// 键盘是否是弹起状态
  void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  InkWell _submit() {
    return InkWell(
      child: Container(
        width: double.infinity,
        height: 49,
        margin: const EdgeInsets.only(top: 25, bottom: 18),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24.5)),
          child: Container(
            color: CustomColors.connectColor,
            width: double.infinity,
            height: 49,
            alignment: Alignment.center,
            child: const Text(
              "保存",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        if (titleName.text.isEmpty) {
          ToastUtils.showMessage("请输入标题");
          return;
        }
        if (widget.type == 2) {
          modifyDataModel();
        } else {
          saveDataModel();
        }
      },
    );
  }

  InkWell _delete() {
    return InkWell(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24.5)),
        child: Container(
          color: CustomColors.colorE20000,
          width: double.infinity,
          height: 49,
          alignment: Alignment.center,
          child: const Text(
            "删除",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
      onTap: () {
        type = 1;
        showDialog(
            context: context,
            builder: (context) {
              return PopupWindowDialog(
                title: "提示",
                confirm: "确认",
                cancel: "取消",
                content: "是否删除",
                clickListener: this,
              );
            });
      },
    );
  }

  String getTime() {
    switch (remind) {
      case 0:
        return "当天提醒";
      default:
        return "提前$remind天";
    }
  }

  void saveDataModel() {
    var dateTime = DateTime.now();
    Map<String, dynamic> newsMap = {
      "key": dateTime.millisecondsSinceEpoch,
      "title": titleName.text.toString().trim(),
      "time": time,
      "topping": flag,
      "remind": remind,
    };
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList = sp.getStringList(FinalKeys.SHARED_EVENT_REMINDER);
      if (strList != null) {
        List<String> dataList = [];
        if (flag) {
          //取消其他置顶
          for (var map in strList) {
            dataList.add(map.replaceAll("true", "false"));
          }
        } else {
          dataList.addAll(strList);
        }
        dataList.add(StringTools.map2Json(newsMap));
        sp.setStringList(FinalKeys.SHARED_EVENT_REMINDER, dataList);
      } else {
        strList = [];
        strList.add(StringTools.map2Json(newsMap));
        sp.setStringList(FinalKeys.SHARED_EVENT_REMINDER, strList);
      }
      ToastUtils.showMessage("保存成功");
      Navigator.of(context)
        ..pop("success")
        ..pop("success");
    });
  }

  void modifyDataModel() {
    Map<String, dynamic> newsMap = {
      "key": widget.keyID,
      "title": titleName.text.toString().trim(),
      "time": time,
      "topping": flag,
      "remind": remind,
    };
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList = sp.getStringList(FinalKeys.SHARED_EVENT_REMINDER);
      if (strList != null) {
        List<String> dataList = [];
        if (flag) {
          //取消其他置顶
          for (var map in strList) {
            dataList.add(map.replaceAll("true", "false"));
          }
        } else {
          dataList.addAll(strList);
        }

        List<String> modifyList = [];
        for (var mmp in dataList) {
          Map tem = StringTools.json2Map(mmp);
          if (tem["key"] == widget.keyID) {
            continue;
          }
          modifyList.add(mmp);
        }
        modifyList.add(StringTools.map2Json(newsMap));
        sp.setStringList(FinalKeys.SHARED_EVENT_REMINDER, modifyList);
      }
      ToastUtils.showMessage("保存成功");
      Navigator.of(context).pop("success");
    });
  }

  /// *
  /// -  @description: 取消收藏
  /// -  @Date: 2022-06-24 18:16
  /// -  @parm:
  /// -  @return {*}
  ///
  void cancelDataModel() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList = sp.getStringList(FinalKeys.SHARED_EVENT_REMINDER);
      List<String> temStrList = [];
      if (strList != null) {
        for (var i = 0; i < strList.length; i++) {
          String str = strList[i];
          Map tem = StringTools.json2Map(str);
          int id = tem["key"];
          if (id == widget.keyID) {
            continue;
          }
          temStrList.add(str);
        }
      }
      sp.setStringList(FinalKeys.SHARED_EVENT_REMINDER, temStrList);
      ToastUtils.showMessage("删除成功");
      Navigator.of(context).pop("success");
    });
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> confirmMap) {
    if (type == 1) {
      cancelDataModel();
    } else if (type == 2) {
      operationButton();
    }
  }

  void ifOtherTopping() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList = sp.getStringList(FinalKeys.SHARED_EVENT_REMINDER);
      if (strList != null) {
        for (var i = 0; i < strList.length; i++) {
          String str = strList[i];
          var contains = str.contains('"topping":true');
          if (contains) {
            //有置顶
            _showDialog();
            return;
          }
        }
        operationButton();
      } else {
        operationButton();
      }
    });
  }

  void _showDialog() {
    type = 2;
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            contentEdgeInsets: const EdgeInsets.only(left: 15, right: 15),
            title: "提示",
            confirm: "确认",
            cancel: "取消",
            content: "已有置顶内容，确定要替换当前置顶内容吗？",
            clickListener: this,
          );
        });
  }

  void operationButton() {
    setState(() {
      flag = !flag;
    });
  }
}
