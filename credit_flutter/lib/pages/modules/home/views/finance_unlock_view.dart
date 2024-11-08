/// *
/// -  @Date: 2023-08-30 17:50
/// -  @LastEditTime: 2023-08-30 17:53
/// -  @Description: 购买5元报告金融报告， 未解锁  视图布局
///

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/financial_risk_partial_report_model.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class FinanceUnlockView extends StatelessWidget {
  FinancialRiskPartialReportModel? model;
  FinanceUnlockView(this.model, {super.key});

  List<String> tableHead = [
    "信用贷款时长",
    "命中网络贷款类机构数",
    "命中消费金融类机构数",
    "贷款逾期订单数",
    "近1个月贷款机构失败扣款笔数",
    "累计逾期额度",
    "历史贷款机构失败扣款笔数",
    "近1个月贷款机构放款笔数",
    "近3个月贷款机构放款笔数",
    "近1个月贷款机构成功扣款笔数",
    "贷款放款总订单数",
    "贷款已结清订单数",
  ];

  List<String> tableMind = [
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
  ];
  List<int> tableEnd = [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4];

  // List<ItemData02> dataList = [];

  @override
  Widget build(BuildContext context) {
    int financeType = 1, onlineLoanType = 1;
    if (model == null) {
      financeType = onlineLoanType = 4;
    } else {
      var list1 = model?.detail.finance.itemData148 ?? [];
      var list2 = model?.detail.onlineLoan.itemData138 ?? [];
      financeType = list1.isEmpty ? 5 : 1;
      onlineLoanType = list2.isEmpty ? 5 : 1;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          const Row(
            children: [
              Image(
                image: AssetImage("assets/images/icon_financial_risk.png"),
                height: 18,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "金融风险",
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.greyBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          _titleView("网贷黑名单查询", onlineLoanType),
          _titleView("互联网金融风险", financeType),
          const SizedBox(height: 5),
          _dataTable()
        ],
      ),
    );
  }

  /// *
  /// -  @description:查询金融数据，用表格显示
  /// -  @Date: 2023-08-30 18:27
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _dataTable() {
    List<TableRow> rows = _loadData();
    double columnWidth = (ScreenTool.screenWidth - 32) / 3;
    return Table(
      columnWidths: {
        0: FixedColumnWidth(columnWidth),
        1: FixedColumnWidth(columnWidth),
      },
      textBaseline: TextBaseline.alphabetic,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );
  }

  /// *
  /// -  @description: 处理表格上显示数据
  /// -  @Date: 2023-08-30 18:51
  /// -  @parm:
  /// -  @return {*}
  ///
  List<TableRow> _loadData() {
    List onlineLoanList = model?.detail.onlineLoan.itemData138 ?? [];
    List<TableRow> rows = [];

    /// 记录命中个数
    /// 因为没有问题时 数组的个数是0，那条有问题就返回那条
    /// 默认个数为12个 ，标题 结果 等级
    /// 如果返回的名称和默认的名称不匹配，这时需要记录一下命中的个数
    /// 如果命中的个数不等于返回的条数，不匹配的条追加到表格里
    int records = 0;

    rows.add(_tableTitleView());
    for (int i = 0; i < tableHead.length; i++) {
      List<TableCell> tableCells = [];
      String srtTitle = tableHead[i];
      String strMind = "0";
      int strEnd = 5;
      if (model == null) {
        strMind = tableMind[i];
        strEnd = tableEnd[i];
      } else {
        if (onlineLoanList.isEmpty) {
          strMind = "0";
          strEnd = 5;
        } else {
          for (ItemData138 item in onlineLoanList) {
            if (item.itemPropLabel == srtTitle) {
              strMind = item.itemPropValue;
              records++;
              if (item.itemPropValue == '0') {
                strEnd = 5;
              } else {
                strEnd = 1;
              }
            }
          }
        }
      }
      _structureTableRows(srtTitle, strMind, strEnd, tableCells, rows);
    }

    if (onlineLoanList.isNotEmpty && onlineLoanList.length != records) {
      for (ItemData138 item in onlineLoanList) {
        String srtTitle = item.itemPropLabel;
        String strMind = "0";
        int strEnd = 5;

        ///记录名字是否匹配到，匹配到就跳过当前循环
        bool flag = false;
        for (int i = 0; i < tableHead.length; i++) {
          String titleName = tableHead[i];
          if (srtTitle == titleName) {
            flag = true;
          }
        }
        if (flag) {
          continue;
        } else {
          List<TableCell> tableCells = [];
          strMind = item.itemPropValue;
          if (item.itemPropValue == '0') {
            strEnd = 5;
          } else {
            strEnd = 1;
          }
          _structureTableRows(srtTitle, strMind, strEnd, tableCells, rows);
        }
      }
    }

    return rows;
  }

  List<TableRow> _structureTableRows(String title, String mind, int end,
      List<TableCell> tableCells, List<TableRow> rows) {
    TextStyle textStyle = const TextStyle(fontSize: 12);
    TableCell cell = TableCell(
        child: Container(
      margin: const EdgeInsets.only(top: 10),
      height: 30,
      child: Text(
        title,
        style: textStyle,
      ),
    ));

    TableCell cell1 = TableCell(
      child: Center(
        child: Text(
          mind,
          style: textStyle,
        ),
      ),
    );

    TableCell cell2 = TableCell(
      child: Center(
        child: _JudgeRisk(end),
      ),
    );

    tableCells.add(cell);
    tableCells.add(cell1);
    tableCells.add(cell2);
    rows.add(TableRow(children: tableCells));
    return rows;
  }

  /// *
  /// -  @description: 表格头 标题
  /// -  @Date: 2023-08-30 18:28
  /// -  @parm:
  /// -  @return {*}
  ///
  TableRow _tableTitleView() {
    TextStyle tableTitleStyle = const TextStyle(
        fontWeight: FontWeight.bold, color: CustomColors.lightBlue);
    List<String> strList = ["调查项目", "调查结果", "风险等级"];
    List<TableCell> tableCells = [];
    for (String str in strList) {
      TableCell cell = TableCell(
        child: Center(
          child: Text(
            str,
            style: tableTitleStyle,
          ),
        ),
      );
      tableCells.add(cell);
    }
    return TableRow(children: tableCells);
  }

  /// *
  /// -  @description: 风险项标题
  /// -  @Date: 2023-08-30 18:05
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _titleView(String titleStr, int judgeRisk) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: [
          Text(
            titleStr,
            style: const TextStyle(
              color: CustomColors.greyBlack,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          const Expanded(
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 0.8,
              dashLength: 1.0,
              dashColor: Color(0xFF99C6FF),
              dashGapLength: 1.0,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          _JudgeRisk(judgeRisk),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }

  /// *
  /// -  @description:风险提示图标
  /// -  @Date: 2023-08-30 17:55
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _JudgeRisk(int type) {
    String url = "";
    switch (type) {
      case 1:
        url = "assets/images/icon_high_risk.png";
        break;
      case 2:
        url = "assets/images/icon_medium_risk.png";
        break;
      case 3:
        url = "assets/images/icon_low_risk.png";
        break;
      case 4:
        url = "assets/images/wenhao.png";
        break;
      default:
        url = "assets/images/icon_no_risk.png";
        break;
    }
    return Image(
      image: AssetImage(url),
      width: 16,
      height: 16,
    );
  }
}
