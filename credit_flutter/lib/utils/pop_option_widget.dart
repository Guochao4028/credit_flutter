/// *
/// -  @Date: 2022-06-16 14:24
/// -  @LastEditTime: 2022-09-19 14:02
/// -  @Description:首页
///
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:flutter/material.dart';

import '../../../define/define_colors.dart';

class PopOptionWidget extends StatefulWidget {
  String titleStr;
  String imagePath;
  String hintText;
  String textIconPath;
  String instructions;
  String identify;
  PopOptionWidgetClickListener? pClickListener;

  PopOptionWidget({
    Key? key,
    this.titleStr = "",
    this.imagePath = "",
    this.hintText = "",
    this.textIconPath = "",
    this.instructions = "",
    this.pClickListener,
    this.identify = "",
  }) : super(key: key);

  @override
  State<PopOptionWidget> createState() => _PopOptionWidgetState();
}

abstract class PopOptionWidgetClickListener {
  void onAffirm(Map<String, dynamic> confirmMap);
}

class _PopOptionWidgetState extends State<PopOptionWidget> {
  final textController = TextEditingController();
  String errorStr = "";
  String contentStr = "";

  @override
  Widget build(BuildContext context) {
    double imageHeight = 129, imageWidth = 160;
    if (widget.identify == "share") {
      imageWidth = 173;
      imageHeight = 107;
    }

    return InkWell(
      onTap: () => {
        Navigator.of(context).pop(),
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(116, 0, 0, 0),
        body: BaseBody(
            child: Center(
          child: Container(
            width: 300,
            height: 378,
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///关闭按钮
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    alignment: Alignment.centerRight,
                    icon: const Icon(Icons.close_outlined),
                    iconSize: 26,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),

                ///图片
                Image.asset(
                  widget.imagePath,
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.fill,
                ),

                Text(
                  widget.titleStr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                inputTextFiled(
                  widget.hintText,
                  widget.textIconPath,
                  textController,
                  TextInputType.text,
                ),

                addErrorPrompt(errorStr),

                Container(
                  margin: const EdgeInsets.only(top: 6, bottom: 15),
                  padding: const EdgeInsets.only(left: 17, right: 17),
                  child: Text(
                    widget.instructions,
                    style: const TextStyle(
                      fontSize: 15,
                      color: CustomColors.lightGrey,
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    if (widget.identify == "download") {
                      ///校验邮箱是否正确
                      if (contentStr.isEmpty) {
                        errorStr = "邮箱不能为空";
                        setState(() {
                          return;
                        });
                      }
                      if (!StringTools.isEmail(contentStr)) {
                        errorStr = "邮箱格式错误";
                        setState(() {});
                      } else {
                        widget.pClickListener?.onAffirm(
                            {"id": widget.identify, "contentStr": contentStr});
                        Navigator.of(context).pop();
                      }
                    } else {
                      if (contentStr.isEmpty) {
                        errorStr = "授权码不能为空";
                        setState(() {});
                      } else {
                        widget.pClickListener?.onAffirm(
                            {"id": widget.identify, "contentStr": contentStr});
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: SizedBox(
                    width: 245,
                    height: 35,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      child: Container(
                        color: CustomColors.lightBlue,
                        width: double.infinity,
                        height: double.infinity,
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "发送",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget inputTextFiled(
    String hintText,
    String iconPath,
    TextEditingController textEditingController,
    TextInputType inputType,
  ) {
    InputDecoration decoration = InputDecoration(
      isCollapsed: true,
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      icon: Image(
        image: AssetImage(iconPath),
        width: 18,
        height: 18,
      ),
    );

    TextField textField = TextField(
      controller: textEditingController,
      onChanged: (str) {
        contentStr = str;
        errorStr = "";
        setState(() {});
      },
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: inputType,
      maxLines: 1,
      decoration: decoration,
    );

    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.only(
        left: 16,
        top: 0,
        right: 16,
        bottom: 0,
      ),
      child: Container(
        // height: 35,
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColors.lightGrey,
            width: 0.5,
          ),
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        padding: const EdgeInsets.only(left: 16, top: 7, right: 16, bottom: 7),
        child: textField,
      ),
    );
  }

  Widget addErrorPrompt(String title) {
    return Offstage(
      offstage: StringTools.isEmpty(title),
      child: Container(
        padding: const EdgeInsets.only(left: 17),
        alignment: Alignment.centerLeft,
        height: 15,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: CustomColors.warningColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
