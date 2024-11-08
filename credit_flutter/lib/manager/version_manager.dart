import 'dart:io';

import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/faq_model.dart';
import 'package:credit_flutter/models/project_switch_model.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';

class VersionManager {
  static getAppVersion(NetworkMapCallBack callBack) async {
    var type = PlatformUtils.isIOS ? 1 : 2;

    var channel = 0;
    //1、华为
    //  2、小米
    //  3、VIVO
    //  4、OPPO
    //  5、应用宝
    //  6、百度
    switch (FinalKeys.umengChannel) {
      case "HUAWEI":
        channel = 1;
        break;
      case "VIVO":
        channel = 3;
        break;
      case "BAIDU":
        channel = 6;
        break;
      case "OPPO":
        channel = 4;
        break;
      case "MILLET":
        channel = 2;
        break;
      case "TENCENT":
        channel = 5;
        break;
    }

    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.appVersion, queryParameters: {
      "type": type,
      "channel": channel,
      "hideLoading": true
    });
    callBack(response.data);
  }

  static download(String url, String name, NetworkMapCallBack schedule,
      NetworkStringCallBack callBack) async {
    Directory? directory = await getExternalStorageDirectory();

    var path = "${directory?.path}/$name.apk";

    Dio dio = Dio(
      BaseOptions(
        connectTimeout:
            const Duration(milliseconds: FinalKeys.CONNECT_TIME_OUT),
        receiveTimeout:
            const Duration(milliseconds: FinalKeys.RECEIVE_TIME_OUT),
        baseUrl: FinalKeys.baseServer(),
      ),
    );

    var history = 0;
    await dio.download(url, path, onReceiveProgress: (receive, total) {
      var progress = ((receive / total) * 100).toStringAsFixed(0);
      if (history == 0) {
        schedule({"receive": receive, "total": total});
      } else {
        if (int.parse(progress) > history) {
          history = int.parse(progress);
          Log.i("进度-$progress");
          schedule({"receive": receive, "total": total});
        }
      }
    });
    callBack(path);
  }

  static projectSwitch(NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.projectSwitch,
        queryParameters: {"hideLoading": true, "pageNum": 1, "pageSize": 50});
    callBack(ProjectSwitchModel.fromJson(response.data));
  }

  static addOpinion(String content, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.addOpinion,
        queryParameters: {"content": content});
    callBack(response.data);
  }

  static getFAQ(NetworkListCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
      NetworkingUrls.faqInfoList,
      queryParameters: {"pageSize": 50},
    );
    callBack(getFAQModelList(response.data['data']));
  }
}
