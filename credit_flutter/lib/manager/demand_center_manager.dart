import 'package:credit_flutter/models/demand_center_bean.dart';
import 'package:credit_flutter/models/demand_details_bean.dart';
import 'package:credit_flutter/models/my_needs_bean.dart';
import 'package:dio/dio.dart';

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';

class DemandCenterManager {
  static getDemandCenterList(
      Map<String, dynamic> map, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.demandCenterList, queryParameters: map);

    callBack(DemandCenterBean.fromJson(response.data));
  }

  static getDemandCenterInfo(
      Map<String, dynamic> map, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.demandCenterInfo, queryParameters: map);

    callBack(DemandDetailsBean.fromJson(response.data));
  }

  static putDemandCenterSave(
      Map<String, dynamic> map, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.demandCenterSave, queryParameters: map);

    callBack(response.data);
  }

  static getDemandCenterMyList(
      Map<String, dynamic> map, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.demandCenterMyList, queryParameters: map);

    callBack(MyNeedsBean.fromJson(response.data));
  }

  static demandCenterMyDelete(String id, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.demandCenterMyDelete, queryParameters: {
      "id": id,
    });
    callBack(response.data.toString());
  }

  static demandCenterMyResubmit(
      String id, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.demandCenterMyResubmit, queryParameters: {
      "id": id,
    });
    callBack(response.data);
  }
}
