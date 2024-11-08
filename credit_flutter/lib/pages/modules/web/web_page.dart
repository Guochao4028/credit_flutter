/// *
/// -  @Date: 2022-06-21 18:58
/// -  @LastEditTime: 2022-06-21 18:58
/// -  @Description: 网页展示
///

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage(this.titleStr, this.urlStr, {Key? key}) : super(key: key);
  final String titleStr;
  final String urlStr;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
    EasyLoading.show();
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.titleStr,
          style: const TextStyle(
            color: CustomColors.greyBlack,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildContentView(),
    );
  }

  Widget _buildContentView() {
    if (PlatformUtils.isWeb) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // 官方代码
              HtmlWidget(
                _getHtmlStr(),
              )
            ],
          ),
        ),
      );
    } else {
      var controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              // EasyLoading.show();
            },
            onPageFinished: (String url) {
              EasyLoading.dismiss();
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.urlStr));
      return WebViewWidget(
        controller: controller,
      );
    }
  }

  String _getHtmlStr() {
    String title = widget.titleStr;
    if (title == "用户协议") {
      return FinalKeys.USER_AGREEMENT;
    } else {
      return FinalKeys.PRIVACY_AGREEMENT;
    }
  }
}
