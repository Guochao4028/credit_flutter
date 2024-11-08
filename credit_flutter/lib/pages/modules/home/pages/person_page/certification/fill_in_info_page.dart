import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/certification/authorization_statement_page.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class FillInInfoPage extends StatefulWidget {
  const FillInInfoPage({Key? key}) : super(key: key);

  @override
  State<FillInInfoPage> createState() => _FillInInfoPageState();
}

class _FillInInfoPageState extends State<FillInInfoPage> {
  var nameController = TextEditingController();
  var iDController = TextEditingController();

  TextInputFormatter formatter = FilteringTextInputFormatter.deny(RegExp(
      "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"));
  TextInputFormatter textFormatter = FilteringTextInputFormatter.deny(RegExp(
      "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"));

  @override
  void initState() {
    super.initState();
    UmengCommonSdk.onPageStart("fill_in_info_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("fill_in_info_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "认证信息",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 17,
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
      backgroundColor: CustomColors.lightGreyFB,
      body: Column(
        children: [
          Container(
            height: 55,
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 14,
                  margin: const EdgeInsets.only(
                    right: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.5),
                    color: CustomColors.connectColor,
                  ),
                ),
                const Text(
                  "请输入认证信息",
                  style: TextStyle(
                    color: CustomColors.greyBlack,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: CustomColors.darkGreyE5,
            margin: const EdgeInsets.only(left: 16, right: 16),
          ),
          _itemEnter("真实姓名", 10, nameController, "请输入您的姓名", TextInputType.text,
              formatter),
          _itemEnter("身份证号", 18, iDController, "请输入您的身份证号", TextInputType.text,
              textFormatter),
          Container(
            height: 55,
            margin: const EdgeInsets.only(left: 30, top: 24, right: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: CustomColors.connectColor,
            ),
            child: InkWell(
              onTap: () {
                var name = nameController.text.toString();
                if (name.isEmpty) {
                  ToastUtils.showMessage("请输入您的姓名");
                  return;
                }
                var id = iDController.text.toString();
                if (id.isEmpty) {
                  ToastUtils.showMessage("请输入您的身份证号");
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AuthorizationStatementPage(name: name, id: id),
                  ),
                );
              },
              child: const Center(
                child: Text(
                  "下一步",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemEnter(
      String title,
      int maxLength,
      TextEditingController content,
      String hintText,
      TextInputType keyboardType,
      TextInputFormatter formatter) {
    InputDecoration inputDecoration = InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(0),
      isCollapsed: true,
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 18,
        color: CustomColors.darkGrey99,
      ),
    );

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      height: 55,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CustomColors.textDarkColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: CustomColors.darkGreyE5,
          )
        ],
      ),
    );
  }
}
