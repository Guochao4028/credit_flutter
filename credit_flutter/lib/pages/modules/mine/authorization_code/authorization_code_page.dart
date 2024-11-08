/// *
/// -  @Date: 2022-07-01 11:36
/// -  @LastEditTime: 2022-07-01 11:45
/// -  @Description:
///
/// *
/// -  @Date: 2022-07-01 11:36
/// -  @LastEditTime: 2022-07-01 11:36
/// -  @Description: 关于应用
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AuthorizationCodePage extends StatefulWidget {
  const AuthorizationCodePage({Key? key}) : super(key: key);

  @override
  State<AuthorizationCodePage> createState() => _AuthorizationCodePageState();
}

class _AuthorizationCodePageState extends State<AuthorizationCodePage> {
  String authorizationCode = "";

  String data = "";

  @override
  void initState() {
    super.initState();

    ///获取用户信息
    UserModel.getInfo((model) {
      if (model != null) {
        authorizationCode =
            model.userInfo.companyInfo.authorizationCode.toString();
        data =
            "https://www.nowcheck.cn/index?authorizationCode=$authorizationCode";
        Log.e(data);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.lightBlue,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "授权码",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
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
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            if (authorizationCode.isNotEmpty)
              QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 280.0,
              ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "在用户扫码购买报告完成后，代理即可查看该用户报告",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
