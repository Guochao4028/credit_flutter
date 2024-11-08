import 'package:aliyun_face_plugin/aliyun_face_plugin.dart';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/authentication_manager.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class AuthorizationStatementPage extends StatefulWidget {
  String name = "";
  String id = "";

  AuthorizationStatementPage({Key? key, required this.name, required this.id})
      : super(key: key);

  @override
  State<AuthorizationStatementPage> createState() =>
      _AuthorizationStatementPageState();
}

class _AuthorizationStatementPageState
    extends State<AuthorizationStatementPage> {
  final _aliyunFacePlugin = AliyunFacePlugin();

  @override
  void initState() {
    super.initState();
    // 在App启动的早期调用init接口。
    _aliyunFacePlugin.init();
    UmengCommonSdk.onPageStart("authorization_statement_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("authorization_statement_page");
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
              "授权申明",
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
      body: ListView(
        children: [
          const Image(
            image: AssetImage("assets/images/icon_authorization_statement.png"),
            height: 86,
            width: 67,
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "授权申明",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 18, top: 15, right: 18),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    "      本APP运营方为确保用户身份真实性，向您提供更好的安全保障，您可以通过提交身份证等身份信息或面部特征等生物识别信息（均属于个人敏感信息）来完成具体产品服务所需或必要的实人认证。上述信息将仅用于验证用户身份的真实性。",
                    style: TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 18, top: 15, right: 18),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    "      我们会采用行业领先的技术来保护您提供的个人信息，并使用加密、限权等方式避免其被用于其他用途。",
                    style: TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 18, top: 15, right: 18),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    "      点击“同意”则表示本人同意我们根据以上方式和目的收集、使用及存储您提供的本人身份材料、面部特征等信息用于实人认证。",
                    style: TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            margin:
                const EdgeInsets.only(left: 30, top: 20, right: 30, bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: CustomColors.connectColor,
            ),
            child: InkWell(
              onTap: () {
                getMetaInfos().then((value) {
                  var param = {
                    "certName": widget.name,
                    "certNo": widget.id,
                    "metaInfo": value,
                  };
                  AuthenticationManager.appVerify(param, (map) {
                    Log.d(map);
                    Map<String, dynamic> resultObject = map["resultObject"];
                    String certifyId = resultObject["certifyId"];
                    startVerify(certifyId).then((value) {
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pop()
                        ..pop({"certifyId": certifyId, "result": value});
                    });
                  });
                });
              },
              child: const Center(
                child: Text(
                  "同意",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getMetaInfos() async {
    try {
      // 获取客户端metainfos，将信息发送到服务器端，调用服务器端相关接口获取认证ID，即CertifyId。
      return await _aliyunFacePlugin.getMetaInfos() ?? 'Unknown MetaInfo';
    } on PlatformException {
      return 'Failed to get MetaInfos.';
    }
  }

  Future<bool> startVerify(String certifyId) async {
    String verifyResult;
    try {
      // 调用认证接口，CertifyId需要调用服务器端接口获取。
      // 每个CertifyId只能使用一次，否则会返回code: "2002(iOS), 1001(Android)"。
      verifyResult =
          await _aliyunFacePlugin.verify("certifyId", certifyId) ?? '-1,error';
    } on PlatformException {
      verifyResult = '-2,exception';
    }
    var split = verifyResult.split(',');
    Log.e("-------${split.toString()}");
    return split[0] == "1000";
  }
}
