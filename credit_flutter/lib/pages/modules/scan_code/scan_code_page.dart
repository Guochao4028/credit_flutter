import 'dart:io';

import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/pages/modules/login/login_new_page.dart';
import 'package:credit_flutter/pages/modules/mine/enterprise_info/enterprise_info_page.dart';
import 'package:credit_flutter/pages/modules/scan_code/scan_code_query_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({Key? key}) : super(key: key);

  @override
  State createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage>
    with SingleTickerProviderStateMixin {
  late SharedPreferences prefs;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      prefs = value;
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }




  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: scanArea),
                onPermissionSet: (ctrl, p) {},
              ),
              Positioned(
                left: 18,
                top: 28,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      if (scanData.code.toString().isNotEmpty) {
        try {
          Uri uri = Uri.parse(scanData.code.toString());
          //总代二维码
          String? agencyCode = uri.queryParameters['agencyCode'];
          //二级代理二维码
          String? authorizationCode = uri.queryParameters['authorizationCode'];
          Log.e("agencyCode=$agencyCode");
          Log.e("authorizationCode=$authorizationCode");
          if (agencyCode != null) {
            determineIdentity(agencyCode);
          } else if (authorizationCode != null) {
            purchaseReport(authorizationCode);
          } else {
            controller.resumeCamera();
          }
          // Map<String, dynamic> map = jsonDecode(scanData.code.toString());
          // if (map.containsKey("type") && map.containsKey("code")) {
          //   int type = map["type"];
          //   String code = map["code"];
          //   if (type == 1) {
          //     determineIdentity(code);
          //   } else if (type == 2) {
          //     purchaseReport(code);
          //   }
          // } else {
          //   controller.resumeCamera();
          // }
        } catch (_) {
          controller.resumeCamera();
        }
      } else {
        controller.resumeCamera();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void determineIdentity(String code) {
    Golbal.generalAgent = code;

    String jsonStr = Golbal.token;
    //判断是否登录
    if (jsonStr.isNotEmpty) {
      //登陆了
      var loginType = prefs.getString(FinalKeys.LOGIN_TYPE);
      if (loginType == "1") {
        //企业
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const EnterpriseInfoPage(),
          ),
        );
      } else {
        //退出重新登录
        _loginOut(LoginType.company);
      }
    } else {
      //未登录
      _loginOut(LoginType.company);
    }
  }

  void purchaseReport(String code) {
    String jsonStr = Golbal.token;
    //判断是否登录
    if (jsonStr.isNotEmpty) {
      //登陆了
      var loginType = prefs.getString(FinalKeys.LOGIN_TYPE);
      if (loginType != "1") {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ScanCodeQueryPage(
                authorizationCode: code,
              );
            },
          ),
        );
      } else {
        Golbal.generalAgent = code;
        _loginOut(LoginType.personal);
      }
    } else {
      Golbal.generalAgent = code;
      _loginOut(LoginType.personal);
    }
  }

  void _loginOut(LoginType type) {
    //登录成功后的操作标识符
    Golbal.isStorage = false;

    /// 友盟登出用户账号
    UmengCommonSdk.onProfileSignOff();
    //清除token
    Golbal.token = "";

    //清除全部数据
    prefs.clear();
    //是否第一次登录
    prefs.setBool(FinalKeys.FIRST_OPEN, true);

    String loginType = "1";
    int requestUserType = 0;
    if (type == LoginType.company) {
      loginType = "1";
    } else if (type == LoginType.personal) {
      loginType = "2";
      requestUserType = 2;
    } else if (type == LoginType.employer) {
      loginType = "3";
      requestUserType = 1;
    }
    prefs.setString(FinalKeys.LOGIN_TYPE, loginType);
    prefs.setInt(FinalKeys.LOGIN_USER_TYPE, requestUserType);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return LoginNewPage(type: type);
    }), (route) => false);
  }
}
