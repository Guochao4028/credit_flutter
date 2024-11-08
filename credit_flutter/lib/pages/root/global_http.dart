/// *
/// -  @Date: 2022-07-14 15:34
/// -  @LastEditTime: 2022-07-14 15:34
/// -  @Description: 全局忽略https证书
import 'dart:io';

class GlobalHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
