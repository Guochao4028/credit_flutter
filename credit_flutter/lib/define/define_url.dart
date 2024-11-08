/// *
/// @Date: 2022-05-27 13:00
/// @LastEditTime: 2022-06-17 13:26
/// @Description: 网络请求URL

class NetworkingUrls {
  ///用户协议
  static const String h5AllRegisterUrl = "http://auth.nowcheck.cn/register";

  ///隐私协议
  static const String h5AllPrivacyPolicyUrl =
      "http://auth.nowcheck.cn/privacyPolicyH5";

  ///——公共——///
  //图片上传
  static const String uploadImage = "/common/uploadImage";

  ///校验短信验证码
  static const String codeCheck = "/common/codeCheck";

  ///发送认证短信
  static const String smsCheck = "/user/send/authentication/sms";

  ///个人端认证获取认证token
  static const String getVerifyToken = "/person/auth/getVerifyToken";

  ///认证后提交确认
  static const String authCheck = "/user/app/check";

  ///APP实名认证
  static const String appVerify = "/user/app/verify";

  ///获取app版本
  static const String appVersion = "/web/version";

  ///获取FAQ
  static const String faqInfoList = "/web/faq/list";

  ///项目功能开关列表
  static const String projectSwitch = "/common/projectSwitch/list";

  ///意见反馈
  static const String addOpinion = "/web/addOpinion";

  ///是否显示新闻
  static const String newShow = "/news/newsShow";

  ///——登录——///

  /// 访客登录
  static const String loginGuest = "/login/guest";

  /// 合并临时用户数据
  static const String userGuestDataMerge = "/user/guestUserDataMerge";

  /// [注册-下载]用户统计
  static const String userRegisterSummary = "/user/register/summary";

  ///判断手机号是否注册过
  static const String loginPhoneCheck = "/login/phoneCheck";

  ///发送手机验证码
  static const String commonPhoneVerifyCode = "/common/phoneVerifyCode";

  ///验证码登录
  static const String codeUserLogin = "/login/userLogin";

  ///手机号注册
  static const String loginUserRegister = "/login/userRegister";

  ///手机号密码登录
  static const String loginPhonePasswordLogin = "/login/phonePasswordLogin";

  ///编辑公司信息
  static const String companyUpdateCompanyInfo = "/company/updateCompanyInfo";

  ///新增公司
  static const String companyAddCompany = "/company/addCompany";

  ///获取代理商名字
  static const String getAgencyName = "/company/getAgencyName";

  ///查询个人信息
  static const String getUserInfo = "/user/getUserInfo";

  ///套餐列表--->[新]
  static const String productList = "/product/list";

  ///公司会员升级--->[新]
  static const String orderCompanyVipUpGrade = "/order/companyVipUpGrade";

  ///会员升级--->[新]
  static const String productVipUpGrade = "/product/vipUpGrade";

  ///忘记密码
  static const String loginForgetPassword = "/login/forgetPassword";

  ///——新闻——///
  ///新闻详情
  static const String urlGetNews = "/news/getNews";

  ///新闻列表
  static const String urlGetNewsList = "/news/list";

  /// --背调公司--///
  /// 背调公司列表
  static const String backCheckCompanyList = "/backCheckCompany";

  /// 背调公司列表
  static const String backCheckCompanyInfo = "/backCheckCompany/info";

  /// 背调公司评论
  static const String backCheckCompanyComment = "/backCheckCompany/comment";

  /// 背调公司评论点赞
  static const String backCheckCompanyCommentLike =
      "/backCheckCompany/commentLike";

  /// 背调公司评论点赞
  static const String commonTip = "/common/tip";

  /// label列表
  static const String salaryLabelList = "/salary/label/list";

  /// label 搜索
  static const String salarySearch = "/salary/search";

  /// label 详情
  static const String salaryInfo = "/salary/info";

  /// --我的--///
  /// 账户注销
  static const String userLogout = "/user/logout";

  /// 验证密码
  static const String userCheckPassword = "/user/checkPassword";

  /// 验证支付密码
  static const String userCheckPayPassword = "/user/checkPayPassword";

  /// 更新密码
  static const String updatePassword = "/user/updatePassword";

  /// 我的信息
  static const String userGetUserInfo = "/user/getUserInfo";

  ///更新支付密码
  static const String userUpdatePayPassword = "/user/updatePayPassword";

  ///修改个人信息
  static const String userModeify = "/user/modify";

  /// --报告Start-- ///

  /// 企业授权列表
  static const String reportAuthCompanyList = "/reportAuth/company/list";

  /// 报告详情
  static const String reportDetails = "/report";

  /// 报告详情
  static const String zhimaInfo = "/zhima/info";

  /// 获取授权书地址
  static const String authStuffUrl = "/reportAuth/authStuffUrl";

  /// 个人报告详情
  static const String reportSelfDetails = "/report/self";

  /// 个人授权列表
  static const String reportAuthPersonList = "/reportAuth/person/list";

  /// 个人同意授权
  static const String reportAuthPersonAgreeAuth =
      "/reportAuth/person/agreeAuth";

  /// 个人拒绝授权
  static const String reportAuthPersonRefuseAuth =
      "/reportAuth/person/refuseAuth";

  /// 获取未认证，已支付的报告,返回授权报告id集合
  static const String getNotCertifiedReport =
      "/reportAuth/getNotCertifiedReport";

