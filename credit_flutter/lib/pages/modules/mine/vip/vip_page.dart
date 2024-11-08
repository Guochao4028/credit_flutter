import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/manager/vip_manager.dart';
import 'package:credit_flutter/models/set_meal_bean.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/mine/asset/asset_balance_instructions.dart';
import 'package:credit_flutter/pages/modules/mine/order/order_page.dart';
import 'package:credit_flutter/pages/modules/mine/vip/style.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class VipPageWidget extends StatefulWidget {
  const VipPageWidget({Key? key}) : super(key: key);

  @override
  _VipPageWidgetState createState() => _VipPageWidgetState();
}

var _vipPackageBgImagePaths = [
  "assets/images/increaseNumber_bg.png",
  "assets/images/upgradeMember_bg.png",
  "assets/images/restoreMember_bg.png",
];

var _vipPackageTitles = ["增加企业人数", "慧眼查VIP", "慧眼查SVIP"];

class _VipPageWidgetState extends State<VipPageWidget> {
  bool firstTime = false;

  int _personCount = 1;
  int _currentPageIndex = 1;
  int primitive = 1;

  double price = 0.0;

  //1.vip 2.skip 4.企业增加人数
  int setMeal = 1;
  List<SetMealBean>? vipList;
  List<SetMealBean>? svipList;
  SetMealBean? employees;

  UserInfo? userData;
  int difference = 0;

  var vipPackagePageController =
      PageController(viewportFraction: 0.35, initialPage: 1);

  @override
  void initState() {
    super.initState();
    VIPManager.getUserInfo((object) => {
          setState(() {
            userData = object as UserInfo;

            if (userData!.companyInfo.maturityTime.isNotEmpty) {
              var maturityTime = userData!.companyInfo.maturityTime;
              var expire = DateTime.parse(maturityTime);
              DateTime current = DateTime.now();
              difference = expire.difference(current).inDays;
            }

            getProductList();
          })
        });
    UmengCommonSdk.onPageStart("vip_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("vip_page");
  }

  @override
  Widget build(BuildContext context) {
    return _vipPageWidget();
  }

/* 我的订单 */
  void _myOrderAction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderListPage(),
      ),
    );
  }

/* 套餐人数变更 */
  void _changePersonNumber(int count) {
    if (count < 1) {
      count = 1;
      return;
    }
    _personCount = count;
    if (employees != null) {
      price = _personCount * employees!.price;
    }
    setState(() {});
  }

