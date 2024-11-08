/// *
/// -  @Date: 2022-07-18 18s:09
/// -  @LastEditTime: 2022-07-18 18:10
/// -  @Description:资产管理
///
import 'dart:async';

import 'dart:io';
import 'package:credit_flutter/utils/log.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/models/product_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/mine/asset/asset_balance_instructions.dart';
import 'package:credit_flutter/pages/modules/mine/asset/view/asset_management_view.dart';
import 'package:credit_flutter/pages/modules/mine/order/order_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class AssetManagementPage extends StatefulWidget {
  const AssetManagementPage({Key? key}) : super(key: key);

  @override
  State<AssetManagementPage> createState() => _AssetManagementPageState();
}

class _AssetManagementPageState extends State<AssetManagementPage>
    with SingleTickerProviderStateMixin
    implements AssetManagementViewClickListener {
  ///view
  AssetManagementView? managementView;

  ///动画
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..forward();

  ///用户信息
  UserModel? userModel;

  /// 套餐列表
  List<ProductModel>? productList;

  /// 选中的套餐
  ProductModel? selectModel;

  ///登录类型
  String loginType = "";

  ///套餐列表类型
  int productListType = 3;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  ///苹果后台配置产品ids
  List<String> _kProductIds = <String>[
    'com.checknow.coin195',
    'com.checknow.coin1950',
    'com.checknow.coin975'
  ];

// 产品
  List<ProductDetails> products = <ProductDetails>[];

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();
    super.initState();
    _initDate();
    UmengCommonSdk.onPageStart("asset_management_page");
  }

  _initDate() {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    // 取出数据
    _prefs.then((sp) {
      ///获取用户登录状态
      /// 登录类型1，企业。2，用户
      loginType = sp.getString(FinalKeys.LOGIN_TYPE) ?? "1";
      productListType = loginType == "1" ? 3 : 5;

      MineHomeManager.userGetUserInfo((message) {
        PayManager.getProductList({"type": productListType}, (list) {
          productList = list.cast<ProductModel>();
          UserModel.getInfo((model) {
            Animation<num> _animation = Tween<num>(
              begin: 0,
              end: loginType == "1"
                  ? model?.userInfo.companyInfo.balance ?? 0
                  : model?.userInfo.balance ?? 0,
            ).animate(_controller);
            setState(() {
              if (model != null) {
                userModel = model;
                selectModel = list.first;
                managementView = AssetManagementView(model,
                    dataLists: list,
                    clickListener: this,
                    selectModel: selectModel,
                    loginType: loginType);
                managementView?.animation = _animation;
              }
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航
      appBar: AppBar(
        backgroundColor: CustomColors.lightBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "资产管理",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: managementView?.contentView(),
    );
  }

  @override
  tapListItem(int index) {
    setState(() {
      for (ProductModel model in productList!) {
        model.isSelected = false;
      }
      ProductModel model = productList![index];
      selectModel = model;
      model.isSelected = true;
      managementView?.selectModel = model;
    });
  }

  @override

  ///说明
  tapInstructions() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const AssetBalanceInstructionsPage()));
  }

  @override

  ///支付
  tapPay() {
    if (!Platform.isIOS) {
      _normalPayment();
    } else {
      _appPurchase();
    }
  }

  /// *
  /// -  @description: 苹果内购
  /// -  @Date: 2023-03-30 18:18
  /// -  @parm:
  /// -  @return {*}
  ///
  _appPurchase() {
    if (selectModel != null) {
      String productId = selectModel!.iosProductId;
      EasyLoading.show();

      ProductDetails? productDetail;
      for (var element in _products) {
        if (element.id == productId) {
          productDetail = element;
          break;
        }
      }

      PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetail!,
      );
      _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    }
  }

  /// *
  /// -  @description: 正常支付逻辑，收银台 -》 选择支付方式
  /// -  @Date: 2023-03-30 18:17
  /// -  @parm:
  /// -  @return {*}
  ///
  _normalPayment() {
    if (selectModel != null) {
      String price = selectModel!.price.toString();

      PaymentFromType type = loginType == "1"
          ? PaymentFromType.paymentFromRechargeType
          : PaymentFromType.paymentFromPersonRechargeType;
      String productId = selectModel!.id.toString();

      if (Golbal.isWX == true) {
        PayWXMiniProgramClass.productId = productId;
        PayWXMiniProgramClass.price = price;
        PayWXMiniProgramClass.toPay(type);
      } else {
        PayCheakstandPage page = PayCheakstandPage(
          displayType: PaymentListDisplayType.paymentListOnlyOtherDisplay,
          fromType: type,
          price: price,
        );
        page.productId = productId;

        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => page,
              ),
            )
            .then((val) => val != null ? _refreshData() : null);
      }
    } else {
      ToastUtils.showMessage("价格错误");
    }
  }

  /// *
  /// -  @description: 返回刷新数据
  /// -  @Date: 2022-07-20 18:52
  /// -  @parm:
  /// -  @return {*}
  ///
  _refreshData() {
    productListType = loginType == "1" ? 3 : 5;
    PayManager.getProductList({"type": productListType}, (list) {
      productList = list.cast<ProductModel>();
      UserModel.getInfo((model) {
        setState(() {});
      });
    });
  }

  @override
  tapOrder() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OrderListPage(),
      ),
    );
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    /// 加载待售产品
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });

      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;

      _purchasePending = false;
      _loading = false;
    });

    // // Get subscriptions
    // List<ProductDetails> subscriptions = await _getSubscriptions(
    //   productIds: _kProductIds.toSet(),
    // );
    // // Sort by price
    // subscriptions.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
    // _products = subscriptions;

    // // DEBUG: Print subscriptions
    // print("In app purchase subscription subscriptions: ${subscriptions}");
    // for (var subscription in subscriptions) {
    //   print(
    //       "In app purchase plan: ${subscription.id}: ${subscription.rawPrice}");
    //   print("In app purchase description: ${subscription.description}");
    //   // HOW GET ALL PLANS IN EACH SUBSCRIPTION ID?
    // }

    // await InAppPurchase.instance.restorePurchases();
  }

  // Get subscription
  Future<List<ProductDetails>> _getSubscriptions(
      {required Set<String> productIds}) async {
    ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds);

    return response.productDetails;
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
    UmengCommonSdk.onPageEnd("asset_management_page");
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        Log.i("In app purchase pending...");
        EasyLoading.dismiss();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          Log.i("In app purchase error");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          PayManager.payApple({
            "receipt": purchaseDetails.verificationData.serverVerificationData
          }, (str) {
            Log.i("刷新数据，增加慧眼币");
            Log.i("!!!!!!!!!!!!!!!!!!!");
            _initDate();
          });

          Log.i("服务器校验支付信息");
        }
        if (purchaseDetails.pendingCompletePurchase) {
          Log.i("purchaseDetails.pendingCompletePurchase");
          await _inAppPurchase.completePurchase(purchaseDetails);
          _initDate();
          EasyLoading.dismiss();
        }
      }
    }
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    Log.i("shouldContinueTransaction");
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
