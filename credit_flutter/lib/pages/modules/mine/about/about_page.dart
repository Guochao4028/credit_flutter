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
import 'package:credit_flutter/define/define_url.dart';
import 'package:credit_flutter/pages/modules/mine/about/business_license_page.dart';
import 'package:credit_flutter/pages/modules/mine/about/cancellation_account_page.dart';
import 'package:credit_flutter/pages/modules/mine/about/contact_us_page.dart';
import 'package:credit_flutter/pages/modules/mine/about/data_source_page.dart';
import 'package:credit_flutter/pages/modules/web/web_page.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/update_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  ///itemLists
  List<Map<String, dynamic>> itemLists = [
    {
      "name": "用户服务协议",
      "page": const WebViewPage("用户服务协议", NetworkingUrls.h5AllRegisterUrl),
    },
    {
      "name": "隐私协议",
      "page": const WebViewPage("隐私协议", NetworkingUrls.h5AllPrivacyPolicyUrl),
    },
    {
      "name": "数据来源",
      "page": DataSourcePage(),
    },
    {
      "name": "营业执照",
      "page": const BusinessLicensePage(),
    },
    {
      "name": "注销账号",
      "page": const CancellationAccountPage(),
    },
    {
      "name": "联系客服",
      "page": const ContactUsPage(),
    },
    // {
    //   "name": "联系客服",
    //   "page": const PaySuccessPage(),
    // },
    {
      "name": "意见反馈",
    },
    {
      "name": "新版本检测",
    }
  ];

  String version = "";
  int buildNumber = 0;

  @override
  void initState() {
    super.initState();
    getPackageInfo();
    UmengCommonSdk.onPageStart("about_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("about_page");
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
              "关于应用",
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
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            _getIconView(),
            Expanded(
              child: _getListView(),
            ),
            const Text(
              "备案号：京ICP备2022008367号-2A",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.lightGrey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getIconView() {
    Image icon = const Image(
      image: AssetImage("assets/images/aboutIcon.png"),
      width: 84,
      height: 84,
    );
    Image title = const Image(
      image: AssetImage("assets/images/aboutTitle.png"),
      width: 102,
      height: 38,
    );

    Text titleText = Text(
      "Version $version",
      style: const TextStyle(
        fontSize: 15,
        color: CustomColors.lightGrey,
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 53),
      child: Center(
        child: Column(
          children: [
            icon,
            const SizedBox(
              height: 6,
            ),
            title,
            const SizedBox(
              height: 6,
            ),
            titleText,
          ],
        ),
      ),
    );
  }

  Widget _getListView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
      child: _listView(),
    );
  }

  ///页面列表
  Widget _listView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        Map<String, dynamic> itemModel = itemLists[index];
        return _rowListItemView(
          context,
          itemModel,
        );
      },
      itemCount: itemLists.length,
    );
  }

  ///页面列表上item
  Widget _rowListItemView(
    BuildContext context,
    Map model,
  ) {
    String titleStr = model["name"];
    String directionStr = "assets/images/svg/back.svg";

    ///title
    Text title = Text(
      titleStr,
      style: const TextStyle(
        color: CustomColors.greyBlack,
        fontSize: 15,
      ),
    );

    ///箭头
    SizedBox direction = SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        directionStr,
        fit: BoxFit.fill,
        color: CustomColors.lightGrey,
      ),
    );

    ///Line
    Container line = Container(
      height: 1,
      color: CustomColors.lineColor,
    );
    return GestureDetector(
      onTap: (() {
        if (model["page"] != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => model["page"],
            ),
          );
        } else {
          if (model["name"] == "联系客服") {
            // _launchUrl("tel:010-53323535");

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => model["page"],
              ),
            );
            // _launchUrl("tel:18911975187");
          } else if (model["name"] == "意见反馈") {
            _launchUrl("tel:18911975187");
          } else {
            if (PlatformUtils.isIOS || PlatformUtils.isAndroid) {
              UpdateUtils().appUpdate(this.context, buildNumber, version, 0);
            }
          }
        }
      }),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 48,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  title,
                  const Expanded(child: SizedBox()),
                  direction,
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            line,
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String uri) async {
    if (!await launchUrl(Uri.parse(uri))) {
      throw 'Could not launch $uri';
    }
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = int.parse(packageInfo.buildNumber);
    setState(() {});
  }
}
