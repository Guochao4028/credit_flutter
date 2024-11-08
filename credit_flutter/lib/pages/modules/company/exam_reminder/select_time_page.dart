// import 'dart:ffi';

import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../define/define_colors.dart';

class SelectTimePage extends StatefulWidget {
  int remind;

  SelectTimePage({Key? key, required this.remind}) : super(key: key);

  @override
  State<SelectTimePage> createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage> {
  var item = 0;
  var title = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isInput = false;

  @override
  void initState() {
    super.initState();
    //输入框焦点监测
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        //得到焦点
        item = -1;
        isInput = true;
        refreshPage();
      }
    });
    item = widget.remind;
    refreshPage();
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
          "提醒设置",
          style: TextStyle(
            color: CustomColors.greyBlack,
            fontSize: 17,
          ),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
                  // width: double.infinity,
                  // height: 28,
                  padding: const EdgeInsets.only(
                      left: 5, top: 3, right: 5, bottom: 3),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: CustomColors.connectColor,
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  ),
                  child: const Text(
                    "完成",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                onTap: () {
                  var data = 0;
                  if (isInput) {
                    //手动输入
                    if (title.text.isNotEmpty) {
                      data = int.parse(title.text.toString());
                    } else {
                      ToastUtils.showMessage("请输入自定义提醒时间");
                      return;
                    }
                  } else {
                    data = item;
                  }
                  Navigator.pop(context, data);
                },
              )
            ],
          ),
          const SizedBox(
            width: 18,
          ),
        ],
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
              child: Container(
                padding: const EdgeInsets.only(left: 18, top: 10, bottom: 10),
                child: Column(
                  children: [
                    const Text(
                      "设定提醒时间后，会在距离这个事件有多少天将提醒到您",
                      style: TextStyle(
                        color: CustomColors.darkGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //设置四周圆角 角度
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        //设置四周边框
                        border: Border.all(
                          width: 1,
                          color: CustomColors.colorC3C3C3,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: InkWell(
                              onTap: () {
                                item = 0;
                                refreshPage();
                                closeKeyboard(context);
                              },
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "未设置",
                                    style: TextStyle(
                                      color: item == 0
                                          ? CustomColors.connectColor
                                          : CustomColors.greyBlack,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  if (item == 0)
                                    const Image(
                                      image: AssetImage(
                                          "assets/images/icon_check_mark1.png"),
                                      width: 16,
                                      height: 16,
                                    ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: CustomColors.colorC3C3C3,
                          ),
                          SizedBox(
                            height: 40,
                            child: InkWell(
                              onTap: () {
                                item = 1;
                                refreshPage();
                                closeKeyboard(context);
                              },
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "提前一天",
                                    style: TextStyle(
                                      color: item == 1
                                          ? CustomColors.connectColor
                                          : CustomColors.greyBlack,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  if (item == 1)
                                    const Image(
                                      image: AssetImage(
                                          "assets/images/icon_check_mark1.png"),
                                      width: 16,
                                      height: 16,
                                    ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: CustomColors.colorC3C3C3,
                          ),
                          SizedBox(
                            height: 40,
                            child: InkWell(
                              onTap: () {
                                item = 3;
                                refreshPage();
                                closeKeyboard(context);
                              },
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "提前三天",
                                    style: TextStyle(
                                      color: item == 3
                                          ? CustomColors.connectColor
                                          : CustomColors.greyBlack,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  if (item == 3)
                                    const Image(
                                      image: AssetImage(
                                          "assets/images/icon_check_mark1.png"),
                                      width: 16,
                                      height: 16,
                                    ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: CustomColors.colorC3C3C3,
                          ),
                          SizedBox(
                            height: 40,
                            child: InkWell(
                              onTap: () {
                                item = 7;
                                refreshPage();
                                closeKeyboard(context);
                              },
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "提前七天",
                                    style: TextStyle(
                                      color: item == 7
                                          ? CustomColors.connectColor
                                          : CustomColors.greyBlack,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  if (item == 7)
                                    const Image(
                                      image: AssetImage(
                                          "assets/images/icon_check_mark1.png"),
                                      width: 16,
                                      height: 16,
                                    ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: CustomColors.colorC3C3C3,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 16, top: 10, right: 16, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    focusNode: _focusNode,
                                    onChanged: (text) {},
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(3),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    controller: title,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(0),
                                      isCollapsed: true,
                                      hintText: "自定义提醒时间",
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: CustomColors.darkGrey,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isInput)
                                  const Image(
                                    image: AssetImage(
                                        "assets/images/icon_check_mark1.png"),
                                    width: 16,
                                    height: 16,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void refreshPage() {
    setState(() {});
  }

  /// 键盘是否是弹起状态
  void closeKeyboard(BuildContext context) {
    isInput = false;
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  //页面销毁
  @override
  void dispose() {
    super.dispose();
    //释放
    _focusNode.dispose();
  }
}
