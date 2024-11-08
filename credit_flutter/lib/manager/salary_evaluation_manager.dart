import 'package:credit_flutter/models/remuneration_report_bean.dart';
import 'package:credit_flutter/models/salary_evaluation_bean.dart';
import 'package:dio/dio.dart';

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';

/// @Description: 薪资测评
class SalaryEvaluationManager {
  static getSalaryLabelList(NetworkListCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doGet(NetworkingUrls.salaryLabelList);

    callBack(getSalaryEvaluationBeanList(response.data));
  }

  static getSalarySearch(
      Map<String, dynamic> map, NetworkListCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.salarySearch, queryParameters: map);

    callBack(getSalaryEvaluationBeanList(response.data));
  }

  static getSalaryInfo(String labelId, NetworkObjectCallBack callBack) async {
    Map<String, dynamic> map = {
      "labelId": labelId,
    };
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.salaryInfo, queryParameters: map);
    var data = RemunerationReportBean.fromJson(response.data);
    callBack(data);
  }
}
