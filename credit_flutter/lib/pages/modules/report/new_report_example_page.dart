import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../define/define_colors.dart';

class NewReportExamplePage extends StatefulWidget {
  const NewReportExamplePage({Key? key}) : super(key: key);

  @override
  State<NewReportExamplePage> createState() => _NewReportExamplePageState();
}

class _NewReportExamplePageState extends State<NewReportExamplePage> {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      //导航
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "报告样例",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: CustomColors.colorF1F4F9,
      // body: Image.asset(
      //   'assets/images/mReport.png',
      //   fit:BoxFit.fitWidth,
      // ),
      body: new CustomScrollView(
        shrinkWrap: true,
        // 内容
        slivers: <Widget>[
          new SliverPadding(
            padding: const EdgeInsets.all(0),
            sliver: new SliverList(
              delegate: new SliverChildListDelegate(
                <Widget>[
              Image.asset(
                  'assets/images/mReport.png',
                  fit:BoxFit.fitWidth,
                ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

}
