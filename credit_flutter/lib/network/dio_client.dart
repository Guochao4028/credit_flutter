/// *
/// -  @Date: 2022-09-05 16:52
/// -  @LastEditTime: 2022-09-09 17:45
/// -  @Description:
///
/// *
/// @Date: 2022-06-07 11:29
/// @LastEditTime: 2022-06-07 16:04
/// @Description:网络层
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/define/define_url.dart';
import 'package:dio/dio.dart';

import 'core/option_interceptor.dart';
import 'core/request_interceptor.dart';

class DioClient {
  static DioClient? _instance;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(milliseconds: FinalKeys.CONNECT_TIME_OUT),
      receiveTimeout: const Duration(milliseconds: FinalKeys.RECEIVE_TIME_OUT),
      baseUrl: FinalKeys.baseServer(),
    ),
  );

  factory DioClient() => _instance ??= DioClient._init();

  DioClient._init() {
    //处理头部
    _dio.interceptors.add(OptionInterceptor());
    //处理网络缓存
    //处理回来的数据
    _dio.interceptors.add(RequestInterceptor());
    // proxy();
  }

  ///get请求
  doGet<T>(path, {queryParameters}) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
    );
  }

  doDelete<T>(path, {queryParameters}) {
    // http.delete(Uri(host: FinalKeys.BASE_SERVER, path: path),
    //     body: queryParameters);
    return _dio.delete(
      path,
      queryParameters: queryParameters,
    );
  }

  ///post请求
  doPost(path, {queryParameters, options, data}) {
    return _dio.post(path,
        queryParameters: queryParameters, options: options, data: data);
  }

  getDio() {
    return _dio;
  }


  ///上传文件
  uploadFile(formData) {
    var uploadOptions = Options(contentType: "multipart/form-data");
    return doPost(NetworkingUrls.uploadImage,
        options: uploadOptions, data: formData);
  }
}
