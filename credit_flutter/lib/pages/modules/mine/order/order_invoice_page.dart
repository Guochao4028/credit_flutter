/// *
/// -  @Date: 2022-09-02 09:57
/// -  @LastEditTime: 2022-09-02 09:57
/// -  @Description: 发票页
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/order_manager.dart';
import 'package:credit_flutter/models/order_invoice_model.dart';
import 'package:credit_flutter/models/order_list_model.dart';
import 'package:credit_flutter/pages/modules/mine/order/order_invoice_views/order_invoice_view.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderInvoicePage extends StatefulWidget {
  OrderDetailsModel? model;

  OrderInvoicePage({Key? key, this.model}) : super(key: key);

  @override
  State<OrderInvoicePage> createState() => _OrderInvoicePageState();
}

class _OrderInvoicePageState extends State<OrderInvoicePage>
    implements OrderInvoiceOpenViewClickListener {
  String _titleStr = "";

  bool _isOpenInvoice = false;

  bool _isSelectedPersonal = false;

  bool _isSelectedCompany = true;

  OrderInvoiceView? _invoiceView;
  OrderInvoiceModel? invoiceModel;

  OrderDetailsModel? model;

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
          children: [
            Text(
              _titleStr,
              style: const TextStyle(
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
      body: _invoiceView?.contentView(),
    );
  }

  @override
  void initState() {
    super.initState();
    model = widget.model;
    _initUI();
    if (_isOpenInvoice == true) {
    } else {
      _initData();
    }
  }

  void _initUI() {
    if (model?.isOpenInvoice() ?? false) {
      switch (model?.invoiceStatus) {
        case 0:
          {
            _titleStr = "开发票";
            _isOpenInvoice = true;
            _invoiceView = OrderInvoiceOpenView(
                detailsModel: model!,
                isSelectedCompany: _isSelectedCompany,
                isSelectedPersonal: _isSelectedPersonal,
                clickListener: this);
          }
          break;
        case 1:
        case 2:
          {
            _titleStr = "发票详情";
            _isOpenInvoice = false;
            _invoiceView = OrderInvoiceDetailView(
                detailsModel: model!, invoicemodel: invoiceModel);
          }
          break;
        default:
      }
    }
  }

  ///发票详情
  void _initData() {
    OrderManager.getOrderInvoice({"invoiceId": model!.invoiceId}, (object) {
      OrderInvoiceModel m = object as OrderInvoiceModel;
      setState(() {
        invoiceModel = m;
      });
    });
  }

  @override
  tapSelectedCompany() {
    _isSelectedPersonal = false;

    _isSelectedCompany = true;
    setState(() {
      _invoiceView!.isSelectedCompany = _isSelectedCompany;
      _invoiceView!.isSelectedPersonal = _isSelectedPersonal;
    });
  }

  @override
  tapSelectedPersonal() {
    _isSelectedPersonal = true;

    _isSelectedCompany = false;

    setState(() {
      _invoiceView!.isSelectedCompany = _isSelectedCompany;
      _invoiceView!.isSelectedPersonal = _isSelectedPersonal;
    });
  }

  @override
  tapCommit(Map<String, dynamic> mapModel) {
    String name = mapModel["name"];
    String email = mapModel["email"];
    String number = mapModel["number"];

    int orderType = model!.type;
    String contentStr = "";
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

    Map<String, dynamic> parame = {};

    if (_isSelectedCompany) {
      if (StringTools.isEmpty(name)) {
        ToastUtils.showMessage("请填写正确的单位名称");
        return;
      }
      if (StringTools.isEmpty(number)) {
        ToastUtils.showMessage("请填写正确的单位税号");
        return;
      }

      if (StringTools.isEmpty(email)) {
        ToastUtils.showMessage("请填写邮箱");
        return;
      }

      if (StringTools.isEmail(email) == false) {
        ToastUtils.showMessage("请填写正确的邮箱");
        return;
      }

      parame = {
        "content": contentStr,
        "mail": email,
        "orderId": model!.id,
        "titleName": name,
        "tax": number,
        "titleType": 2,
      };
    }
    if (_isSelectedPersonal) {
      if (StringTools.isEmpty(name)) {
        ToastUtils.showMessage("请填写正确的个人名称");
        return;
      }

      if (StringTools.isEmpty(email)) {
        ToastUtils.showMessage("请填写邮箱");
        return;
      }

      if (StringTools.isEmail(email) == false) {
        ToastUtils.showMessage("请填写正确的邮箱");
        return;
      }

      parame = {
        "content": contentStr,
        "mail": email,
        "orderId": model!.id,
        "titleName": name,
        "titleType": 1,
      };
    }

    OrderManager.orderInvoice(parame, (object) {
      ToastUtils.showImageMessage(
          context, "发票申请提交成功", "assets/images/svg/ok.svg");

      // Navigator.pop(context);

      Navigator.pop(context, true);
    });
  }
}
