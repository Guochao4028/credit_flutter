/// *
/// -  @Date: 2023-08-11 13:20
/// -  @LastEditTime: 2023-08-11 13:21
/// -  @Description: 联系我们
///

import 'package:credit_flutter/define/define_colors.dart';

import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../web/web_page.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage>
    implements ClickListener {
  final GlobalKey _imageKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: _appBar(),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Stack(children: [
            _bg("assets/images/usBg.png"),
            _content(),
          ]),
        ),
      ),
    );
  }

  /// *
  /// -  @description: appbar 布局
  /// -  @Date: 2023-08-11 15:00
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _appBar() {
    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          color: CustomColors.color50Blue,
          padding: const EdgeInsets.only(left: 16, bottom: 10),
          child: Column(
            children: [
              const Expanded(child: SizedBox()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: const Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "联系我们",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "您可通过以下方式联系我们",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // const Expanded(child: SizedBox()),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 15,
          child: Container(
            height: 100,
            width: 150,
            padding: const EdgeInsets.only(left: 16),
            child: const Image(
              image: AssetImage("assets/images/usIcon.png"),
            ),
          ),
        )
      ],
    );
  }

  /// *
  /// -  @description: 整体背景
  /// -  @Date: 2023-08-11 14:56
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _bg(String imagePath) {
    return SizedBox(
      width: double.infinity,
      child: Image(
        image: AssetImage(imagePath),
        fit: BoxFit.fill,
      ),
    );
  }

  /// *
  /// -  @description: 页面内容展示
  /// -  @Date: 2023-08-11 14:58
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _content() {
    return Container(
      margin: const EdgeInsets.only(left: 32, right: 32, top: 20),
      height: 527,
      child: Stack(
        children: [
          _bg("assets/images/contentBg.png"),
          Column(
            children: [
              _contentHeard(),
              _contentQRCode(),
            ],
          )
        ],
      ),
    );
  }

  /// *
  /// -  @description: 客服电话
  /// -  @Date: 2023-08-11 15:47
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _contentHeard() {
    return GestureDetector(
      onTap: () {
        _launchUrl("tel:010-53323535");
      },
      child: Container(
        // color: Colors.amber,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        width: double.infinity,
        height: 120,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("点击拨打客服电话"),
            SizedBox(height: 10),
            Text(
              "010-53323535",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.color50Blue),
            ),
            SizedBox(height: 5),
            Text("客服电话工作时间："),
            Text("周一至周五 9:30-18:30"),
          ],
        ),
      ),
    );
  }

  Widget _contentQRCode() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "点击二维码联系客服",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return PopupWindowDialog(
                      title: "提示",
                      confirm: "联系客服",
                      cancel: "取消",
                      content: "是否离开此页面",
                      clickListener: this,
                      showCancel: true,
                    );
                  });
            },
            child: RepaintBoundary(
              key: _imageKey,
              child: const Image(
                image: AssetImage("assets/images/qrcode.png"),
                width: 178,
                height: 178,
              ),
            ),
          ),
          const SizedBox(height: 35),
          const Text("打开微信扫一扫，扫码联系在线客服"),
          const SizedBox(height: 20),
          const Text(
            "24小时竭诚为您服务",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          WidgetTools().createCustomInkWellButton(
            "保存客服二维码",
            () {
              WidgetTools().saveImage(_imageKey);
            },
            bgColor: CustomColors.color1A000,
            textColor: CustomColors.color515488,
            fontWeight: FontWeight.bold,
            radius: 0,
            fontSize: 16,
            height: 48,
            buttonWidth: 280,
          )
        ],
      ),
    );
  }

  /// *
  /// -  @description: 拨打电话
  /// -  @Date: 2023-08-11 15:46
  /// -  @parm:
  /// -  @return {*}
  ///
  Future<void> _launchUrl(String uri) async {
    if (!await launchUrl(Uri.parse(uri))) {
      throw 'Could not launch $uri';
    }
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> map) {
    String uri = "https://work.weixin.qq.com/kfid/kfc1cede10c26ae9d80";
    launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
  }
}
