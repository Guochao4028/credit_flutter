/// *
/// -  @Date: 2022-07-19 17:16
/// -  @LastEditTime: 2022-07-19 17:16
/// -  @Description: 慧眼币说明
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:flutter/material.dart';

class AssetBalanceInstructionsPage extends StatelessWidget {
  const AssetBalanceInstructionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: CustomColors.lightBlue,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "慧眼查购买说明",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "慧眼币使用说明（慧眼币只能用于慧眼查，可以与慧眼查网站和小程序共享）",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "1.用于购买员工背调报告，购买VIP，购买SVIP或购买企业人数。\n2.退款：源路径退款，赠送的慧眼币则不算入退款中。",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "VIP或SVIP会员适用说明",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "1.用户当前已是VIP会员，完成支付后，将会累计会员时长。\n2.用户当前已是SVIP会员，完成支付后，将会累计会员时长。\n3.用户当前已是VIP会员，可点击升级套餐升级SVIP。\n4.用户当前已是SVIP会员，不可降低VIP等待SVIP到期之后才可以更改会员套餐。",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "企业人数使用说明",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "1.用户不是VIP或SVIP不能进行购买人数。\n2.开通VIP或SVIP则可以购买企业人数。",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "子账号会员到期说明",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "1.会员到期后子账号将不能继续使用。",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "关于发票",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "1.VIP会员支付后可在我的订单中开发票。\n2.SVIP会员支付后可在我的订单中开发票。",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ));
  }
}
