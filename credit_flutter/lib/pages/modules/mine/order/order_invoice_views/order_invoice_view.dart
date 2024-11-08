/// *
/// -  @Date: 2022-09-02 13:31
/// -  @LastEditTime: 2022-09-02 13:31
/// -  @Description: 发票view
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/order_invoice_model.dart';
import 'package:credit_flutter/models/order_list_model.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderInvoiceView {
  OrderDetailsModel detailsModel;
  bool isSelectedPersonal = false;
  bool isSelectedCompany = false;

  OrderInvoiceView({required this.detailsModel});

  Widget contentView() {
    return const Text("openContentView");
  }
}

/// *
/// -  @description: 开发票
/// -  @Date: 2022-09-02 13:36
/// -  @parm:
/// -  @return {*}
///
class OrderInvoiceOpenView extends OrderInvoiceView {
  List<Map<String, dynamic>> titles = [
    {"name": "订单编号", "type": 1},
    {"name": "金额", "type": 2},
    {"name": "发票形式", "type": 3},
    {"name": "发票类型", "type": 4},
    {"name": "发票内容", "type": 5},
  ];

  bool isReading = false;

  bool isSelectedPersonal;

  bool isSelectedCompany;

  OrderInvoiceOpenViewClickListener? clickListener;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  String nameStr = "";

  String emailStr = "";

  String numberStr = "";

  // TextInputFormatter chineseCharacters =
  //     FilteringTextInputFormatter.allow(RegExp("[\u4e00-\u9fa5]"));

  TextInputFormatter chineseCharacters = FilteringTextInputFormatter.deny(
    RegExp(
        "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"),
  );

  TextInputFormatter number =
      FilteringTextInputFormatter.allow(RegExp("[A-Z,a-z,0-9]"));
  TextInputFormatter mailbox =
      FilteringTextInputFormatter.allow(RegExp("[A-Z,a-z,0-9]|[_@.]"));

  // FilteringTextInputFormatter.allow(RegExp(r'[A-Z,a-z,0-9]')),

  OrderInvoiceOpenView(
      {required super.detailsModel,
      required this.isSelectedPersonal,
      required this.isSelectedCompany,
      this.clickListener});

