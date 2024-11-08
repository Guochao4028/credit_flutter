// ignore_for_file: unused_import

/// *
/// -  @Date: 2022-06-17 14:14
/// -  @LastEditTime: 2022-06-17 14:17
/// -  @Description: 背调公司
///
import 'dart:convert';

import 'package:credit_flutter/define/define_block.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/define/define_url.dart';
import 'package:credit_flutter/models/back_check_company_info_model.dart';
import 'package:credit_flutter/models/back_check_company_list_model.dart';
import 'package:credit_flutter/models/financial_risk_partial_report_model.dart';
import 'package:credit_flutter/models/networking_message_model.dart';
import 'package:credit_flutter/models/partial_report_model.dart';
import 'package:credit_flutter/models/report_data_bean.dart';
import 'package:credit_flutter/models/report_details_bean.dart';
import 'package:credit_flutter/models/report_home_bean.dart';
import 'package:credit_flutter/network/dio_client.dart';
import 'package:dio/dio.dart';

class ReportDetailsManager {
  /// *
  /// -  @description: 背调公司列表
  /// -  @Date: 2022-06-17 14:19
  /// -  @parm:
  /// -  @return {*}
  ///
  static getReportDetails(
      String reportAuthId, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
        NetworkingUrls.reportDetails,
        queryParameters: {"reportAuthId": reportAuthId});

