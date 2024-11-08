import 'package:json_annotation/json_annotation.dart'; 
  
part 'select_replace_company_bean.g.dart';


List<SelectReplaceCompanyBean> getSelectReplaceCompanyBeanList(List<dynamic> list){
    List<SelectReplaceCompanyBean> result = [];
    list.forEach((item){
      result.add(SelectReplaceCompanyBean.fromJson(item));
    });
    return result;
  }
@JsonSerializable()
  class SelectReplaceCompanyBean extends Object {

  @JsonKey(name: 'accountPerson')
  String accountPerson;

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

  @JsonKey(name: 'id')
  int id;

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

  @JsonKey(name: 'peopleNum')
  int peopleNum;

  @JsonKey(name: 'refusedReason')
  String refusedReason;

  @JsonKey(name: 'scale')
  String scale;

  @JsonKey(name: 'updateTime')
  String updateTime;

  @JsonKey(name: 'valid')
  int valid;

  @JsonKey(name: 'verifiedStatus')
  int verifiedStatus;

  @JsonKey(name: 'vipStatus')
  int vipStatus;

  @JsonKey(name: 'vipType')
  int vipType;

  SelectReplaceCompanyBean(this.accountPerson,this.authorizationCode,this.balance,this.certCode,this.companyAddress,this.contact,this.contactWay,this.createTime,this.headImgUrl,this.id,this.idCardImg,this.lastLoginTime,this.legalPersonName,this.legalPersonPhone,this.licenceImg,this.licenceName,this.loginIp,this.mainIndustry,this.maturityTime,this.name,this.nature,this.peopleNum,this.refusedReason,this.scale,this.updateTime,this.valid,this.verifiedStatus,this.vipStatus,this.vipType,);

  factory SelectReplaceCompanyBean.fromJson(Map<String, dynamic> srcJson) => _$SelectReplaceCompanyBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SelectReplaceCompanyBeanToJson(this);

}

  
