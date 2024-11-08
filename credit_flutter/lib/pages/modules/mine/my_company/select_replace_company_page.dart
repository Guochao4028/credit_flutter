import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/select_replace_company_manager.dart';
import 'package:credit_flutter/models/select_replace_company_bean.dart';
import 'package:credit_flutter/pages/modules/mine/enterprise_info/enterprise_info_page.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:credit_flutter/utils/popup_window.dart';

/// @Description: 选择公司
class SelectReplaceCompanyPage extends StatefulWidget {
  const SelectReplaceCompanyPage({Key? key}) : super(key: key);

  @override
  State<SelectReplaceCompanyPage> createState() =>
      _SelectReplaceCompanyPageState();
}

class _SelectReplaceCompanyPageState extends State<SelectReplaceCompanyPage>
    implements ClickListener {
  final _searchController = TextEditingController();
  List<SelectReplaceCompanyBean>? dataList;

  String id = "";

  @override
  void initState() {
    //初始化主页面
    super.initState();
    _getCompanyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1B7CF6),
        titleSpacing: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          alignment: Alignment.centerRight,
          color: Colors.white,
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          "我的公司",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          _addSearch(),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const EnterpriseInfoPage(type: 2),
                ),
              )
                  .then((value) {
                if (value != null) {
                  _getCompanyList();
                }
              });
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage("assets/images/icon_newly_build.png"),
                      width: 104,
                      height: 84,
                    ),
                  ],
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 6,
                ),
                const Center(
                  child: Text(
                    "新建公司",
                    style:
                        TextStyle(color: CustomColors.greyBlack, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 18,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 10,
            color: CustomColors.colorF1F4F9,
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              var data = dataList![index];
              return WidgetTools().changeCompanyItem(context, data, () {
                if (data.verifiedStatus != 2) {
                  id = data.id.toString();
                  showTips();
                }
              });
            },
            itemCount: dataList?.length ?? 0,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _addSearch() {
    Image search = const Image(
      image: AssetImage("assets/images/icon_search_one.png"),
      width: 15,
      height: 15,
    );

    return Container(
      margin: const EdgeInsets.only(left: 16, top: 14, right: 16, bottom: 14),
      width: double.infinity,
      height: 35,
      decoration: const BoxDecoration(
        color: CustomColors.colorF7F8FC,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          TextField(
            maxLines: 1,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.deny(RegExp(
                  "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"))
            ],
            controller: _searchController,
            onChanged: (text) {
              // _onRefresh();
            },
            textInputAction: TextInputAction.search,
            onEditingComplete: () {
              _onRefresh();
            },
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
                fontSize: 14, color: CustomColors.textDarkColor),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              isCollapsed: true,
              prefixIcon: search,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 41,
              ),
              border: InputBorder.none,
              hintText: "搜索公司名称",
              hintStyle:
                  const TextStyle(fontSize: 14, color: CustomColors.darkGrey99),
            ),
          ),
        ],
      ),
    );
  }

  void _onRefresh() {
    _getCompanyList();
  }

  void _getCompanyList() {
    SelectReplaceCompanyManager.getCompanyList(
        _searchController.text.toString(), (object) {
      dataList = object.cast<SelectReplaceCompanyBean>();
      setState(() {});
    });
  }

  void showTips() {
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            title: "提示",
            confirm: "确认",
            cancel: "取消",
            content: "是否更换公司",
            showCancel: true,
            clickListener: this,
          );
        });
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> confirmMap) {
    //更换公司
    SelectReplaceCompanyManager.changeCompany(id, (object) {
      Navigator.pop(context, "refreshPage");
    });
  }
}
