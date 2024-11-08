import 'package:credit_flutter/define/define_block.dart';
import 'package:credit_flutter/define/define_url.dart';
import 'package:credit_flutter/models/news_details_model.dart';
import 'package:credit_flutter/models/news_list_model.dart';
import 'package:dio/dio.dart';

import '../network/dio_client.dart';

class NewsManger {
  static Future<NewsDetailsModel> getNews(Map<String, dynamic> param) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.urlGetNews, queryParameters: param);
    return NewsDetailsModel.fromJson(response.data);
  }

  static getNewsList(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.urlGetNewsList, queryParameters: param);
    callBack(NewsListModel.fromJson(response.data));
  }
}
