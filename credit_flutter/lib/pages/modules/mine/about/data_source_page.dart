/// *
/// -  @Date: 2022-07-01 14:19
/// -  @LastEditTime: 2022-07-01 14:19
/// -  @Description: 数据来源
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:flutter/material.dart';

class DataSourcePage extends StatelessWidget {
  List<Map<String, dynamic>> dataLists = [
    {
      "title": "司法部",
      "icon": "assets/images/sf.png",
    },
    {
      "title": "教育部",
      "icon": "assets/images/jy.png",
    },
    {
      "title": "法院",
      "icon": "assets/images/fy.png",
    },
    {
      "title": "仲裁院",
      "icon": "assets/images/zc.png",
    },
    {
      "title": "公安部",
      "icon": "assets/images/ga.png",
    },
    {
      "title": "劳动和社会保障部",
      "icon": "assets/images/ld.png",
    },
    {
      "title": "国家市场监督管理总局",
      "icon": "assets/images/msa.png",
    },
  ];
  DataSourcePage({Key? key}) : super(key: key);

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
              "数据来源",
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
      body: Container(
        padding: const EdgeInsets.all(16),
        child: _getGridView(),
      ),
    );
  }

  Widget _getGridView() {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 80 / 120.5,
        crossAxisCount: 3,
        //水平单个子Widget之间间距
        mainAxisSpacing: 30.5,
        //垂直单个子Widget之间间距
        crossAxisSpacing: 45.0,
      ),
      itemCount: dataLists.length,
      itemBuilder: (BuildContext context, int index) {
        //自定义的行 代码在下面
        // return _showGridViewItem(
        // context, itmeList[pageViewNumber + index]);

        return _showGridViewItem(context, dataLists[index]);
      },
    );
  }

  Widget _showGridViewItem(BuildContext context, Map<String, dynamic> model) {
    String iconStr = model["icon"];
    String titleStr = model["title"];

    SizedBox icon = SizedBox(
      width: 80,
      height: 80,
      child: Image(
        image: AssetImage(iconStr),
        fit: BoxFit.fitWidth,
      ),
    );

    Text titleText = Text(
      titleStr,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        color: CustomColors.greyBlack,
      ),
    );
    return InkWell(
        //用inkWell是为了添加点击事件
        onTap: () {},
        child: Container(
          child: Column(
            children: <Widget>[
              icon,
              const SizedBox(
                height: 5,
              ),
              titleText,
            ],
          ),
        ));
  }
}