    callBack(ReportDetailsBean.fromJson(response.data));
  }

  /// *
  /// -  @description: 个人报告详情
  /// -  @Date: 2022-09-23 14:39
  /// -  @parm:
  /// -  @return {*}
  ///
  static getSelfReportDetails(NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
      NetworkingUrls.reportSelfDetails,
    );

    callBack(ReportDetailsBean.fromJson(response.data));
  }

  static exampleDetails(NetworkObjectCallBack callBack) async {
    String data =
        '{"birthDay":234979200000,"carInfos":null,"companyRegistrationInfos":null,"currentAddress":"四川省资阳市**区**小区**栋*单元*楼***号","educations":[{"beginTime":462816000000,"diploma":"无","educationalBackground":"小学","endTime":646761600000,"name":"乐至县大佛镇红鞍小学"},{"beginTime":652118400000,"diploma":"无","educationalBackground":"初中","endTime":741456000000,"name":"四川新津中学"},{"beginTime":746812800000,"diploma":"本科学位证书","educationalBackground":"高中","endTime":836150400000,"name":"四川师范高中"},{"beginTime":841507200000,"diploma":"本科学位证书","educationalBackground":"本科","endTime":962380800000,"name":"北京大学"},{"beginTime":967737600000,"diploma":"硕士学位","educationalBackground":"研究生","endTime":1056988800000,"name":"北京大学"}],"gender":"女","hometown":"四川省***","houseInfos":null,"id":"62a30ac920b42b6fed230d54","idCard":"125*************92","idCardName":"张*","industryBan":null,"loanInfos":null,"marital":"已婚","maritalInfo":null,"nationality":"汉族","pastExperience":[{"createTime":220896000000,"title":"出生"},{"createTime":441734400000,"title":"就读于乐至县大佛镇红鞍小学"},{"createTime":631123200000,"title":"就读于四川新津中学"},{"createTime":725817600000,"title":"就读于四川师范高中"},{"createTime":820425600000,"title":"就读于北京大学"},{"createTime":946656000000,"title":"就读于北京大学研究生"},{"createTime":1104508800000,"title":"结婚"},{"createTime":1147363200000,"title":"获得计算机一级证书"},{"createTime":1172678400000,"title":"获得环保工程师资格证书"},{"createTime":1333641600000,"title":"获得环境影响评价工程师资格证书"},{"createTime":1430928000000,"title":"获得排水工程师资格证书"},{"createTime":1546272000000,"title":"离婚"},{"createTime":1563206400000,"title":"被列入失信被执行人名单，并对其采取限制高消费措施。"},{"createTime":1599408000000,"title":"获得环境监测资格证书"},{"createTime":0,"title":"目前仍就职于资阳市乐至县环保局。"}],"personalRiskInfos":[{"administrative":1,"court":1,"courtAnnouncement":0,"courtService":0,"executed":0,"failure":1,"filing":2,"finalCase":0,"judgment":1,"judicial":1,"marketSurveillance":0,"taxViolation":0}],"phone":"152****5276","politicalStatus":"党员","publicInformation":[{"link":"","publicCase":"四川省资阳市雁江区人民检察院以雁检公诉刑诉[2018]745号起诉书指控被告人樊丽娟犯危险驾驶罪，于2018年11月30日向本院提起公诉。本院于当日立案。","punish":"暂无","type":1},{"link":"","publicCase":"四川省资阳市雁江区人民检察院以雁检公诉刑诉[2022]7127号起诉书指控被告人樊丽娟犯盗窃罪，于2022年5月1日向本院提起公诉。本院于当日立案。","punish":"暂无","type":1},{"link":"","publicCase":"2018年12月28日公开开庭审理了本案。四川省资阳市雁江区人民检察院指派检察员吴文渊、马晨涛、书记员高子奡、石原出庭支持公诉，被告人樊丽娟及辩护人刘宗权到庭参加了诉讼。本案经合议庭评议、审判委员会讨论并作出决定。现已审理终结。","punish":"暂无","type":2},{"link":"","publicCase":"被告人樊丽娟醉酒后在道路上驾驶机动车，其行为已构成危险驾驶罪。公诉机关指控罪名成立，本院予以支持。樊丽娟到案后如实供述犯罪事实，可以从轻处罚。","punish":"暂无","type":3},{"link":"","publicCase":"经资阳市公安局物证鉴定所鉴定，樊丽娟血液中乙醇含量为169.25mg/100ml，樊丽娟犯危险驾驶罪。","punish":"被告人樊丽娟犯危险驾驶罪，判处拘役二个月，缓刑三个月，并处罚金人民币三千元。","type":4},{"link":"","publicCase":"樊某因选购花卉与店主发生纠纷拨打110报警，在处警民警处置现场警情时，借故提前离开事发现场。民警电话通知其返回现场接受调查，樊某因对民警电话中言语不满，先后六次通过拨打民警电话和发送短信的方式辱骂民警。民警报案后，雁江区公安分局受理该案，调查后认为樊某的行为构成阻碍人民警察依法执行职务。","punish":"对樊某作出行政拘留5日的行政处罚。","type":5},{"link":"","publicCase":"樊某与上海某融资租赁公司签订了《车辆融资租赁合同》，依照合同约定，该公司依据方某对车辆的需求出资93000元购置车辆一台，并将该车辆租赁给方某使用。同时，为确保方某及时足额支付租金，双方另签订了《车辆抵押合同》，约定其将租赁车辆抵押登记给上海某融资租赁公司，并办理抵押登记，为其在《车辆融资租赁合同》中的全部债务提供担保。随后，该公司便将租赁车辆交付给樊某，但樊某却未如约支付租金，经该公司多次向方某催收所欠租金均未果。2021年1月，该公司遂向临湘法院提起诉讼。经法院主持调解，双方达成调解协议，在2021年5月25日前，樊某按月分期支付上海某融资租赁公司车辆融资租金及违约金共计2万余元。协议生效后，樊某按期支付了1万余元租金后便没了下文，该公司遂向法院申请强制执行。","punish":"执行人员又多次与方某进行沟通，想起悉心释法，并严肃告知其拒不履行法律义务应承担的后果，但方某仍拒不配合。执行法官将其纳入失信黑名单、限制高消费等强制措施。","type":6},{"link":"","publicCase":"暂无","punish":"暂无","type":7},{"link":"","publicCase":"暂无","punish":"暂无","type":8},{"link":"","publicCase":"暂无","punish":"暂无","type":9},{"link":"","publicCase":"暂无","punish":"暂无","type":10},{"link":"","publicCase":"暂无","punish":"暂无","type":11},{"link":"","publicCase":"暂无","punish":"暂无","type":12}],"reportType":2,"riskWarning":[{"createTime":1543507200000,"title":"危险驾驶案件信息"},{"createTime":1651334400000,"title":"盗窃案件信息"},{"createTime":1654272000000,"title":"行政处罚信息"},{"createTime":1621872000000,"title":"失信信息"}],"skillsCertificates":[{"code":"5603*****600","createTime":1147363200000,"name":"计算机一级证书"},{"code":"6953******00","createTime":1172678400000,"name":"环保工程师资格证书"},{"code":"11254******00","createTime":1333641600000,"name":"环境影响评价工程师资格证书"},{"code":"3692******00","createTime":1430928000000,"name":"排水工程师资格证书"},{"code":"1684******00","createTime":1599408000000,"name":"环境监测资格证书"}],"workExperience":[{"beginTime":1059667200000,"endTime":0,"incomeEstimates":"","name":"资阳市乐至县环保局","position":"局长","socialSecurityBeginTime":1059667200000,"socialSecurityEndTime":0,"time":"2003.07.31-至今"}]}';
    var json = jsonDecode(data);
    callBack(ReportDetailsBean.fromJson(json));
  }

  static var json = {
    "creditReportDigest": {
      "reportId": "4202302200000388546",
      "name": "赵蓝天",
      "idNo": "370402199905207735",
      "mobile": "15300266275",
      "sex": "男",
      "nation": null,
      "householdAddr": "山东省枣庄市市中区",
      "birthday": 927129600000,
      "reviewStatus": 1,
      "identityRiskLevel": "无风险",
      "mobileOperatorsRiskLevel": null,
      "socialRiskLevel": "无风险",
      "fraudRiskLevel": null,
      "financeRiskLevel": "无风险",
      "courtRiskLevel": "无风险",
      "busiInfoRiskLevel": "无风险",
      "finaSupervisionRiskLevel": null,
      "eduOccupationRiskLevel": "核实中",
      "globalDatabaseRiskLevel": null,
      "referenceRiskLevel": null,
      "faceCheckRiskLevel": null,
      "healthRiskLevel": null,
      "otherRiskLevel": null,
      "mediaLibraryRiskLevel": null,
      "occupationRiskLevel": null,
      "riskScore": 85,
      "failNum": 0,
      "failItemNum": 0,
      "addressCheckRiskLevel": null,
      "penaltyRiskLevel": null,
      "eduRiskLevel": null,
      "qualificationsRiskLevel": null,
      "litigationRiskLevel": null,
      "resumeRiskLevel": null,
      "performanceRiskLevel": null,
      "resumeAndPerformanceRiskLevel": null,
      "resumeComparisonRiskLevel": null,
      "riskLevel": "核实中",
      "createTime": 1676890160000
    },
    "summary": "核实中",
    "outline": {"highestEducational": null, "highestEducationalSchool": null},
    "digestMap": {
      "digestMapInfo": {"realNamCheck": true},
      "digestListInfo": [
        {
          "result": "已查得",
          "level": "noData",
          "name": "身份风险",
          "risk": "无风险",
          "remark": "核实候选人身份信息真实性"
        },
        {
          "result": "未查得",
          "level": "yes",
          "name": "社会风险",
          "risk": "无风险",
          "remark": "核实候选人社会治安风险记录"
        },
        {
          "result": "未查得",
          "level": "yes",
          "name": "诉讼及处罚风险",
          "risk": "无风险",
          "remark": "核实候选人法院诉讼、失信、执行及其他行政处罚记录"
        },
        {
          "result": "未查得",
          "level": "noData",
          "name": "教育及资格风险",
          "risk": "核实中",
          "remark": "核实候选人教育背景及职业资格真实性"
        },
        {
          "result": "未查得",
          "level": "yes",
          "name": "商业利益风险",
          "risk": "无风险",
          "remark": "核实候选人名下是否有工商注册信息"
        },
        {
          "result": "未查得",
          "level": "yes",
          "name": "金融信用风险",
          "risk": "无风险",
          "remark": "核实候选人金融违约欺诈记录"
        }
      ]
    },
    "spiderDetail": null,
    "employerRefereeInfoList": null,
    "reportDeclare":
        "应慧眼查（北京）数据科技有限公司的委托，为了降低企业招聘人才的风险，就赵蓝天的工作背景做细致的调查，本次调查结果获取途径合法，内容真实有效。本报告不得用于法律诉讼依据，仅供招聘决策参考之用。在任何情况下，对由于使用本报告所造成的损失，本公司不承担任何责任。且未经本公司许可，本报告内容不得向包括候选人在内的任何第三方透露。",
    "reportInfo": {
      "birthday": "19990520",
      "orgName": "慧眼查（北京）数据科技有限公司",
      "riskLevel": "核实中",
      "completeTime": 1676890022000,
      "userId": "202302080000367409",
      "isEffective": 1,
      "orgNameEn": null,
      "modifyTime": 1676890160000,
      "tplName": "慧眼查测试版2",
      "createTime": 1676890022000,
      "objectiveStatus": 4,
      "id": "4202302200000388546",
      "tplId": "202302090000368319",
      "sendAuthName": null,
      "isContainOffline": 0,
      "status": 13
    },
    "detail": {
      "102": {
        "queryCost": 0.5,
        "itemId": "1170330211338038028",
        "itemName": "户籍信息核实",
        "itemData": [
          {
            "itemPropLabel": "原始发证地",
            "itemPropName": "nativePlace",
            "itemPropValue": "四川",
            "set": false
          },
          {
            "itemPropLabel": "出生日期",
            "itemPropName": "birthday",
            "itemPropValue": "19**-**-**",
            "set": false
          },
          {
            "itemPropLabel": "性别",
            "itemPropName": "gender",
            "itemPropValue": "*",
            "set": false
          },
          {
            "itemPropLabel": "身份证号",
            "itemPropName": "idNo",
            "itemPropValue": "*************",
            "set": false
          },
          {
            "itemPropLabel": "姓名",
            "itemPropName": "name",
            "itemPropValue": "***",
            "set": false
          }
        ],
        "callSuccess": true,
        "itemCode": "102",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "136": {
        "queryCost": 20,
        "itemId": "1709041053397191001",
        "itemName": "个人工商信息核实",
        "itemData": [
          {
            "itemPropLabel": "高管信息",
            "itemPropName": "managementInfo",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "注册号",
                  "itemPropName": "regno",
                  "itemPropValue": "110*********261",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）名称",
                  "itemPropName": "unitName",
                  "itemPropValue": "北京****科技有限公司",
                  "set": false
                },
                {
                  "itemPropLabel": "企业类型",
                  "itemPropName": "enttype",
                  "itemPropValue": "有限责任公司(自然人独资)",
                  "set": false
                },
                {
                  "itemPropLabel": "成立时间",
                  "itemPropName": "establishmentTime",
                  "itemPropValue": "2019-09-19",
                  "set": false
                },
                {
                  "itemPropLabel": "统一社会信用代码",
                  "itemPropName": "creditcode",
                  "itemPropValue": "911***********F87Q",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本币种",
                  "itemPropName": "unitRegCapCur",
                  "itemPropValue": "人民币元",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本（万元）",
                  "itemPropName": "unitRegCap",
                  "itemPropValue": "50.000005",
                  "set": false
                },
                {
                  "itemPropLabel": "企业状态",
                  "itemPropName": "enterpriseState",
                  "itemPropValue": "存续（在营、开业、在册）",
                  "set": false
                },
                {
                  "itemPropLabel": "职务",
                  "itemPropName": "position",
                  "itemPropValue": "执行董事",
                  "set": false
                },
                {
                  "itemPropLabel": "省份",
                  "itemPropName": "province",
                  "itemPropValue": "北京市",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "法人信息",
            "itemPropName": "frList",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "企业类型",
                  "itemPropName": "enttype",
                  "itemPropValue": "有限责任公司(自然人独资)",
                  "set": false
                },
                {
                  "itemPropLabel": "成立时间",
                  "itemPropName": "establishmentTime",
                  "itemPropValue": "2019-09-19",
                  "set": false
                },
                {
                  "itemPropLabel": "注册号",
                  "itemPropName": "regno",
                  "itemPropValue": "110*********261",
                  "set": false
                },
                {
                  "itemPropLabel": "统一社会信用代码",
                  "itemPropName": "creditcode",
                  "itemPropValue": "911***********F87Q",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本币种",
                  "itemPropName": "unitRegCapCur",
                  "itemPropValue": "人民币元",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）名称",
                  "itemPropName": "unitName",
                  "itemPropValue": "北京****科技有限公司",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本（万元）",
                  "itemPropName": "unitRegCap",
                  "itemPropValue": "50.000005",
                  "set": false
                },
                {
                  "itemPropLabel": "企业状态",
                  "itemPropName": "enterpriseState",
                  "itemPropValue": "存续（在营、开业、在册）",
                  "set": false
                },
                {
                  "itemPropLabel": "省份",
                  "itemPropName": "province",
                  "itemPropValue": "北京市",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "股东信息",
            "itemPropName": "shareholderInfo",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "企业名称",
                  "itemPropName": "entname",
                  "itemPropValue": "宁波****咨询有限公司",
                  "set": false
                },
                {
                  "itemPropLabel": "注册号",
                  "itemPropName": "regno",
                  "itemPropValue": "330********248",
                  "set": false
                },
                {
                  "itemPropLabel": "企业类型",
                  "itemPropName": "enttype",
                  "itemPropValue": "有限责任公司（自然人投资或控股）",
                  "set": false
                },
                {
                  "itemPropLabel": "注册资本（万元）",
                  "itemPropName": "regcap",
                  "itemPropValue": "100.000005",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本币种",
                  "itemPropName": "unitRegCapCur",
                  "itemPropValue": "人民币",
                  "set": false
                },
                {
                  "itemPropLabel": "企业状态",
                  "itemPropName": "enterpriseState",
                  "itemPropValue": "注销",
                  "set": false
                },
                {
                  "itemPropLabel": "认缴出资额（万元）",
                  "itemPropName": "subconam",
                  "itemPropValue": "70.000005",
                  "set": false
                },
                {
                  "itemPropLabel": "出资方式",
                  "itemPropName": "conform",
                  "itemPropValue": "9",
                  "set": false
                },
                {
                  "itemPropLabel": "出资比例",
                  "itemPropName": "fundedRatio",
                  "itemPropValue": "70.05%",
                  "set": false
                }
              ],
              [
                {
                  "itemPropLabel": "企业名称",
                  "itemPropName": "entname",
                  "itemPropValue": "宁波****科技有限公司",
                  "set": false
                },
                {
                  "itemPropLabel": "注册号",
                  "itemPropName": "regno",
                  "itemPropValue": "330********4610",
                  "set": false
                },
                {
                  "itemPropLabel": "企业类型",
                  "itemPropName": "enttype",
                  "itemPropValue": "有限责任公司（自然人投资或控股）",
                  "set": false
                },
                {
                  "itemPropLabel": "注册资本（万元）",
                  "itemPropName": "regcap",
                  "itemPropValue": "200.000005",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本币种",
                  "itemPropName": "unitRegCapCur",
                  "itemPropValue": "人民币",
                  "set": false
                },
                {
                  "itemPropLabel": "企业状态",
                  "itemPropName": "enterpriseState",
                  "itemPropValue": "在营（开业）",
                  "set": false
                },
                {
                  "itemPropLabel": "认缴出资额（万元）",
                  "itemPropName": "subconam",
                  "itemPropValue": "40.000005",
                  "set": false
                },
                {
                  "itemPropLabel": "出资方式",
                  "itemPropName": "conform",
                  "itemPropValue": "1",
                  "set": false
                },
                {
                  "itemPropLabel": "出资比例",
                  "itemPropName": "fundedRatio",
                  "itemPropValue": "20.05%",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "企业行政处罚历史信息",
            "itemPropName": "zsPerPersoncaseinfoList",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "注册号",
                  "itemPropName": "regno",
                  "itemPropValue": "110*********261",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）名称",
                  "itemPropName": "unitName",
                  "itemPropValue": "北京****科技有限公司",
                  "set": false
                },
                {
                  "itemPropLabel": "企业类型",
                  "itemPropName": "enttype",
                  "itemPropValue": "有限责任公司(自然人独资)",
                  "set": false
                },
                {
                  "itemPropLabel": "成立时间",
                  "itemPropName": "establishmentTime",
                  "itemPropValue": "2019-09-19",
                  "set": false
                },
                {
                  "itemPropLabel": "统一社会信用代码",
                  "itemPropName": "creditcode",
                  "itemPropValue": "911***********F87Q",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本币种",
                  "itemPropName": "unitRegCapCur",
                  "itemPropValue": "人民币元",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本（万元）",
                  "itemPropName": "unitRegCap",
                  "itemPropValue": "50.000005",
                  "set": false
                },
                {
                  "itemPropLabel": "企业状态",
                  "itemPropName": "enterpriseState",
                  "itemPropValue": "存续（在营、开业、在册）",
                  "set": false
                },
                {
                  "itemPropLabel": "职务",
                  "itemPropName": "position",
                  "itemPropValue": "执行董事",
                  "set": false
                },
                {
                  "itemPropLabel": "省份",
                  "itemPropName": "province",
                  "itemPropValue": "北京市",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "被执行人信息",
            "itemPropName": "zsPerPunishedList",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "注册号",
                  "itemPropName": "regno",
                  "itemPropValue": "110*********261",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）名称",
                  "itemPropName": "unitName",
                  "itemPropValue": "北京****科技有限公司",
                  "set": false
                },
                {
                  "itemPropLabel": "企业类型",
                  "itemPropName": "enttype",
                  "itemPropValue": "有限责任公司(自然人独资)",
                  "set": false
                },
                {
                  "itemPropLabel": "成立时间",
                  "itemPropName": "establishmentTime",
                  "itemPropValue": "2019-09-19",
                  "set": false
                },
                {
                  "itemPropLabel": "统一社会信用代码",
                  "itemPropName": "creditcode",
                  "itemPropValue": "911***********F87Q",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本币种",
                  "itemPropName": "unitRegCapCur",
                  "itemPropValue": "人民币元",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本（万元）",
                  "itemPropName": "unitRegCap",
                  "itemPropValue": "50.000005",
                  "set": false
                },
                {
                  "itemPropLabel": "企业状态",
                  "itemPropName": "enterpriseState",
                  "itemPropValue": "存续（在营、开业、在册）",
                  "set": false
                },
                {
                  "itemPropLabel": "职务",
                  "itemPropName": "position",
                  "itemPropValue": "执行董事",
                  "set": false
                },
                {
                  "itemPropLabel": "省份",
                  "itemPropName": "province",
                  "itemPropValue": "北京市",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "失信被执行人信息",
            "itemPropName": "zsPerPunishbreakList",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "注册号",
                  "itemPropName": "regno",
                  "itemPropValue": "110*********261",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）名称",
                  "itemPropName": "unitName",
                  "itemPropValue": "北京****科技有限公司",
                  "set": false
                },
                {
                  "itemPropLabel": "企业类型",
                  "itemPropName": "enttype",
                  "itemPropValue": "有限责任公司(自然人独资)",
                  "set": false
                },
                {
                  "itemPropLabel": "成立时间",
                  "itemPropName": "establishmentTime",
                  "itemPropValue": "2019-09-19",
                  "set": false
                },
                {
                  "itemPropLabel": "统一社会信用代码",
                  "itemPropName": "creditcode",
                  "itemPropValue": "911***********F87Q",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本币种",
                  "itemPropName": "unitRegCapCur",
                  "itemPropValue": "人民币元",
                  "set": false
                },
                {
                  "itemPropLabel": "企业（机构）注册资本（万元）",
                  "itemPropName": "unitRegCap",
                  "itemPropValue": "50.000005",
                  "set": false
                },
                {
                  "itemPropLabel": "企业状态",
                  "itemPropName": "enterpriseState",
                  "itemPropValue": "存续（在营、开业、在册）",
                  "set": false
                },
                {
                  "itemPropLabel": "职务",
                  "itemPropName": "position",
                  "itemPropValue": "执行董事",
                  "set": false
                },
                {
                  "itemPropLabel": "省份",
                  "itemPropName": "province",
                  "itemPropValue": "北京市",
                  "set": false
                }
              ]
            ],
            "set": true
          }
        ],
        "callSuccess": true,
        "itemCode": "136",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "138": {
        "queryCost": 20,
        "itemId": "1709081137165501006",
        "itemName": "网贷黑名单",
        "itemData": [
          {
            "itemPropLabel": "命中结果",
            "itemPropName": "wdhmdFraudHit",
            "itemPropValue": "命中",
            "set": false
          }
        ],
        "callSuccess": true,
        "itemCode": "138",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "182": {
        "queryCost": 20,
        "itemId": "201801310000041550",
        "itemName": "技工院校毕业证书",
        "itemData": [
          {
            "itemPropLabel": "院校名称",
            "itemPropName": "universityName",
            "itemPropValue": "山西海运技工学校",
            "set": false
          },
          {
            "itemPropLabel": "姓名",
            "itemPropName": "name",
            "itemPropValue": "**",
            "set": false
          },
          {
            "itemPropLabel": "性别",
            "itemPropName": "gender",
            "itemPropValue": "女",
            "set": false
          },
          {
            "itemPropLabel": "出生日期",
            "itemPropName": "birthday",
            "itemPropValue": "1996年04月05日",
            "set": false
          },
          {
            "itemPropLabel": "入学时间",
            "itemPropName": "entranceTime",
            "itemPropValue": "2012年09月01日",
            "set": false
          },
          {
            "itemPropLabel": "毕业时间",
            "itemPropName": "graduationTime",
            "itemPropValue": "2015年06月30日",
            "set": false
          },
          {
            "itemPropLabel": "专业类别",
            "itemPropName": "professionalCategory",
            "itemPropValue": "幼儿教育",
            "set": false
          },
          {
            "itemPropLabel": "专业等级",
            "itemPropName": "professionalGrade",
            "itemPropValue": "中级",
            "set": false
          },
          {
            "itemPropLabel": "学习形式",
            "itemPropName": "studyType",
            "itemPropValue": "全日制",
            "set": false
          },
          {
            "itemPropLabel": "学制",
            "itemPropName": "schoolLength",
            "itemPropValue": "三年",
            "set": false
          }
        ],
        "callSuccess": true,
        "itemCode": "182",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "184": {
        "queryCost": 20,
        "itemId": "201802050000043570",
        "itemName": "国内高等教育学位核实",
        "itemData": [
          {
            "itemPropLabel": "学位列表",
            "itemPropName": "degreeList",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "姓名",
                  "itemPropName": "name",
                  "itemPropValue": "范**",
                  "set": false
                },
                {
                  "itemPropLabel": "性别",
                  "itemPropName": "gender",
                  "itemPropValue": "男",
                  "set": false
                },
                {
                  "itemPropLabel": "出生日期",
                  "itemPropName": "birthday",
                  "itemPropValue": "1988-08-26",
                  "set": false
                },
                {
                  "itemPropLabel": "学位授权单位",
                  "itemPropName": "degreeAuthorizationUnit",
                  "itemPropValue": "河北金融学院",
                  "set": false
                },
                {
                  "itemPropLabel": "学位名称",
                  "itemPropName": "degreeName",
                  "itemPropValue": "金融硕士专业学位",
                  "set": false
                },
                {
                  "itemPropLabel": "学位证书编号",
                  "itemPropName": "certificate1Num",
                  "itemPropValue": "114203201******4",
                  "set": false
                },
                {
                  "itemPropLabel": "获学位日期",
                  "itemPropName": "receiveDegreeDate",
                  "itemPropValue": "2017-06-15",
                  "set": false
                },
                {
                  "itemPropLabel": "学位电子注册备案编号",
                  "itemPropName": "degreeRegistrationNumber",
                  "itemPropValue": "170588*****9",
                  "set": false
                },
                {
                  "itemPropLabel": "学位获得者照片",
                  "itemPropName": "degreeWinnerPhoto",
                  "itemPropValue": "*",
                  "set": false
                },
                {
                  "itemPropLabel": "身份一致性检测结果",
                  "itemPropName": "identityUniformity",
                  "itemPropValue": "一致",
                  "set": false
                }
              ]
            ],
            "set": true
          }
        ],
        "callSuccess": true,
        "itemCode": "184",
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true,
        "risk": "无风险"
      },
      "194": {
        "queryCost": 20,
        "itemId": "201804230000054995",
        "itemName": "驾驶证信息查询",
        "itemData": [
          {
            "itemPropLabel": "签发机关",
            "itemPropName": "issueAauthority",
            "itemPropValue": "*",
            "set": false
          },
          {
            "itemPropLabel": "有效期至",
            "itemPropName": "expiryDate",
            "itemPropValue": "*",
            "set": false
          },
          {
            "itemPropLabel": "累计计分",
            "itemPropName": "cumulativeScore",
            "itemPropValue": "*",
            "set": false
          },
          {
            "itemPropLabel": "档案编号",
            "itemPropName": "fileNo",
            "itemPropValue": "*",
            "set": false
          },
          {
            "itemPropLabel": "驾驶证号",
            "itemPropName": "licenseNo",
            "itemPropValue": "*",
            "set": false
          },
          {
            "itemPropLabel": "姓名",
            "itemPropName": "name",
            "itemPropValue": "*",
            "set": false
          },
          {
            "itemPropLabel": "驾驶证状态",
            "itemPropName": "licenseStatus",
            "itemPropValue": "*",
            "set": false
          },
          {
            "itemPropLabel": "准驾车型",
            "itemPropName": "allowDrivingModel",
            "itemPropValue": "*",
            "set": false
          },
          {
            "itemPropLabel": "有效期始",
            "itemPropName": "startDate",
            "itemPropValue": "*",
            "set": false
          }
        ],
        "callSuccess": true,
        "itemCode": "194",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "205": {
        "queryCost": 20,
        "itemId": "1170417191610363057",
        "itemName": "社会不良信息核实",
        "itemData": [
          {
            "itemPropLabel": "比中结果",
            "itemPropName": "intermediateResult",
            "itemPropValue": "0",
            "set": false
          }
        ],
        "callSuccess": true,
        "itemCode": "205",
        "isOffline": 0,
        "source": null,
        "isShowCheck": null,
        "cateName": "黑名单类",
        "cateCode": "03",
        "isSuccess": true,
        "risk": "无风险"
      },
      "261": {
        "queryCost": 20,
        "itemId": "202204130001677360",
        "itemName": "有限诉讼记录核实",
        "itemData": [
          {
            "itemPropLabel": "民事案件",
            "itemPropName": "civilCase",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "诉讼地位",
                  "itemPropName": "litigationStatus",
                  "itemPropValue": "被告",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "所属地域",
                  "itemPropName": "region",
                  "itemPropValue": "河北省",
                  "set": false
                },
                {
                  "itemPropLabel": "案件标识",
                  "itemPropName": "caseIdentification",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "法院所属层级",
                  "itemPropName": "courtLevel",
                  "itemPropValue": "基层法院",
                  "set": false
                },
                {
                  "itemPropLabel": "审理程序",
                  "itemPropName": "trialProcedure",
                  "itemPropValue": "一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件类型",
                  "itemPropName": "caseType",
                  "itemPropValue": "民事一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件进展阶段",
                  "itemPropName": "caseProgress",
                  "itemPropValue": "未结案",
                  "set": false
                },
                {
                  "itemPropLabel": "立案案由",
                  "itemPropName": "causeOfFiling",
                  "itemPropValue": "合同、无因管理、不当得利纠纷",
                  "set": false
                },
                {
                  "itemPropLabel": "经办法院",
                  "itemPropName": "handlingCourt",
                  "itemPropValue": "邯郸市丛台区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "立案时间",
                  "itemPropName": "regDate",
                  "itemPropValue": "2022-01-25",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "刑事案件",
            "itemPropName": "criminalCase",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "诉讼地位",
                  "itemPropName": "litigationStatus",
                  "itemPropValue": "被告",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "所属地域",
                  "itemPropName": "region",
                  "itemPropValue": "河北省",
                  "set": false
                },
                {
                  "itemPropLabel": "案件标识",
                  "itemPropName": "caseIdentification",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "法院所属层级",
                  "itemPropName": "courtLevel",
                  "itemPropValue": "基层法院",
                  "set": false
                },
                {
                  "itemPropLabel": "审理程序",
                  "itemPropName": "trialProcedure",
                  "itemPropValue": "一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件类型",
                  "itemPropName": "caseType",
                  "itemPropValue": "民事一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件进展阶段",
                  "itemPropName": "caseProgress",
                  "itemPropValue": "未结案",
                  "set": false
                },
                {
                  "itemPropLabel": "立案案由",
                  "itemPropName": "causeOfFiling",
                  "itemPropValue": "合同、无因管理、不当得利纠纷",
                  "set": false
                },
                {
                  "itemPropLabel": "经办法院",
                  "itemPropName": "handlingCourt",
                  "itemPropValue": "邯郸市丛台区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "立案时间",
                  "itemPropName": "regDate",
                  "itemPropValue": "2022-01-25",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "行政案件",
            "itemPropName": "administrativeCase",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "诉讼地位",
                  "itemPropName": "litigationStatus",
                  "itemPropValue": "被告",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "所属地域",
                  "itemPropName": "region",
                  "itemPropValue": "河北省",
                  "set": false
                },
                {
                  "itemPropLabel": "案件标识",
                  "itemPropName": "caseIdentification",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "法院所属层级",
                  "itemPropName": "courtLevel",
                  "itemPropValue": "基层法院",
                  "set": false
                },
                {
                  "itemPropLabel": "审理程序",
                  "itemPropName": "trialProcedure",
                  "itemPropValue": "一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件类型",
                  "itemPropName": "caseType",
                  "itemPropValue": "民事一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件进展阶段",
                  "itemPropName": "caseProgress",
                  "itemPropValue": "未结案",
                  "set": false
                },
                {
                  "itemPropLabel": "立案案由",
                  "itemPropName": "causeOfFiling",
                  "itemPropValue": "合同、无因管理、不当得利纠纷",
                  "set": false
                },
                {
                  "itemPropLabel": "经办法院",
                  "itemPropName": "handlingCourt",
                  "itemPropValue": "邯郸市丛台区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "立案时间",
                  "itemPropName": "regDate",
                  "itemPropValue": "2022-01-25",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "非诉保全审查",
            "itemPropName": "preservation",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "诉讼地位",
                  "itemPropName": "litigationStatus",
                  "itemPropValue": "被告",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "所属地域",
                  "itemPropName": "region",
                  "itemPropValue": "河北省",
                  "set": false
                },
                {
                  "itemPropLabel": "案件标识",
                  "itemPropName": "caseIdentification",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "法院所属层级",
                  "itemPropName": "courtLevel",
                  "itemPropValue": "基层法院",
                  "set": false
                },
                {
                  "itemPropLabel": "审理程序",
                  "itemPropName": "trialProcedure",
                  "itemPropValue": "一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件类型",
                  "itemPropName": "caseType",
                  "itemPropValue": "民事一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件进展阶段",
                  "itemPropName": "caseProgress",
                  "itemPropValue": "未结案",
                  "set": false
                },
                {
                  "itemPropLabel": "立案案由",
                  "itemPropName": "causeOfFiling",
                  "itemPropValue": "合同、无因管理、不当得利纠纷",
                  "set": false
                },
                {
                  "itemPropLabel": "经办法院",
                  "itemPropName": "handlingCourt",
                  "itemPropValue": "邯郸市丛台区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "立案时间",
                  "itemPropName": "regDate",
                  "itemPropValue": "2022-01-25",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "执行案件",
            "itemPropName": "executionCase",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "诉讼地位",
                  "itemPropName": "litigationStatus",
                  "itemPropValue": "被告",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "所属地域",
                  "itemPropName": "region",
                  "itemPropValue": "河北省",
                  "set": false
                },
                {
                  "itemPropLabel": "案件标识",
                  "itemPropName": "caseIdentification",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "法院所属层级",
                  "itemPropName": "courtLevel",
                  "itemPropValue": "基层法院",
                  "set": false
                },
                {
                  "itemPropLabel": "审理程序",
                  "itemPropName": "trialProcedure",
                  "itemPropValue": "一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件类型",
                  "itemPropName": "caseType",
                  "itemPropValue": "民事一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件进展阶段",
                  "itemPropName": "caseProgress",
                  "itemPropValue": "未结案",
                  "set": false
                },
                {
                  "itemPropLabel": "立案案由",
                  "itemPropName": "causeOfFiling",
                  "itemPropValue": "合同、无因管理、不当得利纠纷",
                  "set": false
                },
                {
                  "itemPropLabel": "经办法院",
                  "itemPropName": "handlingCourt",
                  "itemPropValue": "邯郸市丛台区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "立案时间",
                  "itemPropName": "regDate",
                  "itemPropValue": "2022-01-25",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "强制清算与破产案件",
            "itemPropName": "bankrupt",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "诉讼地位",
                  "itemPropName": "litigationStatus",
                  "itemPropValue": "被告",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "所属地域",
                  "itemPropName": "region",
                  "itemPropValue": "河北省",
                  "set": false
                },
                {
                  "itemPropLabel": "案件标识",
                  "itemPropName": "caseIdentification",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "法院所属层级",
                  "itemPropName": "courtLevel",
                  "itemPropValue": "基层法院",
                  "set": false
                },
                {
                  "itemPropLabel": "审理程序",
                  "itemPropName": "trialProcedure",
                  "itemPropValue": "一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件类型",
                  "itemPropName": "caseType",
                  "itemPropValue": "民事一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件进展阶段",
                  "itemPropName": "caseProgress",
                  "itemPropValue": "未结案",
                  "set": false
                },
                {
                  "itemPropLabel": "立案案由",
                  "itemPropName": "causeOfFiling",
                  "itemPropValue": "合同、无因管理、不当得利纠纷",
                  "set": false
                },
                {
                  "itemPropLabel": "经办法院",
                  "itemPropName": "handlingCourt",
                  "itemPropValue": "邯郸市丛台区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "立案时间",
                  "itemPropName": "regDate",
                  "itemPropValue": "2022-01-25",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "管辖案件",
            "itemPropName": "jurisdictionCase",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "诉讼地位",
                  "itemPropName": "litigationStatus",
                  "itemPropValue": "被告",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "所属地域",
                  "itemPropName": "region",
                  "itemPropValue": "河北省",
                  "set": false
                },
                {
                  "itemPropLabel": "案件标识",
                  "itemPropName": "caseIdentification",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "法院所属层级",
                  "itemPropName": "courtLevel",
                  "itemPropValue": "基层法院",
                  "set": false
                },
                {
                  "itemPropLabel": "审理程序",
                  "itemPropName": "trialProcedure",
                  "itemPropValue": "一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件类型",
                  "itemPropName": "caseType",
                  "itemPropValue": "民事一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件进展阶段",
                  "itemPropName": "caseProgress",
                  "itemPropValue": "未结案",
                  "set": false
                },
                {
                  "itemPropLabel": "立案案由",
                  "itemPropName": "causeOfFiling",
                  "itemPropValue": "合同、无因管理、不当得利纠纷",
                  "set": false
                },
                {
                  "itemPropLabel": "经办法院",
                  "itemPropName": "handlingCourt",
                  "itemPropValue": "邯郸市丛台区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "立案时间",
                  "itemPropName": "regDate",
                  "itemPropValue": "2022-01-25",
                  "set": false
                }
              ]
            ],
            "set": true
          },
          {
            "itemPropLabel": "赔偿案件",
            "itemPropName": "compensationCases",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "诉讼地位",
                  "itemPropName": "litigationStatus",
                  "itemPropValue": "被告",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "所属地域",
                  "itemPropName": "region",
                  "itemPropValue": "河北省",
                  "set": false
                },
                {
                  "itemPropLabel": "案件标识",
                  "itemPropName": "caseIdentification",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "法院所属层级",
                  "itemPropName": "courtLevel",
                  "itemPropValue": "基层法院",
                  "set": false
                },
                {
                  "itemPropLabel": "审理程序",
                  "itemPropName": "trialProcedure",
                  "itemPropValue": "一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件类型",
                  "itemPropName": "caseType",
                  "itemPropValue": "民事一审",
                  "set": false
                },
                {
                  "itemPropLabel": "案件进展阶段",
                  "itemPropName": "caseProgress",
                  "itemPropValue": "未结案",
                  "set": false
                },
                {
                  "itemPropLabel": "立案案由",
                  "itemPropName": "causeOfFiling",
                  "itemPropValue": "合同、无因管理、不当得利纠纷",
                  "set": false
                },
                {
                  "itemPropLabel": "经办法院",
                  "itemPropName": "handlingCourt",
                  "itemPropValue": "邯郸市丛台区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "立案时间",
                  "itemPropName": "regDate",
                  "itemPropValue": "2022-01-25",
                  "set": false
                }
              ]
            ],
            "set": true
          }
        ],
        "callSuccess": true,
        "itemCode": "261",
        "isOffline": 0,
        "source": null,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true,
        "risk": "一般风险"
      },
      "403": {
        "queryCost": 20,
        "itemId": "201806260000083214",
        "itemName": "中国大陆高等教育学历核实",
        "itemData": [
          {
            "itemPropLabel": "学历列表",
            "itemPropName": "eduInfoList",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "毕业照片",
                  "itemPropName": "graduationPictures",
                  "itemPropValue": "***",
                  "set": false
                },
                {
                  "itemPropLabel": "姓名",
                  "itemPropName": "name",
                  "itemPropValue": "李**",
                  "set": false
                },
                {
                  "itemPropLabel": "性别",
                  "itemPropName": "gender",
                  "itemPropValue": "男",
                  "set": false
                },
                {
                  "itemPropLabel": "出生日期",
                  "itemPropName": "birthday",
                  "itemPropValue": "1996年10月12日",
                  "set": false
                },
                {
                  "itemPropLabel": "入学时间",
                  "itemPropName": "entranceTime",
                  "itemPropValue": "2015年08月29日",
                  "set": false
                },
                {
                  "itemPropLabel": "毕业时间",
                  "itemPropName": "graduationTime",
                  "itemPropValue": "2019年07月25日",
                  "set": false
                },
                {
                  "itemPropLabel": "毕业学校",
                  "itemPropName": "graduateCollege",
                  "itemPropValue": "西交***大学",
                  "set": false
                },
                {
                  "itemPropLabel": "专业",
                  "itemPropName": "major",
                  "itemPropValue": "金融数学",
                  "set": false
                },
                {
                  "itemPropLabel": "学历类别",
                  "itemPropName": "educationCategory",
                  "itemPropValue": "普通高等教育",
                  "set": false
                },
                {
                  "itemPropLabel": "学制",
                  "itemPropName": "schoolLength",
                  "itemPropValue": "4",
                  "set": false
                },
                {
                  "itemPropLabel": "学习形式",
                  "itemPropName": "studyType",
                  "itemPropValue": "普通全日制",
                  "set": false
                },
                {
                  "itemPropLabel": "学历层次",
                  "itemPropName": "studyLevel",
                  "itemPropValue": "本科",
                  "set": false
                },
                {
                  "itemPropLabel": "毕业结论",
                  "itemPropName": "graduationConclusion",
                  "itemPropValue": "毕业",
                  "set": false
                },
                {
                  "itemPropLabel": "校（院）长姓名",
                  "itemPropName": "principalName",
                  "itemPropValue": "席酉民",
                  "set": false
                },
                {
                  "itemPropLabel": "证书编号",
                  "itemPropName": "certificateId",
                  "itemPropValue": "***",
                  "set": false
                },
                {
                  "itemPropLabel": "辅修学校",
                  "itemPropName": "minorSchool",
                  "itemPropValue": "",
                  "set": false
                },
                {
                  "itemPropLabel": "辅修专业",
                  "itemPropName": "minorMajor",
                  "itemPropValue": "",
                  "set": false
                },
                {
                  "itemPropLabel": "辅修发证日期",
                  "itemPropName": "minorDate",
                  "itemPropValue": "",
                  "set": false
                },
                {
                  "itemPropLabel": "辅修起止日期",
                  "itemPropName": "minorStartAndEndDate",
                  "itemPropValue": "",
                  "set": false
                },
                {
                  "itemPropLabel": "身份一致性检测结果",
                  "itemPropName": "identityUniformity",
                  "itemPropValue": "一致",
                  "set": false
                },
                {
                  "itemPropLabel": "备注",
                  "itemPropName": "remarks",
                  "itemPropValue": "中外合作办学",
                  "set": false
                }
              ]
            ],
            "set": true
          }
        ],
        "callSuccess": true,
        "itemCode": "403",
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true,
        "risk": "无风险"
      },
      "418": {
        "itemId": "201811140000133416",
        "itemName": "会计专业资格核实",
        "itemData": [
          {
            "itemPropLabel": "姓名",
            "itemPropName": "name",
            "itemPropValue": "李某某",
            "set": false
          },
          {
            "itemPropLabel": "性别",
            "itemPropName": "gender",
            "itemPropValue": "女",
            "set": false
          },
          {
            "itemPropLabel": "成绩",
            "itemPropName": "achievement",
            "itemPropValue": "合格",
            "set": false
          },
          {
            "itemPropLabel": "证书编号",
            "itemPropName": "certificateId",
            "itemPropValue": "11****8653",
            "set": false
          },
          {
            "itemPropLabel": "照片",
            "itemPropName": "photo",
            "itemPropValue": "http://",
            "set": false
          }
        ],
        "callSuccess": true,
        "itemCode": "418",
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "421": {
        "queryCost": 20,
        "itemId": "201812250000149975",
        "itemName": "道德不良风险记录核实",
        "itemData": [
          {
            "itemPropLabel": "道德分",
            "itemPropName": "moralityScore",
            "itemPropValue": 51,
            "set": false
          }
        ],
        "callSuccess": true,
        "itemCode": "421",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "423": {
        "queryCost": 20,
        "itemId": "201901120000160284",
        "itemName": "税务违法不良记录核实",
        "itemData": [
          {
            "itemPropLabel": "相关人记录数",
            "itemPropName": "aboutPersonNum",
            "itemPropValue": 1,
            "set": false
          },
          {
            "itemPropLabel": "记录列表",
            "itemPropName": "recordList",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "姓名",
                  "itemPropName": "name",
                  "itemPropValue": "***",
                  "set": false
                },
                {
                  "itemPropLabel": "性别",
                  "itemPropName": "gender",
                  "itemPropValue": "男",
                  "set": false
                },
                {
                  "itemPropLabel": "证件类型",
                  "itemPropName": "cardType",
                  "itemPropValue": "身份证",
                  "set": false
                },
                {
                  "itemPropLabel": "证件号码",
                  "itemPropName": "cardNo",
                  "itemPropValue": "320124********1616",
                  "set": false
                },
                {
                  "itemPropLabel": "负有直接责任的中介机构信息及其从业人员信息",
                  "itemPropName": "otherPerson",
                  "itemPropValue": "",
                  "set": false
                },
                {
                  "itemPropLabel": "案件性质",
                  "itemPropName": "caseNature",
                  "itemPropValue": "偷税",
                  "set": false
                },
                {
                  "itemPropLabel": "主要违法事实",
                  "itemPropName": "illegfact",
                  "itemPropValue":
                      "2013-09-27至2013-12-31，经南京市溧水地税稽查局检查，发现其在2012-01-01至2013-08-31期间，主要存在以下问题:2012年11月采取虚开房地产开发销售（扣税）发票用于抵扣销售收入的手段，少纳税款301.5万元。",
                  "set": false
                },
                {
                  "itemPropLabel": "法律依据及税务处理处罚情况",
                  "itemPropName": "legalBasisPunishmentSituation",
                  "itemPropValue":
                      "依照《中华人民共和国税收征收管理法》，《中华人民共和国税收征收管理法实施细则》，《中华人民共和国个人所得税法》，《中华人民共和国个人所得税法实施条例》，《中华人民共和国营业税暂行条例》，《中华人民共和国营业税暂行条例实施细则》，《中华人民共和国土地增值税暂行条例》，《中华人民共和国城市维护建设税暂行条例》，《中华人民共和国征收教育费附加的暂行规定》，《中华人民共和国发票管理办法》，《中华人民共和国发票管理办法实施细则》等法律法规的有关规定，其上述行为被认定为偷税，被处以追缴税款301.95万元的行政处理。",
                  "set": false
                }
              ]
            ],
            "set": true
          }
        ],
        "callSuccess": true,
        "itemCode": "423",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "425": {
        "queryCost": 20,
        "itemId": "201901260000100987",
        "itemName": "违禁药品风险核实",
        "itemData": [
          {
            "itemPropLabel": "xrc分数",
            "itemPropName": "xrcScore",
            "itemPropValue": 48,
            "set": false
          }
        ],
        "callSuccess": true,
        "itemCode": "425",
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "452": {
        "queryCost": 20,
        "itemId": "201905100000238050",
        "itemName": "法院失信被执行人核实",
        "itemData": [
          {
            "itemPropLabel": "详情内容",
            "itemPropName": "value",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "姓名",
                  "itemPropName": "name",
                  "itemPropValue": "***",
                  "set": false
                },
                {
                  "itemPropLabel": "身份证号",
                  "itemPropName": "idNo",
                  "itemPropValue": "**********",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "(20**)渝01**执**号",
                  "set": false
                },
                {
                  "itemPropLabel": "法定代表人/负责人姓名",
                  "itemPropName": "businessentity",
                  "itemPropValue": "",
                  "set": false
                },
                {
                  "itemPropLabel": "执行法院",
                  "itemPropName": "executive",
                  "itemPropValue": "重庆市渝中区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "省份",
                  "itemPropName": "province",
                  "itemPropValue": "重庆",
                  "set": false
                },
                {
                  "itemPropLabel": "类型",
                  "itemPropName": "type1",
                  "itemPropValue": "自然人",
                  "set": false
                },
                {
                  "itemPropLabel": "执行依据文号",
                  "itemPropName": "yjCode",
                  "itemPropValue": "(20**)渝01**民初**号",
                  "set": false
                },
                {
                  "itemPropLabel": "立案时间",
                  "itemPropName": "regDate",
                  "itemPropValue": "2019-11-13",
                  "set": false
                },
                {
                  "itemPropLabel": "做出执行依据单位",
                  "itemPropName": "yjdw",
                  "itemPropValue": "重庆市渝中区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "生效法律文书确定的义务",
                  "itemPropName": "duty",
                  "itemPropValue": "**",
                  "set": false
                },
                {
                  "itemPropLabel": "被执行人的履行情况",
                  "itemPropName": "lxqk",
                  "itemPropValue": "全部未履行",
                  "set": false
                },
                {
                  "itemPropLabel": "已履行(元)",
                  "itemPropName": "performedpart",
                  "itemPropValue": "暂无",
                  "set": false
                },
                {
                  "itemPropLabel": "未履行(元)",
                  "itemPropName": "unperformpart",
                  "itemPropValue": "暂无",
                  "set": false
                },
                {
                  "itemPropLabel": "失信类型",
                  "itemPropName": "disruptTypeName",
                  "itemPropValue": "有履行能力而拒不履行生效法律文书确定义务",
                  "set": false
                },
                {
                  "itemPropLabel": "发布日期",
                  "itemPropName": "publishDate",
                  "itemPropValue": "20**-**-**",
                  "set": false
                },
                {
                  "itemPropLabel": "命中类型",
                  "itemPropName": "relateType",
                  "itemPropValue": "失信被执行人",
                  "set": false
                },
                {
                  "itemPropLabel": "下架状态",
                  "itemPropName": "lowerShelfState",
                  "itemPropValue": "未下架",
                  "set": false
                }
              ]
            ],
            "set": true
          }
        ],
        "callSuccess": true,
        "itemCode": "452",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "453": {
        "queryCost": 20,
        "itemId": "201905100000238052",
        "itemName": "法院被执行人核实",
        "itemData": [
          {
            "itemPropLabel": "详情",
            "itemPropName": "detail",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "姓名",
                  "itemPropName": "name",
                  "itemPropValue": "吴**",
                  "set": false
                },
                {
                  "itemPropLabel": "身份证号",
                  "itemPropName": "idNo",
                  "itemPropValue": "512224********0067",
                  "set": false
                },
                {
                  "itemPropLabel": "执行法院",
                  "itemPropName": "executive",
                  "itemPropValue": "重庆市渝中区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "案件状态",
                  "itemPropName": "caseState",
                  "itemPropValue": "已终本",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "(2019)渝0103执17815号",
                  "set": false
                },
                {
                  "itemPropLabel": "执行标的",
                  "itemPropName": "matter",
                  "itemPropValue": "461111",
                  "set": false
                },
                {
                  "itemPropLabel": "立案时间",
                  "itemPropName": "regDate",
                  "itemPropValue": "2019-11-13",
                  "set": false
                },
                {
                  "itemPropLabel": "命中类型",
                  "itemPropName": "relateType",
                  "itemPropValue": "被执行人",
                  "set": false
                }
              ]
            ],
            "set": true
          }
        ],
        "callSuccess": true,
        "itemCode": "453",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "746": {
        "queryCost": 1,
        "itemId": "1170718104123445001",
        "itemName": "国际高等教育学历核实",
        "itemData": [
          {
            "itemPropLabel": "姓名",
            "itemPropName": "name",
            "itemPropValue": "周*",
            "set": false
          },
          {
            "itemPropLabel": "性别",
            "itemPropName": "gender",
            "itemPropValue": "男",
            "set": false
          },
          {
            "itemPropLabel": "国籍",
            "itemPropName": "nationality",
            "itemPropValue": "中国",
            "set": false
          },
          {
            "itemPropLabel": "出生日期",
            "itemPropName": "birthday",
            "itemPropValue": "1987年1月15日",
            "set": false
          },
          {
            "itemPropLabel": "出生地",
            "itemPropName": "birthPlace",
            "itemPropValue": "湖南省",
            "set": false
          },
          {
            "itemPropLabel": "学习时间段",
            "itemPropName": "studyTime",
            "itemPropValue": "2008年9月起",
            "set": false
          },
          {
            "itemPropLabel": "国际学历学校",
            "itemPropName": "internationalEduSchool",
            "itemPropValue": "法国格勒诺布尔第二大学",
            "set": false
          },
          {
            "itemPropLabel": "学校英文名称",
            "itemPropName": "enSchoolName",
            "itemPropValue": "UniversitédeGrenoble2PierreMendesFrance",
            "set": false
          },
          {
            "itemPropLabel": "专业",
            "itemPropName": "major",
            "itemPropValue": "经济与管理专业",
            "set": false
          },
          {
            "itemPropLabel": "获得证书时间",
            "itemPropName": "certificateTime",
            "itemPropValue": "2012年12月",
            "set": false
          },
          {
            "itemPropLabel": "获得证书名称",
            "itemPropName": "certificateName",
            "itemPropValue": "学士学位证书（Licence）",
            "set": false
          },
          {
            "itemPropLabel": "学校情况",
            "itemPropName": "schoolInfo",
            "itemPropValue": "法国正规高等学校",
            "set": false
          },
          {
            "itemPropLabel": "认证说明",
            "itemPropName": "certificateInfo",
            "itemPropValue": "所获学士学位证书表明其具有相应的学历",
            "set": false
          },
          {
            "itemPropLabel": "认证机构",
            "itemPropName": "certTail",
            "itemPropValue": "教育部留学服务中心",
            "set": false
          },
          {
            "itemPropLabel": "认证日期",
            "itemPropName": "certDateTime",
            "itemPropValue": "二〇一五年八月二十八日",
            "set": false
          },
          {
            "itemPropLabel": "头像图片",
            "itemPropName": "headPortraitImg",
            "itemPropValue": "",
            "set": false
          }
        ],
        "callSuccess": true,
        "itemCode": "746",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "校验类",
        "cateCode": "01",
        "isSuccess": true
      },
      "755": {
        "queryCost": 20,
        "itemId": "202003070000630248",
        "itemName": "开庭公告记录核实",
        "itemData": [
          {
            "itemPropLabel": "开庭公告摘要",
            "itemPropName": "ktggList",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "匹配度",
                  "itemPropName": "matchRatio",
                  "itemPropValue": "99.05%",
                  "set": false
                },
                {
                  "itemPropLabel": "裁判文书内容",
                  "itemPropName": "cpwsContent",
                  "itemPropValue": "中级法院 中级法院 被告 51...",
                  "set": false
                },
                {
                  "itemPropLabel": "标题",
                  "itemPropName": "title",
                  "itemPropValue": "走私国家禁止进出口的货物、物品罪",
                  "set": false
                },
                {
                  "itemPropLabel": "开庭公告ID",
                  "itemPropName": "ktggId",
                  "itemPropValue": "c20175101",
                  "set": false
                }
              ],
              [
                {
                  "itemPropLabel": "匹配度",
                  "itemPropName": "matchRatio",
                  "itemPropValue": "99.05%",
                  "set": false
                },
                {
                  "itemPropLabel": "裁判文书内容",
                  "itemPropName": "cpwsContent",
                  "itemPropValue": "中级法院 中级法院 被告 51...",
                  "set": false
                },
                {
                  "itemPropLabel": "标题",
                  "itemPropName": "title",
                  "itemPropValue": "开庭公告",
                  "set": false
                },
                {
                  "itemPropLabel": "开庭公告ID",
                  "itemPropName": "ktggId",
                  "itemPropValue": "c20175101",
                  "set": false
                }
              ]
            ],
            "set": true
          }
        ],
        "callSuccess": true,
        "itemCode": "755",
        "isOffline": 0,
        "source": null,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true,
        "risk": "一般风险"
      },
      "757": {
        "queryCost": 5,
        "itemId": "202003070000631003",
        "itemName": "限制高消费名单记录核实",
        "itemData": [
          {
            "itemPropLabel": "限制高消费名单",
            "itemPropName": "xiangao",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "数据原始主键",
                  "itemPropName": "keyid",
                  "itemPropValue": "****",
                  "set": false
                },
                {
                  "itemPropLabel": "数据原始类别编号",
                  "itemPropName": "typet",
                  "itemPropValue": 148,
                  "set": false
                },
                {
                  "itemPropLabel": "数据类型",
                  "itemPropName": "dataType",
                  "itemPropValue": "限制高消费被执行人",
                  "set": false
                },
                {
                  "itemPropLabel": "标题",
                  "itemPropName": "title",
                  "itemPropValue": "***(限制高消费被执行人)",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "***8",
                  "set": false
                },
                {
                  "itemPropLabel": "机关",
                  "itemPropName": "office",
                  "itemPropValue": "北京市朝阳区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "金额",
                  "itemPropName": "amount",
                  "itemPropValue": "",
                  "set": false
                },
                {
                  "itemPropLabel": "内容",
                  "itemPropName": "socialContent",
                  "itemPropValue": "",
                  "set": false
                },
                {
                  "itemPropLabel": "收录时案件状态",
                  "itemPropName": "inclusionCaseStatus",
                  "itemPropValue": "",
                  "set": false
                },
                {
                  "itemPropLabel": "备注",
                  "itemPropName": "remarks",
                  "itemPropValue": "匹配度：100%",
                  "set": false
                }
              ]
            ],
            "set": true
          }
        ],
        "callSuccess": true,
        "itemCode": "757",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "764": {
        "queryCost": 20,
        "itemId": "202003300000644956",
        "itemName": "刑事裁判文书核实",
        "itemData": [
          {
            "itemPropLabel": "详情",
            "itemPropName": "detail",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "发布时间",
                  "itemPropName": "releaseDate",
                  "itemPropValue": "2018-03-22",
                  "set": false
                },
                {
                  "itemPropLabel": "判决结果",
                  "itemPropName": "decisionResult",
                  "itemPropValue": "驳回李青、王大良、吴天舒、代旭的上诉，维持原判。本裁定为终审裁定。",
                  "set": false
                },
                {
                  "itemPropLabel": "匹配度",
                  "itemPropName": "matchRatio",
                  "itemPropValue": "40.05%",
                  "set": false
                },
                {
                  "itemPropLabel": "法院名称",
                  "itemPropName": "courtName",
                  "itemPropValue": "北京市第二中级人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "标题",
                  "itemPropName": "title",
                  "itemPropValue": "吴天舒等二审刑事裁定书",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "（2018）京02刑终130号",
                  "set": false
                },
                {
                  "itemPropLabel": "案件类型",
                  "itemPropName": "caseType",
                  "itemPropValue": "刑事裁定书",
                  "set": false
                }
              ],
              [
                {
                  "itemPropLabel": "发布时间",
                  "itemPropName": "releaseDate",
                  "itemPropValue": "2017-12-28",
                  "set": false
                },
                {
                  "itemPropLabel": "判决结果",
                  "itemPropName": "decisionResult",
                  "itemPropValue":
                      "一、被告人李青犯国有公司人员滥用职权罪，判处有期徒刑二年六个月。（刑期自本判决执行之日起计算，判决执行前先行羁押的，羁押一日折抵刑期一日，即自2017年12月28日起至2018年5月24日止，已扣除先行羁押的二年一个月零三日。）二、被告人王大良犯国有公司人员滥用职权罪，判处有期徒刑二年四个月。（刑期自本判决执行之日起计算，判决执行前先行羁押的，羁押一日折抵刑期一日，即自2017年12月28日起至2018年3月24日止，已扣除先行羁押的二年一个月零三日。）三、被告人吴天舒犯国有公司人员滥用职权罪，判处有期徒刑一年四个月，缓刑二年。（缓刑考验期限从判决确定之日起计算。）四、被告人代旭犯国有公司人员失职罪，判处有期徒刑二年四个月。（刑期自本判决执行之日起计算，判决执行前先行羁押的，羁押一日折抵刑期一日，即自2017年12月28日起至2018年3月24日止，已扣除先行羁押的二年一个月零三日。）五、责令被告人李青退赔人民币五十五万六千九百一十九元三角六分、被告人王大良退赔人民币三十九万一千三百六十元七角四分、被告人吴天舒退赔人民币五十五元七角、被告人代旭退赔人民币七十八万二千七百二十一元四角七分，发还中国银河证券股份有限公司。如不服本判决，可在接到判决书的第二日起十日内，通过本院或者直接向北京市第二中级人民法院提出上诉。书面上诉的，应当提交上诉状正本一份，副本一份。",
                  "set": false
                },
                {
                  "itemPropLabel": "匹配度",
                  "itemPropName": "matchRatio",
                  "itemPropValue": "40.05%",
                  "set": false
                },
                {
                  "itemPropLabel": "法院名称",
                  "itemPropName": "courtName",
                  "itemPropValue": "北京市西城区人民法院",
                  "set": false
                },
                {
                  "itemPropLabel": "标题",
                  "itemPropName": "title",
                  "itemPropValue": "吴天舒等一审刑事判决书",
                  "set": false
                },
                {
                  "itemPropLabel": "案号",
                  "itemPropName": "refNum",
                  "itemPropValue": "（2015）西刑初字第779号",
                  "set": false
                },
                {
                  "itemPropLabel": "案件类型",
                  "itemPropName": "caseType",
                  "itemPropValue": "刑事判决书",
                  "set": false
                }
              ]
            ],
            "set": true
          }
        ],
        "callSuccess": true,
        "itemCode": "764",
        "isOffline": 0,
        "source": null,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true,
        "risk": "待复核"
      },
      "769": {
        "queryCost": 20,
        "itemId": "202003310000646500",
        "itemName": "限制出入境核实",
        "itemData": [
          {
            "itemPropLabel": "限制出入境名单",
            "itemPropName": "xianchu",
            "itemPropValue": [
              [
                {
                  "itemPropLabel": "数据原始主键",
                  "itemPropName": "keyid",
                  "itemPropValue": 12689925,
                  "set": false
                },
                {
                  "itemPropLabel": "证件号码",
                  "itemPropName": "cardNo",
                  "itemPropValue": "*********************",
                  "set": false
                },
                {
                  "itemPropLabel": "列入原因",
                  "itemPropName": "inreason",
                  "itemPropValue": "严重违法失信行为",
                  "set": false
                },
                {
                  "itemPropLabel": "法律文书名称",
                  "itemPropName": "legalInstrumentName",
                  "itemPropValue": "**行政处罚决定书",
                  "set": false
                },
                {
                  "itemPropLabel": "法律文书编号",
                  "itemPropName": "legalInstrumentNo",
                  "itemPropValue": "**行罚决字[2019]197号",
                  "set": false
                },
                {
                  "itemPropLabel": "生效时间",
                  "itemPropName": "TakeeffectDate",
                  "itemPropValue": "2019-08-12",
                  "set": false
                },
                {
                  "itemPropLabel": "失效时间",
                  "itemPropName": "invalidDate",
                  "itemPropValue": "020-08-11",
                  "set": false
                }
              ]
            ],
            "set": true
          }
        ],
        "callSuccess": true,
        "itemCode": "769",
        "isOffline": 0,
        "isShowCheck": null,
        "cateName": "查询类",
        "cateCode": "02",
        "isSuccess": true
      },
      "001": {
        "queryCost": 10,
        "itemId": "1170315165001801003",
        "itemName": "身份核实",
        "itemData": [
          {
            "itemPropLabel": "校验结果",
            "itemPropName": "checkResult",
            "itemPropValue": "校验通过",
            "set": false
          }
        ],
        "callSuccess": true,
        "itemCode": "001",
        "isOffline": 0,
        "source": null,
        "isShowCheck": null,
        "cateName": "校验类",
        "cateCode": "01",
        "isSuccess": true,
        "risk": "无风险"
      }
    },
    "beforeEmployerRefereeInfoList": null,
    "inputMap": {
      "birthday": "19990520",
      "authStuffUrl": null,
      "report_notify_url": "http://39.105.208.25:58085/zhima/notify",
      "isSendSignSms": "1",
      "areaType": 1,
      "sex": "男",
      "name": "赵蓝天",
      "mobile": "15300266275",
      "tplId": "202302090000368319",
      "idNo": "370402199905207735",
      "certificationRequire": "3",
      "age": 23,
      "operatorDiplomaNumber": "0000000000000000000",
      "certificateNumber": "00000000000000000",
      "certLevel": "其他",
      "driverLicenseFileNumber": "370402199905207735",
      "diplomaNumber": "00000000000000000",
      "degreeLevel": "其他",
      "examinationLevel": "无",
      "examinationYear": "",
      "examinationProvince": "",
      "internationalEduNumber": "000000000000",
      "gjDegreeLevel": "其他",
      "operatorDiplomaImage": "",
      "examinationImage": ""
    }
  };

  static getReportData(String reportId, NetworkMapCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
        NetworkingUrls.zhimaInfo,
        queryParameters: {"reportId": reportId});

    callBack(response.data);
    // callBack(ReportDataBean.fromJson(response.data));
  }

  static getPartReportData(
      String reportId, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
        NetworkingUrls.zhimaInfo,
        queryParameters: {"reportId": reportId});

    callBack(PartialReportModel.fromJson(response.data));
  }

  static getFinanceRiskPartReportData(
      String reportId, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
        NetworkingUrls.zhimaInfo,
        queryParameters: {"reportId": reportId});

    callBack(FinancialRiskPartialReportModel.fromJson(response.data));
  }

  static getAuthStuffUrl(String authId, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
        NetworkingUrls.authStuffUrl,
        queryParameters: {"authId": authId});
    callBack(response.data);
  }
}