  @override
  Widget contentView() {
    return BaseBody(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _promptView(),
              SizedBox(
                height: 250,
                child: _listView(),
              ),
              SizedBox(
                height: 50,
                child: _operationItem(),
              ),
              isSelectedCompany == false
                  ? _fillingPersonalInformation()
                  : _fillingCompanyInformation(),
              const SizedBox(
                height: 50,
              ),
              _buttonView(),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _promptView() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 46,
      child: Container(
        color: CustomColors.colorF9FD,
        padding: const EdgeInsets.only(left: 20, right: 20),
        margin: const EdgeInsets.only(left: 16, right: 16),
        height: 46,
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: SvgPicture.asset(
                "assets/images/svg/info.svg",
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Expanded(
              child: Text(
                "您好，消费后记得按时开票，方便双方财务报销入账，本单位据实开具发票，不多开不漏开谢谢您的配合。",
                style: TextStyle(
                  fontSize: 11,
                  color: CustomColors.lightGrey,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///页面列表
  Widget _listView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        Map<String, dynamic> itemModel = titles[index];
        return _rowListItemView(
          context,
          itemModel,
        );
      },
      itemCount: titles.length,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  ///页面列表上item
  Widget _rowListItemView(BuildContext context, Map model) {
    String titleStr = model["name"];

    int type = model["type"];
    int orderType = detailsModel.type;

    String contentStr = "";
    switch (type) {
      case 1:
        contentStr = detailsModel.id.toString();
        break;
      case 2:
        contentStr =
            StringTools.numberFormat(detailsModel.amount.toString(), true);
        break;
      case 3:
        contentStr = "电子发票";
        break;
      case 4:
        contentStr = "普通发票";

        break;
      case 5:
        {
          switch (orderType) {
            case 1:
              {
                contentStr = "开通VIP会员服务";
              }
              break;
            case 2:
              {
                contentStr = "开通SVIP会员服务";
              }
              break;
            case 3:
            case 6:
              {
                contentStr = "慧眼币充值";
              }
              break;
            case 4:
              {
                contentStr = "购买企业人数";
              }
              break;
            case 5:
            case 8:
            case 9:
            case 10:
              {
                contentStr = "员工背调报告";
              }
              break;
            case 7:
              {
                contentStr = "会员升级";
              }
              break;
            default:
          }
        }
        break;
      default:
    }

    ///title
    Text title = Text(
      titleStr,
      style: const TextStyle(
        color: CustomColors.greyBlack,
        fontSize: 15,
      ),
    );

    ///Line
    Container line = Container(
      margin: const EdgeInsets.only(left: 90),
      height: 1,
      color: CustomColors.lineColor,
    );

    Text content = Text(
      contentStr,
      style: const TextStyle(
        color: CustomColors.darkGrey,
        fontSize: 15,
      ),
    );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16),
      height: 50,
      child: Column(
        children: [
          SizedBox(
            height: 49,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 75,
                  child: title,
                ),
                const SizedBox(width: 20),
                content,
              ],
            ),
          ),
          line,
        ],
      ),
    );
  }

  ///选择个人或单位
  Widget _operationItem() {
    ///title
    Text title = const Text(
      "抬头类型",
      style: TextStyle(
        color: CustomColors.greyBlack,
        fontSize: 15,
      ),
    );

    ///Line
    Container line = Container(
      margin: const EdgeInsets.only(left: 90),
      height: 1,
      color: CustomColors.lineColor,
    );
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16),
      height: 50,
      child: Column(
        children: [
          SizedBox(
            height: 49,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 75,
                  child: title,
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    clickListener?.tapSelectedCompany();
                  },
                  child: Row(
                    children: [
                      Image(
                        image: isSelectedCompany == false
                            ? AssetImage("assets/images/radioNormal.png")
                            : AssetImage(
                                "assets/images/radioSelectBlue.png",
                              ),
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "单位",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 50),
                GestureDetector(
                  onTap: () {
                    clickListener?.tapSelectedPersonal();
                  },
                  child: Row(
                    children: [
                      Image(
                        image: isSelectedPersonal == false
                            ? AssetImage("assets/images/radioNormal.png")
                            : AssetImage("assets/images/radioSelectBlue.png"),
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "个人",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          line,
        ],
      ),
    );
  }

  ///个人信息填写
  Widget _fillingPersonalInformation() {
    return Container(
      height: 100,
      child: Column(
        children: [
          _inputInformation(
              "个人名称", _nameController, "请输入名称（必填）", 20, chineseCharacters),
          _inputInformation(
              "邮箱", _emailController, "请填写邮箱号（必填）,", 254, mailbox),
        ],
      ),
    );
  }

  Widget _inputInformation(
    String titleStr,
    TextEditingController controller,
    String hintText,
    int maxLength,
    TextInputFormatter formattera,
  ) {
    ///title
    Text title = Text(
      titleStr,
      style: const TextStyle(
        color: CustomColors.greyBlack,
        fontSize: 15,
      ),
    );

    ///Line
    Container line = Container(
      margin: const EdgeInsets.only(left: 90),
      height: 1,
      color: CustomColors.lineColor,
    );
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16),
      height: 50,
      child: Column(
        children: [
          SizedBox(
            height: 49,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 75,
                  child: title,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: inputTextFiled(
                    hintText,
                    controller,
                    TextInputType.text,
                    maxLength,
                    formattera,
                  ),
                ),
              ],
            ),
          ),
          line,
        ],
      ),
    );
  }

  ///单位信息填写
  Widget _fillingCompanyInformation() {
    return Container(
      height: 150,
      child: Column(
        children: [
          _inputInformation(
              "单位名称", _nameController, "请输入单位名称（必填）", 20, chineseCharacters),
          _inputInformation(
              "单位税号", _numberController, "请输入纳税人识别号（必填）", 18, number),
          _inputInformation("邮箱", _emailController, "请填写邮箱号（必填）", 254, mailbox),
        ],
      ),
    );
  }

  ///输入框
  Widget inputTextFiled(
    String hintText,
    TextEditingController textEditingController,
    TextInputType inputType,
    int maxLength,
    TextInputFormatter formattera,
  ) {
    InputDecoration decoration = InputDecoration(
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
    );

    TextField textField = TextField(
      controller: textEditingController,
      onChanged: (str) {
        if (textEditingController == _nameController) {
          nameStr = str;
        }
        if (textEditingController == _emailController) {
          emailStr = str;
        }
        if (textEditingController == _numberController) {
          numberStr = str;
        }
      },
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: inputType,
      decoration: decoration,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(maxLength),
        formattera,
      ],
    );

