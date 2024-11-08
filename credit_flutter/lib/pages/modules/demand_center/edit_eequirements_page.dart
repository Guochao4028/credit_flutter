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
import 'package:credit_flutter/models/my_needs_bean.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/utils/event_bus.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../define/define_colors.dart';

class EditRequirementsPage extends StatefulWidget {
  MyNeedsData data;

  EditRequirementsPage({Key? key, required this.data}) : super(key: key);

  @override
  State<EditRequirementsPage> createState() => _EditRequirementsPageState();
}

class _EditRequirementsPageState extends State<EditRequirementsPage> {
  var titleLicense = TextEditingController();
  var phoneLicense = TextEditingController();
  var numberLicense = TextEditingController();
  var contentLicense = TextEditingController();

  var day = 3;

  var isClick = false;

  @override
  void initState() {
    super.initState();
    titleLicense.text = widget.data.title;
    phoneLicense.text = widget.data.phone;
    numberLicense.text = widget.data.budget.toInt() > 0
        ? widget.data.budget.toInt().toString()
        : "";
    contentLicense.text = widget.data.description;
    day = widget.data.days;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "需求详情",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: CustomColors.greyBlack,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: CustomColors.colorEDF6F6,
      body: BaseBody(
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              padding: const EdgeInsets.only(
                  left: 12, top: 16, right: 12, bottom: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Column(
                children: [
                  _addInputBox(
                      "请输入您的需求标题（必填）", titleLicense, 100, TextInputType.text),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: CustomColors.colorF5F5F5,
                  ),
                  _addInputBox(
                      "请输入您的电话（必填）", phoneLicense, 11, TextInputType.phone),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: CustomColors.colorF5F5F5,
                  ),
                  _addInputBox(
                      "请输入您的预算金额", numberLicense, 10, TextInputType.number),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: CustomColors.colorF5F5F5,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 16, top: 10, right: 16, bottom: 10),
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
                ],
              ),
            ),
            Row(
              children: const [
                SizedBox(
                  width: 32,
                ),
                Text(
                  "需求描述",
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                  left: 16, top: 10, right: 16, bottom: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: _addInputBoxBig(
                  "请输入您的具体需求（必填）", contentLicense, 500, TextInputType.text),
            ),
            _submit(),
          ],
        ),
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
      padding: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
      child: TextField(
        onChanged: (text) {
          _ifModify();
        },
        keyboardType: text,
        textAlign: TextAlign.start,
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
      padding: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
      child: TextField(
        onChanged: (text) {
          _ifModify();
        },
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
        _ifModify();
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
        if (!isClick) {
          return;
        }
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
          "id": widget.data.id.toString(),
          "title": titleLicense.text.toString().trim(),
          "phone": phoneLicense.text.toString().trim(),
          "budget": numberLicense.text.toString().trim(),
          "days": day,
          "description": contentLicense.text.toString().trim(),
        };
        DemandCenterManager.putDemandCenterSave(pame, (data) {
          bus.emit("add_release", data);
          Navigator.of(context).pop("refreshPage");
        });
      },
      child: Container(
        width: double.infinity,
        height: 44,
        margin: const EdgeInsets.only(left: 30, top: 10, right: 30),
        decoration: BoxDecoration(
          color: isClick ? CustomColors.connectColor : const Color(0xFF85B6F3),
          borderRadius: const BorderRadius.all(Radius.circular(3)),
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

  _ifModify() {
    var click = isClick;
    var bool1 = titleLicense.text.toString().trim() == widget.data.title;
    var bool2 = phoneLicense.text.toString().trim() == widget.data.phone;
    var bool3 = numberLicense.text.toString().trim() ==
        widget.data.budget.toInt().toString();
    var bool4 = contentLicense.text == widget.data.description;
    var bool5 = day == widget.data.days;
    click = !(bool1 && bool2 && bool3 && bool4 && bool5);
    if (isClick != click) {
      isClick = click;
      setState(() {});
    }
  }
}
