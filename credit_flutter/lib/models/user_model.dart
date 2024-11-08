/***
 * @Date: 2022-06-14 21:28
 * @LastEditTime: 2022-06-16 16:57
 * @Description: 用户信息model
 */

import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../define/define_block.dart';
import '../define/define_keys.dart';
import '../tools/db/hive_boxs.dart';
import '../tools/string_tool.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Object {
  @JsonKey(name: 'expiresIn')
  int expiresIn;

  @JsonKey(name: 'userInfo')
  UserInfo userInfo;

  @JsonKey(name: 'refreshIn')
  int refreshIn;

  @JsonKey(name: 'accessToken')
  String accessToken;

  int? reportAuthId;

  UserModel(
    this.expiresIn,
    this.userInfo,
    this.refreshIn,
    this.accessToken,
  );

  factory UserModel.fromJson(Map<String, dynamic> srcJson) =>
      _$UserModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static saveUserInfo(Map<String, dynamic> data) async {
    Golbal.token = data["accessToken"];
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(
        FinalKeys.SHARED_PREFERENCES_LOGIN_KEY, StringTools.map2Json(data));
  }

  static removeUserInfo() async {
    Golbal.token = "";
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(FinalKeys.SHARED_PREFERENCES_LOGIN_KEY);
  }

  static void getInfo(UserModelCallBack callBack) {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
// 取出数据
    prefs.then((sp) {
      String? jsonStr = sp.getString(FinalKeys.SHARED_PREFERENCES_LOGIN_KEY);
      if (jsonStr != null) {
        Map<String, dynamic> map = StringTools.json2Map(jsonStr);
        UserModel model = UserModel.fromJson(map);
        Golbal.token = model.accessToken;
        callBack(model);
      } else {
        callBack(null);
      }
    });
  }

  static saveTempUserInfo(Map<String, dynamic> data) async {
    Golbal.golbalToken = data["accessToken"];
    Box box = Hive.box(HiveBoxs.dataBox);
    box.put(
        FinalKeys.BOX_TEMPORARILY_USER_LOGIN_KEY, StringTools.map2Json(data));
  }

  static void getTempUserInfo(UserModelCallBack callBack) {
    Box box = Hive.box(HiveBoxs.dataBox);
    String jsonStr = box.get(FinalKeys.BOX_TEMPORARILY_USER_LOGIN_KEY) ?? "";
    if (jsonStr.isNotEmpty) {
      Map<String, dynamic> map = StringTools.json2Map(jsonStr);
      UserModel model = UserModel.fromJson(map);

      ///  不用 Golbal.token因为全局做判断登录态时用的就是token
      /// golbalToken 只做临时身份验证
      Golbal.golbalToken = model.accessToken;

      callBack(model);
    } else {
      callBack(null);
    }
  }

  static void updataUserInfo(
      Map<String, dynamic> data, UserModelCallBack callBack) {
    UserModel.removeUserInfo();
    UserModel.saveUserInfo(data);
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
// 取出数据
    prefs.then((sp) {
      String? jsonStr = sp.getString(FinalKeys.SHARED_PREFERENCES_LOGIN_KEY);
      if (jsonStr != null) {
        Map<String, dynamic> map = StringTools.json2Map(jsonStr);
        UserModel model = UserModel.fromJson(map);
        Golbal.token = model.accessToken;
        callBack(model);
      } else {
        callBack(null);
      }
    });
  }
}

@JsonSerializable()
class UserInfo extends Object {
  @JsonKey(name: 'address')
  String address;

  @JsonKey(name: 'area')
  String area;

  @JsonKey(name: 'authorizationCode')
  String authorizationCode;

  @JsonKey(name: 'balance')
  double balance;

  @JsonKey(name: 'birthday')
  String birthday;

  @JsonKey(name: 'certCode')
  String certCode;

  @JsonKey(name: 'childStatus')
  int childStatus;

  @JsonKey(name: 'companyInfo')
  CompanyInfo companyInfo;

