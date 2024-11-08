import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/certification/certification_home_page.dart';
import 'package:flutter/material.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

///实名认证 流程页
class CertificationProcessPage extends StatefulWidget {
  const CertificationProcessPage({Key? key}) : super(key: key);

  @override
  State<CertificationProcessPage> createState() =>
      _CertificationProcessPageState();
}

class _CertificationProcessPageState extends State<CertificationProcessPage> {
  List<String> showList = [
    "失信被执行人",
    "社会不良信息",
    "学历相关信息",
    "终本执行案件",
    "裁判文书信息",
    "税务违法信息",
    "违法行业禁止",
    "失信被执行人信息",
    "限制消费人员",
    "限飞限乘名单",
  ];

  @override
  void initState() {
    super.initState();
    UmengCommonSdk.onPageStart("certification_process_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("certification_process_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "慧眼查",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _heardView(),
            _promptView(),
            _classifiedInformationView(),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _heardView() {
    return Container(
      margin: const EdgeInsets.only(top: 17, bottom: 6),
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/ph.png",
        width: 198,
        height: 202,
      ),
    );
  }

  Widget _promptView() {
    return Container(
      height: 56,
      width: 300,
      margin: const EdgeInsets.only(bottom: 3),
      alignment: Alignment.center,
      child: const Text(
        "个人使用者需要认证后才可以下载或购买自己的信用报告",
        style: TextStyle(
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _classifiedInformationView() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: CustomColors.connectColor),
        borderRadius: BorderRadius.circular((8.0)),
      ),
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 0, right: 0),
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              color: CustomColors.connectColor,
            ),
            child: const Text(
              "个人雇主购买报告流程",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _item("icon_flow_report_purchase", "报告购买"),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: CustomColors.darkGrey,
                    ),
                    Expanded(
                      child: _item("icon_flow_identity_authentication", "身份认证"),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: CustomColors.darkGrey,
                    ),
                    Expanded(
                      child: _item("icon_flow_send_message", "发送授权短信"),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(
                          Icons.arrow_downward,
                          color: CustomColors.darkGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _item("icon_flow_report_delivery", "报告交付"),
                    ),
                    const Icon(
                      Icons.arrow_back,
                      color: CustomColors.darkGrey,
                    ),
                    Expanded(
                      child:
                          _item("icon_flow_report_quality_inspection", "报告质检"),
                    ),
                    const Icon(
                      Icons.arrow_back,
                      color: CustomColors.darkGrey,
                    ),
                    Expanded(
                      child:
                          _item("icon_flow_candidate_authorization", "候选人授权"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _button() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const CertificationHomePage();
              },
            ),
          );
        },
        child: SizedBox(
          width: 315,
          height: 50,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(32)),
            child: Container(
              color: CustomColors.connectColor,
              width: double.infinity,
              height: double.infinity,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "去认证",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(String image, String name) {
    return Column(
      children: [
        Image(
          image: AssetImage("assets/images/$image.png"),
          width: 40,
          height: 40,
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            color: CustomColors.greyBlack,
          ),
        ),
      ],
    );
  }
}
