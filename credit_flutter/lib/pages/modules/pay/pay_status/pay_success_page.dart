/// *
/// -  @Date: 2023-08-14 11:00
/// -  @LastEditTime: 2023-08-14 11:02
/// -  @Description:支付成功页面
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/manager/order_manager.dart';
import 'package:credit_flutter/models/order_list_model.dart';
import 'package:credit_flutter/pages/modules/login/login_new_page.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:credit_flutter/define/define_keys.dart';

class PaySuccessPage extends StatefulWidget {
  final String orderNo;
  const PaySuccessPage({super.key, required this.orderNo});

  @override
  State<PaySuccessPage> createState() => _PaySuccessPageState();
}

class _PaySuccessPageState extends State<PaySuccessPage> {
  OrderDetailsModel? detailsModel;

  LoginType loginType = LoginType.employer;
  @override
  void initState() {
    var box = Hive.box(HiveBoxs.dataBox);
    int type = box.get(FinalKeys.Quick_STANDING);

    if (type != 2) {
      loginType = LoginType.personal;
    }

    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ScreenTool.topSafeHeight),
        child: SizedBox(
          height: ScreenTool.topSafeHeight,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _orderInfo(),
          const PaySuccessInstructions(),
          _loginButtonView(),
        ],
      ),
    );
  }

  /// 订单信息
  Widget _orderInfo() {
    return Container(
      width: double.infinity,
      height: 245,
      padding: const EdgeInsets.only(left: 16, right: 14, top: 40),
      child: Column(
        children: [
          _icon(),
          _orderInfoItem("订单编号：", detailsModel?.id.toString() ?? ""),
          _orderInfoItem("支付时间：", detailsModel?.getPayTime() ?? ""),
          _orderInfoItem("订单金额：", detailsModel?.amount.toString() ?? "0.0"),
          _orderInfoItem(
              "报告姓名：", detailsModel?.reportUserName.toString() ?? ""),
        ],
      ),
    );
  }

  /// 支付成功Icon
  Widget _icon() {
    return const Column(
      children: [
        Image(
          image: AssetImage("assets/images/successful.png"),
          width: 60,
          height: 60,
          fit: BoxFit.fill,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "支付成功",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  /// 订单itme info
  Widget _orderInfoItem(String titleStr, String contentStr) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.only(left: 32),
      child: Row(
        children: [
          Text(titleStr),
          Text(contentStr),
        ],
      ),
    );
  }

  Widget _loginButtonView() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: WidgetTools().createCustomButton(
        ScreenTool.screenWidth - 60,
        "去登录",
        () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginNewPage(
                    type: loginType,
                    isHiddenBack: true,
                  )));
        },
        fontWeight: FontWeight.bold,
        bgColor: CustomColors.lightBlue,
        textColor: Colors.white,
        radius: 32,
        height: 50,
        shadow: const BoxShadow(),
      ),
    );
  }

  void _initData() {
    String orderId = widget.orderNo;
    if (orderId.isEmpty) {
      var box = Hive.box(HiveBoxs.dataBox);
      orderId = box.get(FinalKeys.Quick_BUY_Order_ID);
    }
    OrderManager.getOrderInfo({
      "orderId": orderId,
    }, (object) {
      detailsModel = object as OrderDetailsModel;
      setState(() {});
    });
  }
}

/// *
/// -  @description: 订单说明
/// -  @Date: 2023-08-14 15:13
/// -  @parm:
/// -  @return {*}
///
class PaySuccessInstructions extends StatefulWidget {
  const PaySuccessInstructions({super.key});

  @override
  State<PaySuccessInstructions> createState() => _PaySuccessInstructionsState();
}

class _PaySuccessInstructionsState extends State<PaySuccessInstructions> {
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  @override
  void initState() {
    tapGestureRecognizer.onTap = () {
      _launchUrl("tel:010-53323535");
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: CustomColors.lightGrey,
          margin: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 16,
            right: 16,
          ),
          height: 1,
        ),
        const Text(
          "请您登录并完成后续流程即可查看报告",
          style: TextStyle(
            color: CustomColors.greyBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        _flowChart(),
        _reminder(),
      ],
    );
  }

  /// 流程图
  Widget _flowChart() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      child: Row(
        verticalDirection: VerticalDirection.up,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _item("icon_flow_report_purchase", "报告购买"),
          _arrow(),
          _item("icon_flow_login", "登录/注册"),
          _arrow(),
          _item("icon_flow_identity_authentication", "身份认证"),
          _arrow(),
          _item("icon_flow_send_message", "发送授权短信"),
          _arrow(),
          _item("icon_flow_candidate_authorization", "候选人授权"),
          _arrow(),
          _item("icon_flow_report_delivery", "报告交付"),
        ],
      ),
    );
  }

  /// 箭头
  Widget _arrow() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: const Icon(
        Icons.arrow_right_alt,
        color: CustomColors.darkGrey,
        size: 18,
      ),
    );
  }

  /// 流程图上item
  Widget _item(String image, String name) {
    return Column(
      children: [
        Image(
          image: AssetImage("assets/images/$image.png"),
          width: 25,
          height: 25,
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  /// 温馨提示
  Widget _reminder() {
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "温馨提示：请您尽快完成登录/注册以免订单丢失，并于90日内完成候选人授权。若超出时限则会导致订单失效，所产生的费用无法退还。",
              style: TextStyle(
                color: CustomColors.lightGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      recognizer: tapGestureRecognizer,
                      text: "010 5332 3535",
                      style: const TextStyle(
                        color: CustomColors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  text: "如有问题请联系客服：",
                  style: const TextStyle(
                    color: CustomColors.lightGrey,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ));
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
}
