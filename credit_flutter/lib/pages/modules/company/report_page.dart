import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/modules/company/report_manager.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';

class ReportPage extends StatefulWidget {
  final String id;

  //1：公司详情举报/2：意见反馈/3：需求详情举报
  final String type;

  const ReportPage({Key? key, required this.id, required this.type})
      : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Map<String, dynamic>> infoList = [
    {
      "name": "垃圾广告",
      "isSelect": true,
      "isLine": false,
    },
    {
      "name": "违法信息",
      "isSelect": false,
      "isLine": false,
    },
    {
      "name": "人身攻击",
      "isSelect": false,
      "isLine": false,
    },
    {
      "name": "其他",
      "isSelect": false,
      "isLine": true,
    },
  ];

  var businessLicense = TextEditingController();

  var reportPicture = "";

  @override
  void initState() {
    super.initState();
    var platform = ImagePicker.platform;
    if (platform is ImagePickerAndroid) {
      platform.useAndroidPhotoPicker = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    String hint =
        widget.type == "2" ? "请简要叙述您的问题和意见，已便于我们提供更好的帮助" : "补充或截图，加快您的审核结果（选填）";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.connectColor,
        titleSpacing: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          alignment: Alignment.centerRight,
          color: Colors.white,
          onPressed: () => Navigator.pop(context, true),
        ),
        title: Text(
          widget.type == "2" ? "意见反馈" : "举报",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
      body: BaseBody(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ifAdd(),
                  Container(
                    height: 10,
                    color: CustomColors.lightGreyFB,
                  ),
                  Container(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      minLines: 3,
                      maxLines: 10,
                      textAlign: TextAlign.start,
                      onChanged: (text) {
                        setState(() {});
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(100),
                        FilteringTextInputFormatter.deny(
                          RegExp(
                              "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"),
                        ),
                      ],
                      controller: businessLicense,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(0),
                        isCollapsed: true,
                        hintText: hint,
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: CustomColors.lightGrey,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${businessLicense.text.length}/100",
                        style: const TextStyle(
                            fontSize: 12, color: CustomColors.lightGrey),
                      ),
                      const SizedBox(
                        width: 18.0,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      _ReportPicture(() {
                        _selectMode();
                      }),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.type == "2") {
                        if (businessLicense.text.toString().isEmpty) {
                          ToastUtils.showMessage("请填写要反馈的内容");
                          return;
                        }
                      }
                      if (widget.type == "3") {
                        ReportManager.demandCenterReport({
                          "id": widget.id,
                          "reportDetail": businessLicense.text.toString()
                        }, (message) {
                          ToastUtils.showMessage("举报成功");
                          Navigator.of(context)
                            ..pop("success")
                            ..pop("success");
                        });
                      } else {
                        ReportManager.commonTip({"text": "", "type": "其他"},
                            (message) {
                          if (widget.type == "2") {
                            ToastUtils.showMessage("反馈成功");
                          } else {
                            ToastUtils.showMessage("举报成功");
                          }
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 16, top: 35, right: 16),
                      width: double.infinity,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: CustomColors.connectColor,
                        borderRadius: BorderRadius.all(Radius.circular(22.5)),
                      ),
                      child: Center(
                        child: Text(
                          widget.type == "2" ? "反馈" : "举报",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _ReportPicture(GestureTapCallback callback) {
    if (reportPicture.isEmpty) {
      return InkWell(
        onTap: callback,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
            //设置四周边框
            border: Border.all(width: 1, color: CustomColors.colorE0E0E0),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/icon_camera.png"),
                width: 24,
                height: 24,
              ),
              Text(
                "添加照片",
                style: TextStyle(fontSize: 12, color: CustomColors.darkGrey99),
              )
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: callback,
        child: Image(
          image: NetworkImage(reportPicture),
          width: 72,
          height: 72,
        ),
      );
    }
  }

  void _selectMode() {
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
                                _photograph();
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
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: CustomColors.colorD1D1D1,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _photoAlbum();
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),

                // CupertinoDialogAction(
                //
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
              ],
            ),
          );
        },
      );
    }
  }

  void _photograph() {
    ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        ReportManager.uploadFile(value.path, (message) {
          reportPicture = message;
          setState(() {});
        });
      }
    });
  }

  void _photoAlbum() {
    ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        ReportManager.uploadFile(value.path, (message) {
          reportPicture = message;
          setState(() {});
        });
      }
    });
  }

  Widget ifAdd() {
    if (widget.type != "1") {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var info = infoList[index];
          return WidgetTools().showReportItem(context, info, () {
            setState(() {
              for (var item in infoList) {
                item["isSelect"] = false;
              }
              info["isSelect"] = true;
            });
          });
        },
        itemCount: infoList.length,
      );
    } else {
      return const SizedBox();
    }
  }
}
