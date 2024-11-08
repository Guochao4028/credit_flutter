/// *
/// -  @Date: 2022-06-30 19:24
/// -  @LastEditTime: 2022-07-05 13:50
/// -  @Description:
///
/// *
/// -  @Date: 2022-06-30 19:24
/// -  @LastEditTime: 2022-07-01 11:41
/// -  @Description:
///
// 引入解析html的插件
import 'package:credit_flutter/define/define_keys.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter/material.dart';

/// *
/// -  @Date: 2022-06-30 17:38
/// -  @LastEditTime: 2022-06-30 17:38
/// -  @Description: 法规条文
///
///

class LawsRegulationsPage extends StatefulWidget {
  const LawsRegulationsPage({Key? key}) : super(key: key);

  @override
  State<LawsRegulationsPage> createState() => _LawsRegulationsPageState();
}

class _LawsRegulationsPageState extends State<LawsRegulationsPage> {
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
              "法规条文",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          color: Colors.white,
          child: Column(
            children: const [
              // 官方代码
              HtmlWidget(
                FinalKeys.LAW,
              )
            ],
          ),
        ),
      ),
    );
  }
}