/* 整体页面 */
  Widget _vipPageWidget() {
    var statusHeight = MediaQuery.of(context).padding.top;

    Widget view;
    if (_currentPageIndex != 0) {
      //会员套餐列表
      view = _vipLevelWidget();
    } else {
      //增加人数
      view = _personNumberWidget();
    }

    String title = "";
    switch (_currentPageIndex) {
      case 1:
        title = "VIP会员充值";
        break;
      case 2:
        title = "SVIP会员充值";
        break;
      case 0:
        title = "增加企业人数充值";
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(0.0),
            children: [
              _userInfoWidget(statusHeight),
              //会员套餐选选
              _vipPackage(),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10, bottom: 20),
                child: Text(title,
                    style: const TextStyle(
                        color: Color(0xff131313),
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              view,
              Container(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const AssetBalanceInstructionsPage()));
                },
                child: const Center(
                  child: Text(
                    "充值说明",
                    style: TextStyle(
                        color: CustomColors.connectColor, fontSize: 14),
                  ),
                ),
              ),
              _payment(),
            ],
          ),
        ],
      ),
    );
  }

  //背景卡片和用户信息
  Widget _userInfoWidget(double statusHeight) {
    Widget member;
    String maturityTime = "";
    if (userData?.companyInfo.vipStatus == 1) {
      if (userData?.companyInfo.vipType == 2) {
        maturityTime = userData?.companyInfo.maturityTime ?? "";
        member = WidgetTools().getMemberLogo(2);
      } else if (userData?.companyInfo.vipType == 1) {
        maturityTime = userData?.companyInfo.maturityTime ?? "";
        member = WidgetTools().getMemberLogo(1);
      } else {
        member = const SizedBox();
      }
    } else {
      member = const SizedBox();
    }

    return SizedBox(
      height: 230,
      child: Stack(
        children: <Widget>[
          const Image(
            image: AssetImage("assets/images/vip_bg.png"),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          //标题
          Container(
            width: double.infinity,
            height: 45,
            margin: EdgeInsets.only(top: statusHeight),
            child: Row(
              children: [
                SizedBox(
                  width: 92,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "会员",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 92,
                ),
              ],
            ),
          ),
          //头像
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 38,
                  ),
                  ClipOval(
                    child: Image.network(
                      userData?.headImgUrl ??
                          "https://static.oss.cdn.oss.gaoshier.cn/image/0a50f76b-1651-441d-a8a1-cd38c688e8e0.jpg",
                      fit: BoxFit.cover,
                      width: 38,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData?.companyInfo.licenceName ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  member,
                                  Text(
                                    maturityTime,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(
                height: 38,
              )
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                child: const Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "我的订单",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_sharp,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                onTap: () {
                  _myOrderAction();
                },
              ),
              const SizedBox(
                height: 84,
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///慧眼查套餐 - 会员未过期进入此界面时展示
  Widget _vipPackage() {
    List<Widget> pageList = [
      _vipPackageContainer(0),
      _vipPackageContainer(1),
      _vipPackageContainer(2),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
          child: Text(
            "慧眼查套餐",
            style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
          height: 185,
          child: Stack(
            children: [
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: vipPackagePageController,
                  itemCount: 1000,
                  itemBuilder: (context, index) {
                    return pageList[index % (pageList.length)];
                  },
                  onPageChanged: (int index) async {
                    primitive = index;
                    _currentPageIndex = index % (pageList.length);
                    switch (_currentPageIndex) {
                      case 2:
                        for (var item in svipList!) {
                          if (item.isSelect) {
                            price = item.price;
                          }
                        }
                        break;
                      case 1:
                        for (var item in vipList!) {
                          if (item.isSelect) {
                            price = item.price;
                          }
                        }
                        break;
                      case 0:
                        if (employees != null) {
                          price = _personCount * employees!.price;
                        }
                        break;
                    }
                    setState(() {});
                  },
                ),
              ),
              Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: _currentPageIndex == i ? 17 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(3),
                            color: _currentPageIndex == i
                                ? CreditStyle.pBlueColor
                                : CreditStyle.pBlueColor.withAlpha(77)),
                      );
                    }).toList(),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget _vipPackageContainer(int index) {
    String bgImagePath = _vipPackageBgImagePaths[index];
    String packageTitle = _vipPackageTitles[index];
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (_currentPageIndex == index) {
          return;
        }
        switch (_currentPageIndex) {
          case 0:
            //2-0-1
            if (index == 2) {
              primitive--;
            } else if (index == 1) {
              primitive++;
            }
            break;
          case 1:
            //0-1-2
            if (index == 0) {
              primitive--;
            } else if (index == 2) {
              primitive++;
            }
            break;
          case 2:
            //1-2-0
            if (index == 1) {
              primitive--;
            } else if (index == 0) {
              primitive++;
            }
            break;
        }
        vipPackagePageController.animateToPage(
          primitive,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 250),
        );
      },
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image(
              image: AssetImage(bgImagePath),
              width: _currentPageIndex == index ? 125 : 100,
              height: _currentPageIndex == index ? 150 : 120,
            ),
            Positioned(
              bottom: _currentPageIndex == index ? 21 : 17,
              // width: _currentPageIndex == index ? 125 : 100,
              child: Container(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    packageTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _currentPageIndex == index ? 15 : 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 会员套餐列表
  Widget _vipLevelWidget() {
    int length = 0;
    switch (_currentPageIndex) {
      case 1:
        length = vipList?.length ?? 0;
        break;
      case 2:
        length = svipList?.length ?? 0;
        break;
    }

    MainAxisSize mainAxisSize;
    if (length > 1) {
      mainAxisSize = MainAxisSize.max;
    } else {
      mainAxisSize = MainAxisSize.min;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: SizedBox(
            child: Row(
                mainAxisSize: mainAxisSize,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(length, (i) {
                  if (_currentPageIndex == 1) {
                    return _vipLevelGestureWidget(vipList![i]);
                  } else {
                    return _vipLevelGestureWidget(svipList![i]);
                  }
                }).toList()),
          ),
        ),
      ],
    );
  }

  /// 会员套餐的item
  Widget _vipLevelGestureWidget(SetMealBean data) {
    Color bgColor;
    Color textColor;
    if (data.isSelect) {
      bgColor = CustomColors.color3189F6;
      textColor = CustomColors.color3189F6;
    } else {
      bgColor = CustomColors.colorE4E4E4;
      textColor = CustomColors.darkGrey;
    }

    double? width = (CreditStyle.screenW - 32 - 22) / 3;
    double padding = 0;

    if (_currentPageIndex != 1) {
      if (svipList?.length == 1) {
        width = null;
        padding = 6;
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          price = data.price;
          if (_currentPageIndex == 1) {
            for (SetMealBean value in vipList!) {
              value.isSelect = false;
            }
          } else {
            for (SetMealBean value in svipList!) {
              value.isSelect = false;
            }
          }
          data.isSelect = true;
        });
      },
      child: Container(
        height: ((CreditStyle.screenW - 32 - 22) / 3) * (126 / 107),
        width: width,
        // width: (CreditStyle.screenW - 32 - 22) / 3,
        decoration: BoxDecoration(
          //设置四周圆角 角度
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(width: 1, color: bgColor),
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              padding: EdgeInsets.only(left: padding, right: padding),
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.title,
                      style: const TextStyle(
                        color: CustomColors.darkGrey,
                        fontSize: 14,
                      )),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "¥",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: data.price
                              .toString()
                              .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
                          style: TextStyle(
                              color: textColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (data.isSelect)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Image(
                        image: AssetImage("assets/images/icon_check_mark.png"),
                        width: 28,
                        height: 23,
                      ),
                    ],
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  //增加人数
  Widget _personNumberWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "增加人数",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: CustomColors.greyBlack,
              fontSize: 15,
            ),
          ),
          Container(
            height: 32,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: CustomColors.colorBDBDBD, width: 1)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    child: const SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(
                        Icons.remove,
                        size: 18,
                        color: CustomColors.connectColor,
                      ),
                    ),
                    onTap: () => _changePersonNumber(_personCount -= 1)),
                Container(
                  width: 1,
                  height: 32,
                  color: CustomColors.colorBDBDBD,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    "${_personCount.toString()}人",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: CustomColors.greyBlack, fontSize: 14),
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: CustomColors.colorBDBDBD,
                ),
                GestureDetector(
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.add,
                      color: CustomColors.connectColor,
                      size: 18,
                    ),
                  ),
                  onTap: () => _changePersonNumber(_personCount += 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell _payment() {
    return InkWell(
      child: Container(
        width: double.infinity,
        height: 49,
        margin: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24.5)),
          child: Container(
            color: CustomColors.lightBlue,
            width: double.infinity,
            height: 49,
            alignment: Alignment.center,
            child: Text(
              "支付$price",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        if (_currentPageIndex == 0) {
          //人数 判断是否是vip
          if (userData?.companyInfo.vipStatus != 1) {
            ToastUtils.showMessage("请先开通VIP会员或SVIP会员才能购买人数");
            return;
          }
        } else if (_currentPageIndex == 1) {
          //vip 判断当前是否是svip
          if (userData?.companyInfo.vipStatus == 1) {
            if (userData?.companyInfo.vipType == 2) {
              ToastUtils.showMessage("您已经是SVIP，不能在购买VIP");
              return;
            }
          }
        }

        String id = "";
        if (_currentPageIndex == 0) {
          //人数
          id = "${employees!.id}";
        } else if (_currentPageIndex == 1) {
          //vip
          for (SetMealBean value in vipList!) {
            if (value.isSelect) {
              id = "${value!.id}";
            }
          }
        } else if (_currentPageIndex == 2) {
          // svip
          for (SetMealBean value in svipList!) {
            if (value.isSelect) {
              id = "${value!.id}";
            }
          }
        }

        if (Golbal.isWX == true) {
          PayWXMiniProgramClass.price = price.toString();
          if (_currentPageIndex == 2 &&
              userData?.companyInfo.vipStatus == 1 &&
              userData?.companyInfo.vipType == 1) {
            PayWXMiniProgramClass.toPay(
                PaymentFromType.paymentFromReportUpgradeType);
          } else {
            PayWXMiniProgramClass.type = _currentPageIndex;
            PayWXMiniProgramClass.quantity = "$_personCount";
            PayWXMiniProgramClass.productId = id;
            PayWXMiniProgramClass.toPay(
                PaymentFromType.paymentFromReportVIPType);
          }
        } else {
          PayCheakstandPage page;
          if (_currentPageIndex == 2 &&
              userData?.companyInfo.vipStatus == 1 &&
              userData?.companyInfo.vipType == 1) {
            page = PayCheakstandPage(
              displayType: PaymentListDisplayType.paymentListAllDisplay,
              fromType: PaymentFromType.paymentFromReportUpgradeType,
              price: "$price",
            );
          } else {
            page = PayCheakstandPage(
              displayType: PaymentListDisplayType.paymentListAllDisplay,
              fromType: PaymentFromType.paymentFromReportVIPType,
              price: "$price",
            );
            page.packet = {
              "productId": id,
              "quantity": "$_personCount",
              "type": _currentPageIndex
            };
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        }
      },
    );
  }

  void getProductList() {
    VIPManager.getProductList(setMeal, (object) {
      if (setMeal == 1) {
        vipList = object.cast<SetMealBean>();
        vipList?[0].isSelect = true;
        price = vipList?[0].price ?? 0;
        if (userData?.companyInfo.vipStatus == 1) {
          if (userData?.companyInfo.vipType == 1) {
            VIPManager.productVipUpGrade((object) {
              svipList = <SetMealBean>[];
              SetMealBean bean = SetMealBean(
                  0, 0, double.parse(object), 0, "", " 续费升级$difference天", 0);
              bean.isSelect = true;
              svipList?.add(bean);

              setMeal = 4;
              getProductList();
            });
            return;
          }
        }
        setMeal = 2;
        getProductList();
      } else if (setMeal == 2) {
        svipList = object.cast<SetMealBean>();
        svipList?[0].isSelect = true;
        setMeal = 4;
        getProductList();
      } else if (setMeal == 4) {
        employees = object.cast<SetMealBean>()[0];
        vipPackagePageController.jumpToPage(502);
        setState(() {});
      }
    });
  }
}
