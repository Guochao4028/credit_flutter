/// *
/// @Date: 2022-05-26 14:10
/// @LastEditTime: 2022-05-26 14:20
/// @Description: 枚举

//登录类型
enum LoginType { company, employer, personal, none }

//状态类型（通用）
enum StateType {
  /// 没有状态
  none,

  /// 成功
  success,

  /// 失败
  fail,

  /// 等待结果中
  waiting,
}

//登录按钮点击时
enum InkWellTapType {
  //验证码
  verificationCode,
  //忘记密码
  forgotPassword,
  //注册
  registeredAccount,
  //账号
  // Account,

  toggle,
}

enum PageType { password, payPassword }

///支付类型
enum HYCPayType {
  ///支付宝支付
  payAli,

  ///微信支付
  payWechat,

  ///余额支付
  payBalance,

  /// 没有状态
  none,
}

//状态类型（通用）
enum ReportBuyType {
  /// 没有状态
  none,

  ///一次
  once,

  ///年付
  year,
}

///支付列表展示类型
enum PaymentListDisplayType {
  ///全部展示（支付宝，微信，余额）
  paymentListAllDisplay,

  ///只展示余额
  paymentListOnlyBalanceDisplay,

  ///展示余额（支付宝，微信）
  paymentListOnlyOtherDisplay,
}

///收银台来源
enum PaymentFromType {
  ///查询
  paymentFromSeachType,

  ///充值
  paymentFromRechargeType,

  ///报告列表
  paymentFromReportListType,

  ///报告详情
  paymentFromReportDetailsType,

  ///会员充值
  paymentFromReportVIPType,

  ///会员充值 - 升级
  paymentFromReportUpgradeType,

  ///个人首页- 购买
  paymentFromPersonType,

  ///个人首页- 个人购买个人报告
  paymentFromPersonBuyPersonReport,

  ///个人充值
  paymentFromPersonRechargeType,

  ///个人购买升级报告
  paymentFromPersonReportUpgradeType,

  ///公司买个人报告,个人付款
  paymentFromPersonalPaymentForCompanyPurchase,

  ///个人自查5五元报告
  paymentFromCheckYourselfForFiveYuan,

  ///购买5元报告后升级
  paymentFrom5yuanReportUpgradeType,

  ///购买前置
  paymentFromQuickBuyType,

  ///个人雇主 购买前置
  paymentFromQuickBuyPersonType,
}
