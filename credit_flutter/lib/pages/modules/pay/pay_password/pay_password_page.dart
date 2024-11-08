/// *
/// -  @Date: 2022-07-11 13:40
/// -  @LastEditTime: 2022-07-11 13:45
/// -  @Description:
///
/// *
/// -  @Date: 2022-07-11 13:40
/// -  @LastEditTime: 2022-07-11 13:40
/// -  @Description: 支付密码
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/modules/pay/pay_password/forgot_payment_password_page.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:flutter/material.dart';

import 'new_modify_payment_password_page.dart';
import 'pay_password_view/pay_password_view_page.dart';
import 'pay_setup_password_view.dart';

class PayPasswordPage extends StatefulWidget {
  const PayPasswordPage({Key? key}) : super(key: key);

  @override
  State<PayPasswordPage> createState() => _PayPasswordPageState();
}

class _PayPasswordPageState extends State<PayPasswordPage>
    implements PayPasswordPageViewClickListener, ClickListener {
  PayPasswordPageView? passwordPageView;
  List<Map<String, dynamic>> infoList = [
    {
      "name": "忘记支付密码",
      "page": const ForgotPaymentPasswordPage(),
      // "page": const ForgotPasswordPage(
      //   type: PageType.payPassword,
      // ),
    },
    {
      "name": "修改支付密码",
      // "page": const ModifyPaymentPasswordPage(),
      "page": const NewModifyPaymentPasswordPage(),
      // "page": const ChangePasswordPage(
      //   type: PageType.payPassword,
      // ),
    },
  ];

  ///是否设置过支付密码
  ///默认是设置过 true
  // bool isPassworedFlag = true;

  @override
  void initState() {
    passwordPageView = PayPasswordPageView(clickListener: this);

    ///获取用户信息
    // UserModel.getInfo((model) {
    //   if (model != null) {
    //     setState(() {
    //       StatefulWidget setupPage = PayPasswordSuccessful(
    //         title: "您已设置过支付密码",
    //         popNumebr: 1,
    //       );
    //
    //       if (model.userInfo.getIfSet()) {
    //         isPassworedFlag = false;
    //         setupPage = const PaySetupPasswordPage();
    //       }
    //
    //       infoList.insert(
    //         0,
    //         {"name": "设置支付密码", "page": setupPage},
    //       );
    //     });
    //   }
    // });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // Golbal.changeNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.color1B7CF6,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "支付密码",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
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
      body: SizedBox(
        child: passwordPageView!.payPasswordListView(infoList),
      ),
    );
  }

  ///------Action
  @override
  tapPayPasswordListItem(int index) {
    Map model = infoList[index];
    String name = model["name"];
    if (model["page"] != null) {
      // if (index > 0) {
      // if (isPassworedFlag == false) {
      //   /// 没有设置过支付密码
      //   showDialog(
      //       context: context,
      //       builder: (context) {
      //         return PopupWindowDialog(
      //           title: "提示",
      //           confirm: "去设置",
      //           cancel: "知道了",
      //           content: "请先设置支付密码",
      //           showCancel: true,
      //           clickListener: this,
      //         );
      //       });
      // } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => model["page"],
      ));
      // }
      // } else {
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => model["page"],
      //   ));
      // }
    }
  }

  @override
  void onCancel() {
    // TODO: implement onCancel
  }

  @override
  void onConfirm(Map<String, dynamic> confirmMap) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PaySetupPasswordPage(),
    ));
  }
}
