/// *
/// -  @Date: 2022-07-11 18:34
/// -  @LastEditTime: 2022-07-11 18:34
/// -  @Description:  设置支付密码 成功
///
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/mine_manager.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';

class PayPasswordSuccessful extends StatefulWidget {
  String title = "恭喜您设置支付密码成功";
  int popNumebr = 2;

  PayPasswordSuccessful(
      {required this.title, required this.popNumebr, Key? key})
      : super(key: key);

  @override
  State<PayPasswordSuccessful> createState() => _PayPasswordSuccessfulState();
}

class _PayPasswordSuccessfulState extends State<PayPasswordSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.color1B7CF6,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "设置支付密码",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 87,
            ),
            SizedBox(
              height: 80,
              width: 80,
              child: Image.asset("assets/images/icon_submit_successfully.png"),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            InkWell(
              child: Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    child: Container(
                      color: CustomColors.lightBlue,
                      width: double.infinity,
                      height: 50,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              "返回",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ]),
                    )),
              ),
              onTap: () {
                if (widget.popNumebr == 2) {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
