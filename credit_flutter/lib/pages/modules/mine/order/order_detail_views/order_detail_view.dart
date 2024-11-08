/// *
/// -  @Date: 2022-08-30 15:01
/// -  @LastEditTime: 2022-08-30 15:01
/// -  @Description:处理订单详情view
///

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/order_list_model.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:flutter/material.dart';

class OrderDetailView {
  OrderDetailsModel? _detailsModel;
  List<Map<String, dynamic>> titles = [
    {"name": "订单编号：", "type": 1},
    {"name": "购买时间：", "type": 2},
    {"name": "支付方式：", "type": 3},
    {"name": "支付金额：", "type": 4},
  ];

  Widget contentView(OrderDetailsModel? model) {
    _detailsModel = model;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
          // margin: const EdgeInsets.only(left: 16, right: 16),s
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              ///标题
              titleView("订单详情"),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 200,
                child: _listView(1),
              ),
            ],
          ),
        ),
        Container(
          height: 10,
          color: CustomColors.colorF1F4F9,
        ),
        Container(
          padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
          // margin: const EdgeInsets.only(left: 16, right: 16),s
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              titleView("购买内容"),
              SizedBox(
                height: 50,
                child: _listView(2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// *
  /// -  @description: 标题
  /// -  @Date: 2022-09-01 15:54
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget titleView(String titleStr) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Text(
            titleStr,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  ///页面列表
  Widget _listView(int type) {
    if (type == 1) {
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
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          Map<String, dynamic> itemModel = {"name": "订单类型：", "type": 5};
          return _rowListItemView(
            context,
            itemModel,
          );
        },
        itemCount: 1,
        physics: const NeverScrollableScrollPhysics(),
      );
    }
  }

  ///页面列表上item
  Widget _rowListItemView(
    BuildContext context,
    Map model,
  ) {
    String titleStr = model["name"];

    int type = model["type"];
    int orderType = _detailsModel?.type ?? 0;
    int reportType = _detailsModel?.reportType ?? 1;

    String contentStr = "";
    switch (type) {
      case 1:
        contentStr = _detailsModel?.id.toString() ?? "";
        break;
      case 2:
        contentStr = _detailsModel?.getPayTime() ?? "";
        break;
      case 3:
        contentStr = _detailsModel?.getPayType() ?? "";
        break;
      case 4:
        contentStr = StringTools.numberFormat(
            _detailsModel?.amount.toString() ?? "0.0", true);

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
            case 10:
            case 12:
            case 13:
              {
                contentStr = reportType == 5 ? "员工背调报告（基础信息）" : "员工背调报告";
              }
              break;
            case 11:
              {
                contentStr = "订阅员工背调报告";
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
      height: 1,
      color: CustomColors.lineColor,
    );

    Text content = Text(
      contentStr,
      style: const TextStyle(
        color: CustomColors.darkGrey99,
        fontSize: 15,
      ),
    );

    return Container(
      color: Colors.white,
      height: 50,
      child: Column(
        children: [
          line,
          SizedBox(
            height: 49,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                title,
                const SizedBox(width: 20),
                content,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
