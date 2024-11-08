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
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/modules/empower/authentication_privacy_policy_page.dart';
import 'package:flutter/material.dart';

import 'confirm_identity_info_page.dart';

class NotificationStatementPage extends StatefulWidget {
  //1=个人/2=企业查询个人/3=企业年付查询个人 5/自查 5快
  int type = 1;
  String companyName = "";
  String idCard = "";
  String name = "";
  String reportAuthId = "";

  NotificationStatementPage({
    Key? key,
    required this.type,
    required this.companyName,
    required this.idCard,
    required this.name,
    required this.reportAuthId,
  }) : super(key: key);

  @override
  State<NotificationStatementPage> createState() =>
      _NotificationStatementPageState();
}

class _NotificationStatementPageState extends State<NotificationStatementPage> {
  bool isReading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          const Image(
            image: AssetImage("assets/images/icon_notification_statement.png"),
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: CustomColors.colorEAF5FF,
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            ),
            child: _getTitle(),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => AuthenticationPrivacyPolicyPage(),
                ),
              )
                  .then((value) {
                if (value != null) {
                  isReading = true;
                  setState(() {});
                }
              });
            },
            child: Row(
              children: [
                const SizedBox(width: 16),
                Image(
                  image: isReading == false
                      ? const AssetImage("assets/images/radioNormal.png")
                      : const AssetImage("assets/images/radioSelectBlue.png"),
                ),
                const SizedBox(width: 5),
                RichText(
                  text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "《隐私政策》",
                          style: TextStyle(
                              color: CustomColors.lightBlue, fontSize: 15.0),
                        ),
                      ],
                      text: "已阅读并同意",
                      style: TextStyle(
                          color: CustomColors.lightGrey, fontSize: 15.0)),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, top: 40, right: 16),
            height: 50,
            decoration: BoxDecoration(
              color: isReading
                  ? CustomColors.connectColor
                  : CustomColors.colorC8C8C8,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (isReading) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ConfirmIdentityInfoPage(
                        type: widget.type,
                        companyName: widget.companyName,
                        idCard: widget.idCard,
                        name: widget.name,
                        reportAuthId: widget.reportAuthId,
                      ),
                    ),
                  );
                }
              },
              child: const Center(
                child: Text(
                  "已阅读隐私政策，下一步",
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

  _getTitle() {
    switch (widget.type) {
      case 1:
      case 5:
        return Column(
          children: [
            Text(
              "       ${widget.name}您好，按照适用相关法律、法规、包括中华人民共和国关于个人信息的相关规定和相关标准，收集维护、和处理有关您的个人信息。对于您所提供的个人信息，我们会使用合理的技术手段、必要的管理制度以防止他人未进授权查询、修改、披露、适用或销毁。",
              style: const TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "       我们可以将您提供的信息提供给您的雇主和教育机构等相关第三方，以便核实您提供的信息是否准确。",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "       所有关于您的个人信息，都是必须经过您本人同意以及本人授权才能获取，向您个人展示。",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
              ),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            Text(
              "       ${widget.name}您好，受${widget.companyName}委托，按照适用相关法律、法规、包括中华人民共和国关于个人信息的相关规定和相关标准，收集维护、和处理有关您的个人信息。对于您所提供的个人信息，我们会使用合理的技术手段、必要的管理制度以防止他人未进授权查询、修改、披露、适用或销毁。",
              style: const TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "       我们可以将您提供的信息提供给您的雇主和教育机构等相关第三方，以便核实您提供的信息是否准确。",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "       所有关于您的个人信息，都是必须经过您本人同意以及本人授权才能获取，向您个人展示。",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
              ),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            Text(
              "       ${widget.name}您好，受${widget.companyName}委托，按照适用相关法律、法规、包括中华人民共和国关于个人信息的相关规定和相关标准，收集维护、和处理有关您的个人信息。对于您所提供的个人信息，我们会使用合理的技术手段、必要的管理制度以防止他人未进授权查询、修改、披露、适用或销毁。",
              style: const TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "       ${widget.companyName}已经购买您一年的报告，本次授权一次将授权一年，每个月会将您的报告定时发给企业，供企业进行查看。",
              style: const TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "       我们可以将您提供的信息提供给您的雇主和教育机构等相关第三方，以便核实您提供的信息是否准确。",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "       所有关于您的个人信息，都是必须经过您本人同意以及本人授权才能获取，向您个人展示。",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
              ),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
