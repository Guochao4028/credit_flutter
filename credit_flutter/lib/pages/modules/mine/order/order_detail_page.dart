/// *
/// -  @Date: 2023-06-20 14:51
/// -  @LastEditTime: 2023-08-28 16:36
/// -  @Description:
///
/// *
/// -  @Date: 2022-09-01 15:32
/// -  @LastEditTime: 2022-09-01 15:33
/// -  @Description: 订单详情
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/order_list_model.dart';
import 'package:credit_flutter/pages/modules/mine/order/order_detail_views/order_detail_view.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailsModel? model;

  OrderDetailPage({Key? key, this.model}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailsModel? model;
  OrderDetailView? detailView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.lightBlue,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "订单详情",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
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
      body: detailView?.contentView(model),
    );
  }

  @override
  void initState() {
    super.initState();
    _initUI();
    _initData();
  }

  void _initData() {
    model = widget.model;
  }

  void _initUI() {
    detailView = OrderDetailView();
  }
}
