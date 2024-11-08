import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/certification/fill_in_info_page.dart';
import 'package:flutter/material.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class CertificationHomePage extends StatefulWidget {
  const CertificationHomePage({Key? key}) : super(key: key);

  @override
  State<CertificationHomePage> createState() => _CertificationHomePageState();
}

class _CertificationHomePageState extends State<CertificationHomePage> {

  @override
  void initState() {
    super.initState();
    UmengCommonSdk.onPageStart("certification_home_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("certification_home_page");
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
              "实人认证",
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
      backgroundColor: CustomColors.colorF1F4F9,
      body: Column(
        children: [
          const Image(
            image: AssetImage("assets/images/icon_certification.png"),
            height: 180,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16),
            height: 56,
            child: const Row(
              children: [
                Text(
                  "欢迎使用实人认证",
                  style: TextStyle(
                    color: CustomColors.greyBlack,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: CustomColors.darkGreyE5,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, top: 14, bottom: 70),
            child: Row(
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "您本人",
                        style: TextStyle(
                            color: CustomColors.connectColor, fontSize: 13.0),
                      ),
                      TextSpan(
                        text: "亲自完成。",
                        style: TextStyle(
                            color: CustomColors.greyBlack, fontSize: 12.0),
                      ),
                    ],
                    text: "本次过程需要",
                    style: TextStyle(
                        color: CustomColors.greyBlack, fontSize: 13.0),
                  ),
                ),
              ],
            ),
          ),
          const Center(
            child: Text(
              "您提交的资料将只会用于实人认证审核。",
              style: TextStyle(
                color: Color(0xFFFF0000),
                fontSize: 11,
              ),
            ),
          ),
          Container(
            height: 50,
            margin:
                const EdgeInsets.only(left: 30, top: 8, right: 30, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: CustomColors.connectColor,
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FillInInfoPage(),
                  ),
                );
              },
              child: const Center(
                child: Text(
                  "去认证",
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
}