    return Container(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: textField,
      ),
    );
  }

  Widget _buttonView() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: InkWell(
        onTap: () {
          clickListener?.tapCommit(
              {"name": nameStr, "email": emailStr, "number": numberStr});
        },
        child: SizedBox(
          height: 50,
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              child: Container(
                color: CustomColors.connectColor,
                width: double.infinity,
                height: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "提交",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ]),
              )),
        ),
      ),
    );
  }
}

abstract class OrderInvoiceOpenViewClickListener {
  tapSelectedPersonal();

  tapSelectedCompany();

  tapCommit(Map<String, dynamic> mapModel);
}

/// *
/// -  @description: 发票详情
/// -  @Date: 2022-09-02 13:36
/// -  @parm:
/// -  @return {*}
///
class OrderInvoiceDetailView extends OrderInvoiceView {
  OrderInvoiceModel? invoicemodel;

  OrderInvoiceDetailView({required super.detailsModel, this.invoicemodel});

  @override
  Widget contentView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _invoiceState(),
          _intervalView(),
          _invoiceDetails(),
          _intervalView(),
          _invoiceInfo(),
          _intervalView(),
          _invoiceCompanyView(),
          _intervalView(),
          _invoiceProgressView(),
        ],
      ),
    );
  }

  ///显示view
  Widget _itemView(String titleStr, String contentStr,
      {Color contentColor = CustomColors.greyBlack,
      Color titleColor = CustomColors.darkGrey99}) {
    ///title
    Text title = Text(
      titleStr,
      style: TextStyle(
        color: titleColor,
        fontSize: 15,
      ),
    );

    Text content = Text(
      contentStr,
      style: TextStyle(
        color: contentColor,
        fontSize: 15,
      ),
    );
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16),
      height: 35,
      child: Column(
        children: [
          SizedBox(
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 75,
                  child: title,
                ),
                const SizedBox(width: 20),
                content,
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///间隔view
  Widget _intervalView() {
    return Container(
      height: 10,
      color: CustomColors.colorF5F5F5,
    );
  }

  ///发票状态
  Widget _invoiceState() {
    return _itemView(
      "发票状态：",
      "已开",
      contentColor: CustomColors.lightBlue,
      titleColor: CustomColors.greyBlack,
    );
  }

  ///发票详情
  Widget _invoiceDetails() {
    String orderNumber = detailsModel.id.toString();
    String payTime = detailsModel.getPayTime();
    return Column(
      children: [
        _itemView("订单状态：", "完成"),
        _itemView("订单编号：", orderNumber),
        _itemView("下单时间：", payTime),
        _itemView("发票类型：", "电子普通发票"),
      ],
    );
  }

  ///发票信息
  Widget _invoiceInfo() {
    return Container(
      color: Colors.white,
      height: 251,
      child: Column(
        children: [
          Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      child: SvgPicture.asset(
                        "assets/images/svg/invoicebg.svg",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "增值税电子普通发票",
                          style: TextStyle(
                            color: CustomColors.lightBlue,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          Container(
            height: 175,
            child: Stack(
              children: [
                Column(
                  children: [
                    _itemView("发票内容：", "员工背调报告"),
                    _itemView("发票抬头：", "个人"),
                    _itemView("发票金额：", "¥198.00"),
                    _itemView("开票时间：", "2021-04-15 15:20:55"),
                    _itemView("申请时间：", "2022-02-04 12:03:06"),
                  ],
                ),
                Positioned(
                  right: 13,
                  child: Container(
                    width: 113,
                    height: 69,
                    padding: EdgeInsets.only(top: 50),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/invoice.png'),
                        fit: BoxFit.fill, // 完全填充
                      ),
                    ),
                    child: Container(
                      height: 19,
                      margin: const EdgeInsets.only(bottom: 0),
                      alignment: Alignment.center,
                      color: CustomColors.colorFF00,
                      child: const Text(
                        "点击浏览发票",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///发票公司信息
  Widget _invoiceCompanyView() {
    return Column(
      children: [
        _itemView("公司名称：", "复兴新华媒体科技有限公司"),
        _itemView("单位税号：", "9144000061740323XQ"),
      ],
    );
  }

  ///发票进度
  Widget _invoiceProgressView() {
    // assets/images/1.png

    return Container(
      color: Colors.white,
      height: 238,
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          _itemView("开票进度：", "员工背调报告"),
          Image.asset(
            "assets/images/1.png",
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 20),
            child: WidgetTools().createCustomInkWellButton("点击下载", () {},
                bgColor: CustomColors.lightBlue,
                textColor: Colors.white,
                radius: 32,
                fontSize: 13,
                height: 50,
                shadow: const BoxShadow()),
          ),
        ],
      ),
    );
  }
}