  @JsonKey(name: 'companyName')
  String companyName;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'headImgUrl')
  String headImgUrl;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'idCard')
  String idCard;

  @JsonKey(name: 'idCardName')
  String idCardName;

  @JsonKey(name: 'ifSet')
  int ifSet;

  @JsonKey(name: 'industry')
  String industry;

  @JsonKey(name: 'lastLoginTime')
  int lastLoginTime;

  @JsonKey(name: 'loginIp')
  String loginIp;

  @JsonKey(name: 'newPassword')
  String newPassword;

  @JsonKey(name: 'nickName')
  String nickName;

  @JsonKey(name: 'owner')
  int owner;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'payPassword')
  String payPassword;

  @JsonKey(name: 'payPasswordLock')
  int payPasswordLock;

  @JsonKey(name: 'position')
  String position;

  @JsonKey(name: 'reportBuyStatus')
  int reportBuyStatus;

  @JsonKey(name: 'reportEndTime')
  String reportEndTime;

  @JsonKey(name: 'reportId')
  String reportId;

  @JsonKey(name: 'reportType')
  int reportType;

  @JsonKey(name: 'rsaEncryption')
  String rsaEncryption;

  @JsonKey(name: 'telPhone')
  String telPhone;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'userType')
  int userType;

  @JsonKey(name: 'userValue')
  int userValue;

  @JsonKey(name: 'uuid')
  String uuid;

  @JsonKey(name: 'valid')
  int valid;

  @JsonKey(name: 'verifiedStatus')
  int verifiedStatus;

  @JsonKey(name: 'wechatId')
  String wechatId;

  @JsonKey(name: 'workAge')
  String workAge;

  UserInfo(
    this.address,
    this.area,
    this.authorizationCode,
    this.balance,
    this.birthday,
    this.certCode,
    this.childStatus,
    this.companyInfo,
    this.companyName,
    this.createTime,
    this.email,
    this.headImgUrl,
    this.id,
    this.idCard,
    this.idCardName,
    this.ifSet,
    this.industry,
    this.lastLoginTime,
    this.loginIp,
    this.newPassword,
    this.nickName,
    this.owner,
    this.password,
    this.payPassword,
    this.payPasswordLock,
    this.position,
    this.reportBuyStatus,
    this.reportEndTime,
    this.reportId,
    this.reportType,
    this.rsaEncryption,
    this.telPhone,
    this.updateTime,
    this.userType,
    this.userValue,
    this.uuid,
    this.valid,
    this.verifiedStatus,
    this.wechatId,
    this.workAge,
  );

  bool getIfSet() {
    return ifSet == 0;
  }

  /*0.未购买 1.已购买*/
  bool getReportBuyStatus() {
    return reportBuyStatus != 0;
  }

  bool getPayPasswordLock() {
    return payPasswordLock == 1;
  }

  /// *
  /// -  @description: 实名制认证状态(0 未认证 1已认证 2认证中 3失败)
  /// -  @Date: 2022-09-19 14:37
  /// -  @parm:
  /// -  @return {*}
  ///
  bool getUserVerifiedStatus() {
    return verifiedStatus == 1;
  }

  factory UserInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$UserInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable()
class CompanyInfo extends Object {
  @JsonKey(name: 'accountPerson')
  String accountPerson;

  @JsonKey(name: 'agencyCode')
  String agencyCode;

  @JsonKey(name: 'authorizationCode')
  String authorizationCode;

  @JsonKey(name: 'balance')
  double balance;

  @JsonKey(name: 'certCode')
  String certCode;

  @JsonKey(name: 'companyAddress')
  String companyAddress;

  @JsonKey(name: 'contact')
  String contact;

  @JsonKey(name: 'contactWay')
  String contactWay;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'headImgUrl')
  String headImgUrl;

  @JsonKey(name: 'idCardImg')
  String idCardImg;

  @JsonKey(name: 'lastLoginTime')
  String lastLoginTime;

  @JsonKey(name: 'legalPersonName')
  String legalPersonName;

  @JsonKey(name: 'legalPersonPhone')
  String legalPersonPhone;

  @JsonKey(name: 'licenceImg')
  String licenceImg;

  @JsonKey(name: 'licenceName')
  String licenceName;

  @JsonKey(name: 'loginIp')
  String loginIp;

  @JsonKey(name: 'mainIndustry')
  String mainIndustry;

  @JsonKey(name: 'maturityTime')
  String maturityTime;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'nature')
  String nature;

  @JsonKey(name: 'refusedReason')
  String refusedReason;

  @JsonKey(name: 'scale')
  String scale;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'verifiedStatus')
  int verifiedStatus;

  @JsonKey(name: 'vipStatus')
  int vipStatus;

  @JsonKey(name: 'vipType')
  int vipType;

  //企业认证状态(0 未认证 1已认证 2认证中 3失败)
  StateType getVerifiedStatus() {
    switch (verifiedStatus) {
      case 1:
        return StateType.success;
      case 2:
        return StateType.waiting;
      case 3:
        return StateType.fail;
      case 4:
        return StateType.waiting;
      default:
        return StateType.none;
    }
  }

  String getCompanyVerifiedStatus() {
    /// 0 未认证 1已认证 2认证中
    String s = "";
    switch (getVerifiedStatus()) {
      case StateType.fail:
        s = "认证失败";
        break;
      case StateType.success:
        s = "已认证";
        break;
      case StateType.waiting:
        s = "认证中";
        break;
      default:
        s = "未认证";
    }
    return s;
  }

  CompanyInfo(
    this.accountPerson,
    this.agencyCode,
    this.authorizationCode,
    this.balance,
    this.certCode,
    this.companyAddress,
    this.contact,
    this.contactWay,
    this.createTime,
    this.headImgUrl,
    this.idCardImg,
    this.lastLoginTime,
    this.legalPersonName,
    this.legalPersonPhone,
    this.licenceImg,
    this.licenceName,
    this.loginIp,
    this.mainIndustry,
    this.maturityTime,
    this.name,
    this.nature,
    this.refusedReason,
    this.scale,
    this.updateTime,
    this.verifiedStatus,
    this.vipStatus,
    this.vipType,
  );

  factory CompanyInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$CompanyInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CompanyInfoToJson(this);
}
