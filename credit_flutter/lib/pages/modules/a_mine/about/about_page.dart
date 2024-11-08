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
import 'package:credit_flutter/pages/modules/mine/about/data_source_page.dart';
import 'package:credit_flutter/pages/modules/web/web_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      "page": WebViewPage("用户服务协议", NetworkingUrls.h5AllRegisterUrl),
    },
    {
      "name": "隐私协议",
      "page": WebViewPage("隐私协议", NetworkingUrls.h5AllPrivacyPolicyUrl),
    },
    {
      "name": "数据来源",
      "page": DataSourcePage(),
    },
    {
      "name": "营业执照",
      "page": BusinessLicensePage(),
    }
  ];

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
              "关于应用",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _getIconView(),
              _getListView(),
            ],
          ),
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

    Text titleText = const Text(
      "Version 1.0.0",
      style: TextStyle(
        fontSize: 15,
        color: CustomColors.lightGrey,
      ),
    );

    return Container(
      margin: EdgeInsets.only(top: 53),
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
      height: 255.0,
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
      physics: const NeverScrollableScrollPhysics(),
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
}