  /// 重复发送短信
  static const String reportAuthMessageAgain = "/reportAuth/message/again";

  /// 通过报告授权id，获取授权信息,短信中的显示名
  static const String companyNameForMessage =
      "/reportAuth/getCompanyNameForMessage";

  /// 短信预授权，并调用e签宝
  static const String messagePrepareSign = "/reportAuth/messagePrepareSign";

  /// 舆情申报添加
  static const String reportPublicOpinion = "/report/publicOpinion";

  /// --报告End-- ///

  /// --支付--///

  ///公司资产
  static const String virtualGetAssets = "/virtual/getAssets";

  ///公司买个人报告(生成订单)
  static const String postOrderCompanyBuyReport =
      "/order/companyBuyPersonReport";

  ///公司买个人报告(生成订单)
  static const String postOrderPersonBuyPersonReport =
      "/order/personBuyPersonReport";

  ///公司买个人报告(生成订单)
  static const String companyBuyPersonReportPersonPay =
      "/order/companyBuyPersonReport/personPay";

  ///公司买人数
  static const String postOrderCompanyBuyPeople = "/order/companyBuyPeople";

  ///公司买会员(生成订单)
  static const String postOrderCompanyBuyVip = "/order/companyBuyVip";

  ///公司买会员(生成订单)
  static const String postOrderCompanyBuySVip = "/order/companyBuySVip";

  ///公司买个人报告,去购买(生成订单)
  static const String postOrderCompanyGotoBuyReport =
      "/order/companyBuyPersonReport/toBuy";

  ///公司购买个人报告升级(生成订单)
  static const String postOrderCompanyReportUpGrade =
      "/order/companyReportUpGrade";

  ///公司买慧眼币(生成订单)
  static const String postOrderCompanyBuyCoin = "/order/companyBuyCoin";

  ///个人购买慧眼币(生成订单)
  static const String postOrderPersonBuyCoin = "/order/personBuyCoin";

  ///获取购买报告的价格
  static const String getReportPrice = "/product/reportPrice";

  ///支付宝app支付
  static const String postPayAlipay = "/pay/alipay/app";

  ///微信app支付
  static const String postPayWechatpay = "/pay/wechat/app";

  ///H5 支付宝H5支付
  static const String postPayAlipayH5 = "/pay/alipay/h5";

  ///H5 微信H5支付
  static const String postPayWechatH5 = "/pay/wechat/h5";

  ///小程序 微信小程序支付
  static const String postPayWechatMiniProgramH5 = "/pay/wechat/miniProgram";

  ///余额支付
  static const String postPayBalance = "/pay/balance";

  ///个人买报告
  static const String personBuyReport = "/order/personBuyReport";

  ///苹果内购
  static const String postPayApple = "/pay/ApplePay";

  ///套餐列表
  static const String getProductList = "/product/list";

  /// --订单--///
  /// 订单详情
  static const String getOrderInfo = "/order/info";

  /// 补充手机号
  static const String psotOrderSupplement = "/order/supplement/phone";

  /// 订单列表(企业端)
  static const String getOrderList = "/order/company/list";

  /// 订单列表(个人端)
  static const String getOrderPersonList = "/order/person/list";

  /// 订单添加发票信息
  static const String postOrderInvoice = "/order/invoice";

  /// 获取发票详情
  static const String getOrderInvoice = "/order/invoice";

  /// 删除订单
  static const String deleteOrder = "/order";

  /// 公司列表
  static const String getCompanyList = "/company/getCompanyList";

  /// 更换公司
  static const String changeCompany = "/company/changeCompany";

  /// 离开公司
  static const String companyLeaveCompany = "/company/leaveCompany";

  /// --公司--///
  /// 公司人员管理列表
  static const String companyUser = "/company/companyUser";

  /// 查询公司增加人员剩余名额
  static const String getPeopleNum = "/company/getPeopleNum";

  /// 状态修改
  static const String postCompanyUserStatus = "/company/companyUser/status";

  /// 消息
  static const String getMessage = "/message";

  /// 消息已读
  static const String messageRead = "/message/read";

  /// 消息已读全部
  static const String messageReadAll = "/message/read/all";

  /// 消息未读数量
  static const String messageUnreadCount = "/message/unreadCount";

  /// 根据公司code获取公司信息
  static const String companyGetInfoByCode = "/company/getInfoByCode";

  /// --个人--///
  /// 填写授权码分享报告给企业
  static const String postShareByCode = "/reportAuth/person/shareByCode";

  /// 发送自己的报告到邮箱
  static const String sendMail = "/report/sendMail/self";

  /// -- 需求中心start -- ///

  /// 需求中心列表
  static const String demandCenterList = "/demandCenter/list";

  /// 需求中心详情
  static const String demandCenterInfo = "/demandCenter/info";

  /// 需求中心修改-添加
  static const String demandCenterSave = "/demandCenter/saveOrUpdate";

  /// 需求中心修改-举报
  static const String demandCenterReport = "/demandCenter/report";

  /// 需求中心 我的需求
  static const String demandCenterMyList = "/demandCenter/my/list";

  /// 需求中心 删除
  static const String demandCenterMyDelete = "/demandCenter/my/delete";

  /// 需求中心 重新发布
  static const String demandCenterMyResubmit = "/demandCenter/my/resubmit";

  /// -- 需求中心end -- ///
}
