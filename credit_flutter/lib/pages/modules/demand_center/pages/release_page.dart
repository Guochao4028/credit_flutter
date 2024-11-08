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
import 'package:credit_flutter/manager/demand_center_manager.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/utils/event_bus.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../define/define_colors.dart';

class ReleasePage extends StatefulWidget {
  const ReleasePage({Key? key}) : super(key: key);

  @override
  State<ReleasePage> createState() => _ReleasePageState();
}

class _ReleasePageState extends State<ReleasePage> {
  var titleLicense = TextEditingController();
  var phoneLicense = TextEditingController();
  var numberLicense = TextEditingController();
  var contentLicense = TextEditingController();

  var day = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.colorEDF6F6,
      child: Stack(
        children: [
          const Image(
            image: AssetImage("assets/images/icon_demand_release_bg.png"),
            width: double.infinity,
            height: 460,
            fit: BoxFit.fill,
          ),
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "需求发布",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
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
            backgroundColor: Colors.transparent,
            body: BaseBody(
              child: ListView(
                children: [
                  SizedBox(
                    height: 126,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 29,
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "背调需求发布",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "发布委托背调需求，让更多的人帮你解决。",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )),
                        const Image(
                          image: AssetImage(
                              "assets/images/icon_demand_release.png"),
                          width: 126,
                          height: 126,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 29,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 44,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFCDECFE),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                    ),
                    child: const Center(
                      child: Text(
                        "需求发布",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    padding: const EdgeInsets.only(
                        left: 12, top: 16, right: 12, bottom: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6)),
                    ),
                    child: Column(
                      children: [
                        _addInputBox("请输入您的需求标题（必填）", titleLicense, 100,
                            TextInputType.text),
                        _addInputBox("请输入您的电话（必填）", phoneLicense, 11,
                            TextInputType.phone),
                        _addInputBox("请输入您的预算金额", numberLicense, 10,
                            TextInputType.number),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              left: 14, top: 8, right: 14, bottom: 8),
                          decoration: const BoxDecoration(
                            color: Color(0x3DDFE8ED),
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "需求时效",
                                style: TextStyle(
                                  color: CustomColors.darkGrey99,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              _addDay(3),
                              const SizedBox(
                                width: 10,
                              ),
                              _addDay(5),
                              const SizedBox(
                                width: 10,
                              ),
                              _addDay(7),
                            ],
                          ),
                        ),
                        _addInputBoxBig("请输入您的具体需求（必填）", contentLicense, 500,
                            TextInputType.text),
                        _submit(),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        left: 16, top: 10, right: 16, bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "免责声明",
                          style: TextStyle(
                            color: CustomColors.darkGrey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "1.慧眼查不承担用户因使用这些资源对自己和他人造成任何形式的损失或伤害；",
                          style: TextStyle(
                            color: CustomColors.darkGrey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "2.不可以发布违规内容，发布内容如被他人举报，强制下架您所发布的内容；",
                          style: TextStyle(
                            color: CustomColors.darkGrey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "3.请用户自觉遵守互联网相关的政策法规，禁止发布违法信息及政治敏感等言论；",
                          style: TextStyle(
                            color: CustomColors.darkGrey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "4.本声明未涉及的问题参见国家有关法律法规，当本声明与国家法律法规冲突时，以国家法律法规为准。",
                          style: TextStyle(
                            color: CustomColors.darkGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _addInputBox(String title, TextEditingController controller, int number,
      TextInputType text) {
    InputDecoration inputDecoration = InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(0),
      isCollapsed: true,
      hintText: title,
      hintStyle: const TextStyle(
        fontSize: 15,
        color: CustomColors.darkGrey99,
      ),
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 14, top: 8, right: 14, bottom: 8),
      decoration: const BoxDecoration(
        color: Color(0x3DDFE8ED),
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: TextField(
        onChanged: (text) {},
        keyboardType: text,
        textAlign: TextAlign.start,
        maxLines: 1,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(number),
          if (number == 10) FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        ],
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: inputDecoration,
      ),
    );
  }

  _addInputBoxBig(String title, TextEditingController controller, int number,
      TextInputType text) {
    InputDecoration inputDecoration = InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(0),
      isCollapsed: true,
      hintText: title,
      hintStyle: const TextStyle(
        fontSize: 15,
        color: CustomColors.darkGrey99,
      ),
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 14, top: 8, right: 14, bottom: 8),
      decoration: const BoxDecoration(
        color: Color(0x3DDFE8ED),
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: TextField(
        onChanged: (text) {},
        keyboardType: text,
        textAlign: TextAlign.start,
        minLines: 4,
        maxLines: 14,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(number),
        ],
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: inputDecoration,
      ),
    );
  }

  _addDay(int type) {
    Image selectImage = Image(
      width: 16,
      height: 16,
      image: day == type
          ? const AssetImage("assets/images/icon_select.png")
          : const AssetImage("assets/images/icon_unchecked.png"),
    );

    return InkWell(
      onTap: () {
        day = type;
        setState(() {});
      },
      child: Row(
        children: [
          selectImage,
          SizedBox(
            width: 7,
          ),
          Text(
            "$type天",
            style: const TextStyle(
              color: CustomColors.darkGrey99,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  _submit() {
    return InkWell(
      onTap: () {
        if (titleLicense.text.isEmpty) {
          ToastUtils.showMessage("请输入您的需求标题（必填）");
          return;
        }
        if (phoneLicense.text.isEmpty) {
          ToastUtils.showMessage("请输入您的电话（必填）");
          return;
        }
        var verifyPhoneNumber = RegexUtils.verifyPhoneNumber(phoneLicense.text);
        if (!verifyPhoneNumber) {
          ToastUtils.showMessage("请填写正确的电话号码");
          return;
        }
        if (contentLicense.text.isEmpty) {
          ToastUtils.showMessage("请输入您的具体需求（必填）");
          return;
        }

        Map<String, dynamic> pame = {
          "title": titleLicense.text.toString().trim(),
          "phone": phoneLicense.text.toString().trim(),
          "budget": numberLicense.text.toString().trim(),
          "days": day,
          "description": contentLicense.text.toString().trim(),
        };
        DemandCenterManager.putDemandCenterSave(pame, (data) {
          bus.emit("add_release", data);
          bus.emit("switch_pages", data);
          Navigator.of(context).pop();
        });
      },
      child: Container(
        width: double.infinity,
        height: 44,
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: CustomColors.connectColor,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: const Center(
          child: Text(
            "立即发布",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
